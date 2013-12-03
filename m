Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3LCLYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:24:46 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:46699 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3LCLYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:24:44 -0500
MIME-Version: 1.0
Date: Tue, 3 Dec 2013 16:54:43 +0530
Message-ID: <CAD6G_RT0S43BrOeXxJ6d3p1ALbXkGumZCSPBaK1Bz=2pX3hHYQ@mail.gmail.com>
Subject: Need help on Linux PCIe
From: Jagan Teki <jagannadh.teki@gmail.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have few question on Linux PCIe subsystem, I am trying to understand
the PCIe on ARM platform.
1. Compared to PCI, PCIe have an extra port functionalists/services
which is implemented drivers/pci/pcie/* is it true?
2. PCIe root complex is same as Host controller drivers in linux drivers/host/*
3. As individual endpoint drivers are registered to pci_core as
pci_driver_register, then what is the common call for registering
individual HC driver to pci-core?
4. Can you list-down the basic and advanced functionalists supported
by HC driver in PCIe?
5. The PCIe port bus driver is common core? means no need to change w.r.t SOC?

Request for your comments.

-- 
Thanks,
Jagan.
--------
Jagannadha Sutradharudu Teki,
E: jagannadh.teki@gmail.com, P: +91-9676773388
Engineer - System Software Hacker
U-boot - SPI Custodian and Zynq APSOC
Ln: http://www.linkedin.com/in/jaganteki
