Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3A1Nib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:38:31 -0500
Received: from asix.com.tw ([210.243.224.51]:51892 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab3A1Ni3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:38:29 -0500
From: "Freddy" <freddy@asix.com.tw>
To: "=?utf-8?Q?'Bj=C3=B8rn_Mork'?=" <bjorn@mork.no>,
        "'Michael Leun'" <lkml20130126@newton.leun.net>
Cc: <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <louis@asix.com.tw>,
        <davem@davemloft.net>, <Support@asix.com.tw>
References: <1358908337-13841-1-git-send-email-freddy@asix.com.tw>	<20130127001347.584711b2@xenia> <87zjztptez.fsf@nemi.mork.no>
In-Reply-To: <87zjztptez.fsf@nemi.mork.no>
Subject: RE: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver
Date: Mon, 28 Jan 2013 21:36:20 +0800
Message-ID: <010f01cdfd5c$768d4240$63a7c6c0$@asix.com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGuKq1VNb33SwaGuGVDTqE7QWFmhAIUoUH/AUeehKCYg3QwwA==
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would vote to not accept that driver for mainline as long as this 
> issues are not fixed.


Michael, could you give me more information about how do you test this driver? 
I have tried to reproduce the issue by using "ifconfig ethX mtu 1500", but I didn't confront the same issue.
Thank you in advance for your help.


> The vendor should not be able to claim "hooray, hooray, great device, 
> we even have an driver in linux main line" when it is actually such an 
> useless crap.

> Well, that is fortunately not how these things work. The main goal is getting the devices supported in the kernel. Bugs can be fixed.  If a vendor can get any positive gain out of having a driver in mainline, then that is good for everyone, isn't it?  Of course, we can all agree that the > > > effect of a *working* driver is more positive than a non-working driver...


> For now, the main focus should be fixing the issues which has been noted during review.  Your testing feedback is of course very useful, but you probably need to back them up with actual code change proposals if they are going to be dealt with at this stage.

> Of course I'm offering to help with any information or testing, but 
> unfortunately I do not have the knowhow to fix anything myself.

> I believe this is where you are totally wrong.  You obviuously have the ability to create a few simple test cases for yourself and see if the driver behaves as you expect.  That is very useful.

> And you have a device.  That is also useful.

> Now, the driver source code is available.  And there is another Asix driver in the kernel which already has been cleaned up and can be used as an example. And maybe even partly used for the new devices as well, if the code is duplicated?  I have not looked at this in detail, but I     > suspect that much of the problem with the ax88179_178a driver is that it has completely ignored all the work that has gone into the asix driver after it was mainlined.  I find it unlikely that there is no reusable code in the asix_devices.c, asix_common.c and ax88172a.c files.  Trying to > rewrite ax88179_178a to share as much code as possible seems like the best way to clean it up and fix bugs.

Bjørn, I am trying to reproduce the issue mentioned by Michael and I have a question about submitting this driver.
Should I merge this driver into asix_devices.c and asix_common.c even through the usb command, tx_fixup, and rx_fixup functions are totally different?
Thank you in advance for your reply.

Freddy


