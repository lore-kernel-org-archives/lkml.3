Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaEXVf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 17:35:26 -0400
Received: from forward13.mail.yandex.net ([95.108.130.120]:48273 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaEXVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 17:35:25 -0400
From: Sarbash Sergey <sarbash.s@yandex.ru>
Envelope-From: sarbash-s@yandex.ru
To: linux-kernel@vger.kernel.org
Subject: [usb-dev] [probably a bug] GINZZU GR-126B cardreader misbehavior. 
MIME-Version: 1.0
Message-Id: <1740321400967290@web1j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sun, 25 May 2014 01:34:50 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, dear Developers.

Recently, I've got this device:

http://ginzzu.com/rus_level5_tab1.php?lang=NAME_ENG&ot=520&group=-1&oid=51&tab_id=-10

It is an internal usb-cardreader.

lsusb shows it as

Bus 003 Device 004: ID 14cd:168a Super Top

A manufacturer claims that it works in linux systems but that's not quite so. It works incorrectly.
You should manually mount /dev/sdb under root to be able to read inserted card.
Or, you should unplug it before inserting a card after that insert a card then plug it again. Then inserted card is recognized and mounted.

My environment:

Debian/sid
Linux servant 3.14-1-amd64 #1 SMP Debian 3.14.4-1 (2014-05-13) x86_64 GNU/Linux
KDE Desktop

What kind of info may help to determine what is a cause of such manner?
All other usb-devices work well (bluetooth dongle, web-cam, wireless mouse, usb-sticks).

For more info:

lsusb default output

Bus 004 Device 004: ID 04d9:1605 Holtek Semiconductor, Inc.
Bus 004 Device 003: ID 0c45:62e0 Microdia MSI Starcam Racer
Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 004: ID 14cd:168a Super Top
Bus 003 Device 003: ID 09da:054f A4 Tech Co., Ltd
Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

lspci default output

00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09)
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
00:1c.4 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 5 (rev c4)
00:1c.5 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c4)
00:1c.6 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 7 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation H77 Express Chipset LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 7 Series/C210 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
03:00.0 Ethernet controller: Qualcomm Atheros AR8161 Gigabit Ethernet (rev 10)
04:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge (rev 03)
06:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network Adapter (rev 01)

-- 
Sincerely Yours,
Sergey Sarbash.
