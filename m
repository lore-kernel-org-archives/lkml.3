Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3HESJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:09:15 -0400
Received: from vms173025pub.verizon.net ([206.46.173.25]:62931 "EHLO
	vms173025pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3HESJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:09:13 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 14:09:13 EDT
Date: Mon, 05 Aug 2013 10:09:07 -0700
From: Vern Clark <vmclark@verizon.net>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Kernel causing 5minute delay mounting USB memory stick
Message-id: <20130805100907.5772c1db@u>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel 3.8.0.28-generic problem started

syslog output:
Aug  2 09:39:15 u kernel: [ 2268.769492] usb 1-8: new high-speed USB
device number 11 using ehci-pci
...
Aug  2 09:44:26 u udevd[3606]: timeout: killing '/sbin/blkid -o udev -p /dev/sdb' [3717]
Aug  2 09:44:57  udevd[3606]: last message repeated 30 times
Aug  2 09:44:57 u kernel: [ 2610.106976] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:44:57 u udevd[3606]: timeout: killing '/sbin/blkid -o udev -p /dev/sdb' [3717]
Aug  2 09:45:28  udevd[3606]: last message repeated 30 times
Aug  2 09:45:28 u kernel: [ 2641.011767] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:45:28 u kernel: [ 2641.146199] sd 11:0:0:0: [sdb] Attached SCSI removable disk
Aug  2 09:45:28 u udevd[3606]: '/sbin/blkid -o udev -p /dev/sdb' [3717] terminated by signal 9 (Killed)
Aug  2 09:45:28 u udevd[3606]: timeout 'udisks-part-id /dev/sdb'


kernel 3.5.0-38-generic is the last known one that USB  works.
