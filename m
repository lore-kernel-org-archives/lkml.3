Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3F0Uid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:38:33 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36363 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3F0Uic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:38:32 -0400
MIME-Version: 1.0
Date: Thu, 27 Jun 2013 21:38:30 +0100
Message-ID: <CALyZvKxCYaU47jb98FcbwNSMxnQ8pVCj17MYm0B3V99Uw2_nDA@mail.gmail.com>
Subject: HP6715b laptop's wireless radio on LED went off after 1st boot of
 3.9.6 from 3.4.4 - please help / any ideas ?
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After building and installing 3.9.6 kernel & modules on
my 2.2ghz HP6715b x86-64 Turion dual core laptop ,
which has always run Linux with no b43 wireless problems
since 2007, now has no access to its onboard broadcom 4311
wireless radio .  I had always used the b43
driver with the correct firmware installed
under /lib/firmware/b43 with b43-fwcutter
as per instructions at http://wireless.kernel.org/en/users/Drivers/b43
, which I've just now redone again, but since booting
3.9.6, which I believe resulted in a firmware download
via udev at first boot, the wireless radio "on" blue LED
indicator goes off after BIOS POST .  It has always been
the case that if the blue LED indicator is off after BIOS
POST ,  then the kernel does not see the device, and I
have no wireless until a hard poweroff and pressing
the touch sensitive wireless on button during BIOS POST.
But now the wireless LED goes on for @ 1 second during
BIOS POST , and never comes on again ,  and there are
no responses to touching wireless-on button after reboot,
though there are to other buttons next to it.  In short,
I've lost wireless access (and home internet access for
my pc - I'm sending this from my mobile) . Can anyone help?
How can I force the card to download the re-installed
b43-fwcutter firmware, if the device no longer appears
in lspci output?  Anyway to force the kernel to ignore
the wireless button ( it could be that the kernel & bios
think this button is in the off state - any way to force
its state to "on") ?  Any ideas / suggestions would be much
appreciated.
Thanks & Regards, Jason
