Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaHDH3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:29:02 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:48470 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaHDH27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:28:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAKszPguooNOt_o=22sTvxKqa=XX-hzt+6UL1LbAx4TvS35CgCA@mail.gmail.com>
References: <CAKszPguooNOt_o=22sTvxKqa=XX-hzt+6UL1LbAx4TvS35CgCA@mail.gmail.com>
From: Claudio Bizzarri <claudio.bizzarri@gmail.com>
Date: Mon, 4 Aug 2014 09:28:38 +0200
Message-ID: <CAKszPgtUbViQuw9y-QHNmW5dA-2g5AQHchpNnY1OtH5ZUrTQqw@mail.gmail.com>
Subject: Re: Kernel 3.16.0 USB crash
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ive installed latest kernel-ppa 3.16.0 version. When I attach my USB
3.0 external drive I've a complete system crash. Here the latest
/var/log/syslog lines before complete lockdown of my computer.

With kernel 3.14.14 it works perfectly. Please tell me how I can help
developer to eliminate this bug.

C

Aug  4 08:50:51 hp850ssd kernel: [ 1059.143641] usb 3-2: new
SuperSpeed USB device number 3 using xhci_hcd
Aug  4 08:50:51 hp850ssd kernel: [ 1059.160151] usb 3-2: New USB
device found, idVendor=152d, idProduct=0567
Aug  4 08:50:51 hp850ssd kernel: [ 1059.160156] usb 3-2: New USB
device strings: Mfr=10, Product=11, SerialNumber=5
Aug  4 08:50:51 hp850ssd kernel: [ 1059.160159] usb 3-2: Product: USB
to ATA/ATAPI Bridge
Aug  4 08:50:51 hp850ssd kernel: [ 1059.160161] usb 3-2: Manufacturer: JMicron
Aug  4 08:50:51 hp850ssd kernel: [ 1059.160163] usb 3-2: SerialNumber:
152D00539000
Aug  4 08:50:51 hp850ssd mtp-probe: checking bus 3, device 3:
"/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2"
Aug  4 08:50:51 hp850ssd mtp-probe: bus: 3, device: 3 was not an MTP device
Aug  4 08:50:51 hp850ssd kernel: [ 1059.677172] usbcore: registered
new interface driver usb-storage
Aug  4 08:50:51 hp850ssd kernel: [ 1059.680316] scsi2 : uas
Aug  4 08:50:51 hp850ssd kernel: [ 1059.680442] usbcore: registered
new interface driver uas
Aug  4 08:50:55 hp850ssd kernel: [ 1063.680229] scsi 2:0:0:0:
Direct-Access     JMicron  Generic          0100 PQ: 0 ANSI: 6
Aug  4 08:50:55 hp850ssd kernel: [ 1063.683453] sd 2:0:0:0: Attached
scsi generic sg1 type 0
Aug  4 08:50:55 hp850ssd kernel: [ 1063.684084] sd 2:0:0:0: [sdb]
976773168 512-byte logical blocks: (500 GB/465 GiB)
Aug  4 08:50:55 hp850ssd kernel: [ 1063.684091] sd 2:0:0:0: [sdb]
4096-byte physical blocks
Aug  4 08:50:55 hp850ssd kernel: [ 1063.687278] sd 2:0:0:0: [sdb]
Write Protect is off
Aug  4 08:50:55 hp850ssd kernel: [ 1063.687288] sd 2:0:0:0: [sdb] Mode
Sense: 67 00 10 08
Aug  4 08:50:55 hp850ssd kernel: [ 1063.688585] sd 2:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, supports DPO and FUA
