Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaLUAOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 19:14:51 -0500
Received: from nm16-vm4.access.bullet.mail.gq1.yahoo.com ([216.39.63.104]:38044
	"EHLO nm16-vm4.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbaLUAOt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 19:14:49 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Dec 2014 19:14:49 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=pacbell.net;
	b=PHaHmAM0UQGGAlTmbRmCFeMaIplYgynqr5Fea7FrkTqC676xXT9O/RTSjdEYSAXC11RI5/IXRsraA0Hvmoe9p1JH2m/dr6uKKEOrvZ1vSthv/EfShy32bHMlqcR0++EJkF0xJ+YkfLZj8ripOIHNcT/nx1EJiNs2CiGHWgvYOejm0z+YgVzSA24bHOh+vIqL0euei3GS5IGHuRPJ5CETgyABD7ELn7R/AR0SCpuGJEcigf2boiLXyDybrlmCg42WM3Tlzmg8SedH+QqB6N3yQMZhcsLnQQvsqKtJFxja1Kgr3JStHCwt9BBI66sr37PASgsbNky1HuQdWox+BCyo0A==;
X-Yahoo-Newman-Id: 901561.98969.bm@smtp112.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uQeq4ZMVM1le_fB5Ji_fbkWLk2c.Ig6sHIL5k2fQ2ZpQOBW
 3A6KAp4aet6nlTa_j7ad4N8UklmWP7Dr_d6RKJOPmZPTniNyfKgqrWcJnm2e
 CF9lpJG9nCBO79xvqCHhiVE.tqJxG9y3YtGZWPLYT3xoCH.EBlb6zf6IqKl8
 .HxQKNFVGu_bUseK_rSydUOnEpZLQ_u.DDe6t519Yt2WgsgbWmKp7GObcHmQ
 Fg8GKUSZ53gI5XECNohy6UrO_XV5q7QQKgVc87sIUDDxnOZCZPWfvlofnnug
 chnECuxoVHfkEWRMAcHjtxRWUvOYhoAxRBWeFdg9EeNdCwibldKzQvpfcN0K
 ARPMdmy5HNXd6YsE2isPWU38hYqOv.xDXFavQrzPBRBQIS5U7pE93N0QCwfj
 aaI8GxatB_RsoddzSZwgoNSXIe8fod6owE7c9dE4tdOwtf0vIqyoe40Si0Qr
 5j.ZEk_VE2bKy34IOfpbu3hs7Ma3pW8icupLeEQm6Pi9Vq645Ls6e0SnZNKv
 WPRakqgfxYzSCLkQrOATLrog1l3wB1_pvSQQhSMb6rmEO6wftMAySB44ev3M
 ZulCnUagZA3Ir4o64TaG7SDJWZ._flDvS5b0F1BYSquhA
X-Yahoo-SMTP: x3UJDw2swBBmiVP7941KaiyaoilgwM.0jf7QxQtKIw--
Message-ID: <54960F74.1050608@pacbell.net>
Date: Sat, 20 Dec 2014 16:08:20 -0800
From: Richard <richjunk@pacbell.net>
Reply-To: richjunk@pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 3.17.x Attaching Keyspan 4-Port Serial to USB Adapter Causes
 Kernel Panic
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a new Gentoo based system with Kernel.org Kernels 3.17.4 to 3.17.7
when I physically plug the Keyspan 4-Port Serial to USB adapter into a
usb port my system freezes with a "unable to handle kernel NULL pointer
deference" message.

My old system (also Gentoo based with Kernel.org 3.17.4) does not have
this issue.  Both systems are using the USB_SERIAL_KEYSPAN_USA49W
driver module.

I tried booting into single user mode, using modprobe to load
USB_SERIAL_KEYSPAN_USA49W.  lsmod shows the driver.  When I pluged the
device in I receive the system freeze.  Below is what I copied off the
console ...

BUG:  Unable to handle kernel NULL pointer deference at 000...8c
IP: [<ffffffffa006fbdd>] usa49_instat_callback+0x4d/0xb0[keyspan]
PGD 1037faa067 PUD 1038301067 PMD 0
Oops: 0002 [#1] SMP
Modules linked in: keyspan ezusb usbserial hid_generic ...

...

Hardware name:  ASUS All Series/X99-A,  BIOS 1004 10/16/2014




If I can provide any more information, please ask.

Please CC my e-mail address with any replies, I do not subscribe to the
linux kernel list:   richjunk@pacbell.net

Richard
