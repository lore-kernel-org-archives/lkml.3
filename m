Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaJLRVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:21:36 -0400
Received: from mail.wdtv.com ([66.118.69.84]:48320 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbaJLRVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:21:35 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: reboot housekeeping, lack thereof, is messing with me
Date: Sun, 12 Oct 2014 13:21:26 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201410121321.26582.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To whomever is in charge of the supposedly volatile LCK.. files in 
/var/lock:

Its my understanding that these files should be volatile when they 
represent a USB usage, because a USB device can be unplugged instantly and 
at any time.  The device nicely and dutifully disappears from an 'ls /dev' 
listing when a device is unplugged.

Why is it then that the /var/lock/LCK..ttyUSB1 file is always left behind, 
so it screws up any possibility of doing a nice clean reboot and restart 
of the program that uses it?

/var/lock is not now nor has it ever been volatile storage since its on 
the drive forever, or until one becomes root, deletes it, and then reboots 
the machine.  That just cost me a days work, testing usb cables etc with a 
digital storage scope and a chip replacement on the other systems 
motherboard that in all likelyhood wasn't needed.

Is this fixable?

Thanks.

Cheers, Gene Heskett
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>
US V Castleman, SCOTUS, Mar 2014 is grounds for Impeaching SCOTUS
