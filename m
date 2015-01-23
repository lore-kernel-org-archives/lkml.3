Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbbAWPlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:41:49 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:52655 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbbAWPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:41:45 -0500
MIME-Version: 1.0
Date: Fri, 23 Jan 2015 16:41:43 +0100
Message-ID: <CAOQDsMxSxrquwx5249aWDNP7dzEqySwHzEzjPyZuJMxg-Cd1Tg@mail.gmail.com>
Subject: Cannot boot Linux kernel
From: Dorian VEGARA <dorian.vegara@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to everyone,

I'm trying to boot Linux kernel 3.14.25 but I'm encountering a problem
: when I boot Linux, a "Warning : CPU" is shown and Linux crashes...
Let's see what I did. :)

After I downloaded the kernel and extracted it, I typed :

$ make defconfig

It chose the defconfig x86_64.
After, I typed another command :

$ make && make modules_install

The bzImage arch/x86/boot/bzImage was properly created ("x86", not
"x86_64" like defconfig - I don't know if it's important).

The modules have been installed correctly. The last message is "DEPMOD 3.14.25".

I think my GRUB2 configuration is OK :
menuentry 'Linux' {
 insmod gzio
 insmod part_msdos
 insmod btrfs
 set root='hd0,msdos6'
 linux /boot/linux
}


So the boot may be successfully done... But it crashes :
http://nsa33.casimages.com/img/2015/01/23/150123012550291970.jpg

You can find the .config generated with the command $ make defconfig
here : http://textup.fr/116850NO

... and the log file created thanks to the command sh -c "make && make
modules_config > leFichierLog 2>&1" is here :
http://textup.fr/116855TB


Could you help me please ? :)
Thanks a lot.

Best regards,
