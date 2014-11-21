Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaKUXCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:02:13 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:37805 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaKUXCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:02:08 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] i2c: omap: fix i207 errata handling
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141121160828.GP7508@saruman>
Date: Sat, 22 Nov 2014 02:02:03 +0300
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B174E67D-9CCF-48B6-A5E5-911668161823@gmail.com>
References: <1416529011-21803-1-git-send-email-al.kochet@gmail.com> <20141121160828.GP7508@saruman>
To: Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Wolfram Sang <wsa@the-dreams.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


21 нояб. 2014 г., в 19:08, Felipe Balbi <balbi@ti.com> написал(а):

> Tested on BBB and AM437x Starter Kit
> 
> Tested-by: Felipe Balbi <balbi@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

21 нояб. 2014 г., в 0:10, Aaro Koskinen <aaro.koskinen@iki.fi> написал(а):

> I could not see any breakage or anything wrong on OMAP2 & OMAP3.
> On OMAP1 I don't have anything on the OMAP I2C bus, so cannot really
> test anything there.
> 
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>


21 нояб. 2014 г., в 21:11, Wolfram Sang <wsa@the-dreams.de> написал(а):

> The errno for AL is -EAGAIN. Curly braces are not needed.


Guys, I really appreciate you help.
So much testing and review.
I could not have done one.
Thank you!

Alexander.

