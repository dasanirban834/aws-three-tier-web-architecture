# ########################################################################
# #                                                                      #
# #             :: Create instance profile ::                            #
# #                                                                      #
# ########################################################################

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_profile
  role = data.aws_iam_role.role.name
}

# ########################################################################
# #                                                                      #
# #             :: Create Web Tier Instances ::                          #
# #                                                                      #
# ########################################################################

resource "aws_instance" "instance" {
  for_each                    = var.instance_details
  instance_type               = each.value.instance_type
  ami                         = each.value.ami
  associate_public_ip_address = each.value.associate_public_ip_address
  source_dest_check           = each.value.source_dest_check
  availability_zone           = each.value.availability_zone
  key_name                    = data.aws_key_pair.key.key_name
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  subnet_id                   = (each.value.availability_zone == "us-east-1a" ? data.aws_subnet.web_subnet_1a.id : (each.value.availability_zone == "us-east-1b" ? data.aws_subnet.web_subnet_1b.id : "0"))
  vpc_security_group_ids      = [data.aws_security_group.sg.id]
  root_block_device {
    volume_size = each.value.root_block_device.root_block.volume_size
    volume_type = each.value.root_block_device.root_block.volume_type
  }
  user_data = "${file("user_data.sh")}"
  #ebs_block_device {}
  tags = merge({Name = "${each.key}"}, var.instance_tags)
}