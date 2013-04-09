Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936117Ab3DITfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:35:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57155 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765118Ab3DITfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:35:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
Date: Tue, 9 Apr 2013 21:35:36 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>, Barry Song <baohua.song@csr.com>,
        Olof Johansson <olof@lixom.net>
References: <1362007694-3419-1-git-send-email-sboyd@codeaurora.org> <5164462E.4010706@codeaurora.org> <201304092032.18885.arnd@arndb.de>
In-Reply-To: <201304092032.18885.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092135.36616.arnd@arndb.de>
X-Provags-ID: V02:K0:FiRm3nsFQY0qQAZlBWabOjP1V5IwnCirUGTvKXfKkev
 6SewHhRbkFK6AAIO6rGBe1uZiEEm4ilXSo1wGNGlQnzs9oBS79
 XuumpDKLNiPUZ6lZRfsLu88+5GdFjDqHeCk7+YyAVKpVDSdGmt
 XL283uFgTCmNHJ2aTQFl2Ly7cdrDdoGMgNxF+mV3svicfqTR5L
 V256dF+QN9jAormMYKPP1+9FK9+siWe1hcpl6koc3b87r1XeQO
 TwttqhUTSy5HgScronpLQqEPk6O+SuLxq1GDbQNVbQe+FGfuQx
 yJuG/dnKY1x/Y92zajU3I+/qD9mnw9noXnN2JEuAeNcUdyGPmh
 KjkOS/8adGpbtkYiDLmw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Arnd Bergmann wrote:
> I've applied it to the next/soc branch now.
> 

I just made up my mind again after I got a few merge conflicts. I have
added it to the next/multiplatform branch now instead of next/soc, since
a few of the Kconfig entries changed in this patch are moved to other
files in that branch.

I've also added an entry for mach-zynq, which has gained SMP support
in the meantime. I assume it uses TWD/SCU as it is otherwise rather close
to the ARM reference platforms.

	Arnd
