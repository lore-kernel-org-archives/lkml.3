Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaKUXRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:17:00 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40114 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaKUXQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:16:58 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] i2c: omap: fix i207 errata handling
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <089B5BDA-682D-46B6-869F-A6ADDFE691C3@gmail.com>
Date: Sat, 22 Nov 2014 02:16:53 +0300
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>
Content-Transfer-Encoding: 8BIT
Message-Id: <ED68D587-66C0-427A-85D5-D213DC136ECD@gmail.com>
References: <1416529011-21803-1-git-send-email-al.kochet@gmail.com> <089B5BDA-682D-46B6-869F-A6ADDFE691C3@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Kochetkov <al.kochet@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


21 нояб. 2014 г., в 3:29, Alexander Kochetkov <al.kochet@gmail.com> написал(а):

>> 
>> Found by code review. Real impact haven't seen.
>> Tested on Beagleboard XM C.
> 
> Does anybody know the "certain rare conditions" when RDR errata appears?
> I tested without luck (Beagleboard XM C).

Spent half a day trying to catch the errata without luck.
Tried to simulate noise on the bus in hope it may happen.
Tried to run with OMAP_I2C_FLAG_NO_FIFO flag.

What a mystery errata. Hiding.

Anyway, thanks!
Have a nice weekend!

