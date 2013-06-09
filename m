Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab3FIUm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 16:42:59 -0400
Received: from ballcam.com ([184.173.145.60]:60365 "HELO ballcam.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750727Ab3FIUm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 16:42:58 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jun 2013 16:42:57 EDT
Message-ID: <20130609203616.28374.qmail@ballcam.com>
From: kernel-dev@ballcam.com
Date: Sun, 09 Jun 2013 15:36:16 -0500
To: linux-kernel@vger.kernel.org
Subject: [BOUNTY] Need a Working Driver Brought Up From 2.6.29 to 2.6.34.
 Will Pay.
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an OEM Driver that works Excellent under 2.6.29.

I need it working in 2.6.34

The Target Platform is ARM / Gumstix Overo.

It is a network WiFi driver, so I may post there as well.

But, the stack trace from when the module hangs on load 
gives switch_to() as the last function call when addr2line
is used to check the address against the kernel file.

Also, the driver does not curently use the net_driver_ops
API.

I have signed the NDA with the OEM, and I think the SRC 
is OK for GPL.

After this issue is solved the project will go on IndieGoGo,
and I will take it to the next level. For now I can pay,
but I am not a MegaCorp.   

I can certainly work with anyone offline, but please
respond here if appropriate. 

I do believe the end product can, and probably should
be included in the 2.6.34 mainline release.

Thanks,
BallCam.
