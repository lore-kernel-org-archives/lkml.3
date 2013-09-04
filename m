Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510Ab3IDJVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:21:53 -0400
Received: from smtp2-1.goneo.de ([212.90.139.83]:35760 "EHLO smtp2-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762117Ab3IDJVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:21:51 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.739
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
Date: Wed, 04 Sep 2013 11:21:47 +0200
Message-ID: <5034887.FlGzi4P5YS@lem-wkst-02>
User-Agent: KMail/4.10.5 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52261C5C.9000102@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <4094364.ACYUvMRRNa@lem-wkst-02> <52261C5C.9000102@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 September 2013 11:29:00, Stephen Warren wrote:
> On 09/02/2013 03:38 AM, Lars Poeschel wrote:
> > Am Freitag, 30. August 2013, 13:53:45 schrieb Stephen Warren:
> ...
> 
> >> Yet the current patch only addresses a limited set of cases, since it
> >> doesn't hook the APIs but rather parses the DT. It doesn't cover the
> >> non-DT case. It should if the feature is useful.
> > 
> > As pointed out before, only DT has this problem, that,
> 
> That's completely false. Both DT and non-DT can represent the exact same
> HW, and use the exact same drivers. It's equally possible to write a bug
> in a board file or a DT file (i.e. a typo or incorrect reading of the
> schematic) that causes the wrong GPIO or IRQ ID to be used, and hence
> for there to be conflicts. Any solution to this issue needs to address
> both cases.

This is again not the point. This is not what this patch is trying to solve. 
The patch is trying to solve problem A. But you are talking about problem B.
Sure I can write a bug in board files and I can write a bug in DT files. The 
patch is not trying to prevent that. This is a completly different thing.
