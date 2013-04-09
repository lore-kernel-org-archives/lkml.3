Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935274Ab3DIScu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:32:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538Ab3DIScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:32:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
Date: Tue, 9 Apr 2013 20:32:18 +0200
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
References: <1362007694-3419-1-git-send-email-sboyd@codeaurora.org> <5151DC41.7090307@codeaurora.org> <5164462E.4010706@codeaurora.org>
In-Reply-To: <5164462E.4010706@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092032.18885.arnd@arndb.de>
X-Provags-ID: V02:K0:Cf2YG93n+jqq+vDqGU9wAqaSse3IRUrbEexUugJw2z5
 h+TtAGMUrHlckSmILxHH+8rRS5J+6RdrDhhcn9m/GGeUc2KKrW
 4W6EpZrCzwtE8Zc3PlXdCssKpoCZ+Jt/ZWrweQQiVW5JzLqp1b
 zyARAVHlA5rBWvlpg5092G5eMRGA/p9GS+tmk/bhDfcBQZeVzu
 5qiGkpyhlhUjQtvGiN9a9zQ+u8ebXBJS9B5tOvjBB1MiEO1LrU
 hXazn43yWwvfZGjERbaW0DOq3zXB25THhh9lO5SJSfoVEVp3p+
 L3zWhPyP/+F1Qi6tmuG60uOImifZF8dOpB3O3a+3i+KHM4i4qD
 spghHI/5dqmkPthpG+VQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Stephen Boyd wrote:
> >>>
> >>> Sneaking it in through the fixes branch would make life easier for us,
> >>> but it doesn't feel right.
> >> Arnd, can you pick this up into the arm-soc tree now? It would be good
> >> to get this into next so that conflicts are avoided later on.
> >>
> > Arnd?
> >
> 
> Ping?


Sorry for the long delay, you scrolled down from my unread emails twice.

Three tips for you to make it more likely to get a fast reaction time:

* Send the original patch to Olof and me, not just the reply to the
  on-list patch.
* Use the arm@kernel.org alias to reach us, since that will make the
  email go into the right folder
* Use the [GIT PULL] keyword in the subject line, ideally sending a
  pull request as well, instead of a separate email. While we do apply
  emails, It's often batch processing to apply everything and then
  we scan for emails that have PULL in the subject, while others
  can get lost.

I've applied it to the next/soc branch now.

	Arnd
