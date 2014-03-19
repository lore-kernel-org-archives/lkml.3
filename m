Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043AbaCSNvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:51:38 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:34904 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933853AbaCSNvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:51:36 -0400
MIME-Version: 1.0
Date: Wed, 19 Mar 2014 13:51:36 +0000
Message-ID: <CAAbCkmKHrKHAQqjE96J=TU2ndrCrhjg6j-x2YZGUY-odWMmyBg@mail.gmail.com>
Subject: Testing 1 hard disk in 3 different usb enclosures: kernel reports 3
 different "numbers of sectors"
From: Jaime T <enopatch@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to use my 1TB Seagate hard disk on my linux box, and I've
tested it using 3 different usb-sata enclosures. Here are the syslog
entries when I plug it in:

kernel: [10611.884111] usb 1-1: new high-speed USB device number 23
using ehci_hcd
kernel: [10612.017588] usb 1-1: New USB device found, idVendor=14cd,
idProduct=6116
kernel: [10612.017596] usb 1-1: New USB device strings: Mfr=1,
Product=3, SerialNumber=2
kernel: [10612.017602] usb 1-1: Product: USB Mass Storage Device
kernel: [10612.017607] usb 1-1: Manufacturer: Generic
kernel: [10612.017612] usb 1-1: SerialNumber: 116AC2101219
kernel: [10612.018116] scsi25 : usb-storage 1-1:1.0
kernel: [10613.017043] scsi 25:0:0:0: Direct-Access        Mass
Storage Device        PQ: 0 ANSI: 0
kernel: [10613.019553] sd 25:0:0:0: Attached scsi generic sg2 type 0
kernel: [10613.019646] sd 25:0:0:0: [sdb] 1953525166 512-byte logical
blocks: (1.00 TB/931 GiB)

kernel: [10730.084090] usb 1-1: new high-speed USB device number 24
using ehci_hcd
kernel: [10730.225053] usb 1-1: New USB device found, idVendor=152d,
idProduct=2509
kernel: [10730.225061] usb 1-1: New USB device strings: Mfr=1,
Product=11, SerialNumber=3
kernel: [10730.225067] usb 1-1: Product: Usb production
kernel: [10730.225072] usb 1-1: Manufacturer: JMicron
kernel: [10730.225077] usb 1-1: SerialNumber: 20120912000A
kernel: [10730.225912] scsi26 : usb-storage 1-1:1.0
kernel: [10731.224882] scsi 26:0:0:0: Direct-Access     Jmicron  Corp.
                PQ: 0 ANSI: 2 CCS
kernel: [10731.226702] sd 26:0:0:0: Attached scsi generic sg2 type 0
kernel: [10731.227818] sd 26:0:0:0: [sdb] 1953524995 512-byte logical
blocks: (1.00 TB/931 GiB)

kernel: [10837.176146] usb 1-2: new high-speed USB device number 25
using ehci_hcd
kernel: [10837.309203] usb 1-2: New USB device found, idVendor=152d,
idProduct=2339
kernel: [10837.309212] usb 1-2: New USB device strings: Mfr=1,
Product=2, SerialNumber=5
kernel: [10837.309218] usb 1-2: Product: USB to ATA/ATAPI Bridge
kernel: [10837.309223] usb 1-2: Manufacturer: JMicron
kernel: [10837.309228] usb 1-2: SerialNumber: 29FCA11600FF
kernel: [10837.310184] scsi27 : usb-storage 1-2:1.0
kernel: [10838.308908] scsi 27:0:0:0: Direct-Access     ST1000LM 024
HN-M101MBB        PQ: 0 ANSI: 2 CCS
kernel: [10838.310727] sd 27:0:0:0: Attached scsi generic sg2 type 0
kernel: [10838.311867] sd 27:0:0:0: [sdb] 1953525168 512-byte logical
blocks: (1.00 TB/931 GiB)

So Linux (v3.10.25) is reporting 3 different sizes/numbers of sectors
for the same single hard disk. Could this be a problem with regards to
possible future data corruption, or is it something that I can safely
ignore?

Many thanks, Jaime
