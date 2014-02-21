Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaBUENY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:13:24 -0500
Received: from mail.wdtv.com ([66.118.69.84]:52671 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaBUENW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:13:22 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: progress, marching to the rear
Date: Thu, 20 Feb 2014 23:13:11 -0500
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201402202313.11871.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally found a keyboard I can use when the boots fails to the
initramfs: prompt.  ps2 plug on it.

>From the messages it leaves on screen, it is NOT finding the drive plugged 
into the mobo SATA1 connector when I try to boot to a 3.13.1-2-3 kernel.

So just to verify I am looking in the right place in the /sys directory, I 
believe I was in drivers/pci/sata_nv when I took the pix now up on my web 
page.  

This is an ASUS M2N SLI Deluxe mobo, 8 Gigs of ram, phenom 9550 running 
slow at 2.1 Ghz.  This needs the sata_nv module to work with this hardware.

There are 4 drives in this box, and they are all working just fine when 
booted to 3.12.9, but that pix I just posted to my web page in the link 
below, in the Genes-os9-stf/LCNC link looks like there are only 3, and the 
first one has been enumerated to pci 5:0. Then 5:1 and 5:2 if I am reading 
that right.  But that same location in the 3.12.9 boot also only shows 3 
"devices" so obviously I don't know what I am doing.  Again...

So, when all I have is the initramfs: prompt, where in the /sys tree can I 
verify that all 4 drives are present and awake?

Thanks.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

