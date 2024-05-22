resource "aws_instance" "zookeeper" {
  ami                    = var.aws_ami
  instance_type          = var.instance_types["zookeeper"]
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.default.id]
  count                  = var.num_zookeeper_nodes

  tags = {
    Name = "zookeeper-${count.index + 1}"
  }
}

resource "aws_instance" "bookie" {
  ami                    = var.aws_ami
  instance_type          = var.instance_types["bookie"]
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.default.id]
  count                  = var.num_bookie_nodes

  tags = {
    Name = "bookie-${count.index + 1}"
  }
}

resource "aws_instance" "broker" {
  ami                    = var.aws_ami
  instance_type          = var.instance_types["broker"]
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.default.id]
  count                  = var.num_broker_nodes

  tags = {
    Name = "broker-${count.index + 1}"
  }
}

resource "aws_instance" "proxy" {
  ami                    = var.aws_ami
  instance_type          = var.instance_types["proxy"]
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.default.id]
  count                  = var.num_proxy_nodes

  tags = {
    Name = "proxy-${count.index + 1}"
  }
}