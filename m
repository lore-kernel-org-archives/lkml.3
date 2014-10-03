Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbaJCWtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:49:55 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:62231 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988AbaJCWtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:49:33 -0400
MIME-Version: 1.0
Date: Fri, 3 Oct 2014 15:49:32 -0700
Message-ID: <CAPJTyAV4-bXaKt-cC-Rv4cr+u-mr6z2QaKd-BnzLDK6DJ15BhQ@mail.gmail.com>
Subject: Two drives are both sda
From: Michael Bushey <corwin7@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have two SSD drives that are both sda:

root@dev:~# ls -l /dev/disk/by-id/
total 0
lrwxrwxrwx 1 root root  9 Oct  3 13:39
ata-Samsung_SSD_850_PRO_128GB_S1SMNWAF713081V -> ../../sda
lrwxrwxrwx 1 root root 10 Oct  3 13:39
ata-Samsung_SSD_850_PRO_128GB_S1SMNWAF713081V-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Oct  3 13:39
ata-Samsung_SSD_850_PRO_128GB_S1SMNWAF713081V-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 Oct  3 13:39
ata-Samsung_SSD_850_PRO_128GB_S1SMNWAF713081V-part3 -> ../../sda3
lrwxrwxrwx 1 root root  9 Oct  3 13:41
usb-HGST_Touro_Desk_Pro_31001310280002201158-0:0 -> ../../sdb
lrwxrwxrwx 1 root root 10 Oct  3 13:39
usb-HGST_Touro_Desk_Pro_31001310280002201158-0:0-part1 -> ../../sdb1
lrwxrwxrwx 1 root root  9 Oct  3 13:39 wwn-0x500253887000a4f1 -> ../../sda
lrwxrwxrwx 1 root root 10 Oct  3 13:39 wwn-0x500253887000a4f1-part1 ->
../../sda1
lrwxrwxrwx 1 root root 10 Oct  3 13:39 wwn-0x500253887000a4f1-part2 ->
../../sda2
lrwxrwxrwx 1 root root 10 Oct  3 13:39 wwn-0x500253887000a4f1-part3 ->
../../sda3

# cat /sys/class/block/sda/device/model
Samsung SSD 850

The wwn drive is a PNY XLR8 240GB SSD. Is there any way I can make it
sdc? I would like to image the PNY drive and try to recover the data
off of it.

The machine seems to be functioning OK off of the Samsung 850 system
drive; I just brought it back up yesterday with the Samsung SSD after
the PNY drive started giving errors.

# uname -a
Linux dev.rm 3.16-2-amd64 #1 SMP Debian 3.16.3-2 (2014-09-20) x86_64 GNU/Linux

Both SSD drives are configured so part1 is EXT4, part2 is swap, and
part3 is ZFS.

I'm not on the mailing list so please CC any responses / further
questions to my email.

Thanks in advance for any help.
￼Michael Bushey
