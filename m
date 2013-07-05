Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab3GEV6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:58:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3GEV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:58:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ASoC: Allow imx-pcm-{dma,fiq}.c to be modules
Date: Fri, 5 Jul 2013 23:58:21 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
References: <201307051745.16140.arnd@arndb.de> <201307052255.10765.arnd@arndb.de> <20130705211920.GK27646@sirena.org.uk>
In-Reply-To: <20130705211920.GK27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307052358.22068.arnd@arndb.de>
X-Provags-ID: V02:K0:YSuA2nf39eNxB2tgjVE1mrzBXYJ1K5Z6nDhWNUH9NEf
 XTWa2HMyXw0FzoJMarTS8naL+eAyV+Cev+dfjvXjFnDi8fqee1
 QLQ1WNm9F15R6/zFgE3cJpNYNKGet9qp6OuwNsfgTR5Ohnd3x8
 ng8xMQZ8KKJq9F2UXiu+zElOMwWcFu2Za16Zb6YiZvZREN+qbT
 EUKQDKSFAm39UdAnIknQsUC6LQaPq3WRsBkzEUnzlSyzvupQBr
 Cd9vXED/zeY0n0wKrYTO+Z6YJ+vYRoAG94/ZPchXfdx0iYEAyX
 bztMQeVyQPlEzaNqA0V7hTHuMr0phDdyqClCh78XgaU3aqpeo/
 7y+wszRR4DTtWDuicH5I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 July 2013, Mark Brown wrote:
> On Fri, Jul 05, 2013 at 10:55:10PM +0200, Arnd Bergmann wrote:
> > On Friday 05 July 2013, Mark Brown wrote:
> 
> > > Is this actually OK with the FIQ APIs?
> 
> > I don't know. Why wouldn't it?
> 
> It was the only reason I could think of why that'd have been done.

I looked in the log and found this part has been patched a couple
of times already, going back and forth between "bool" and "tristate",
always to fix build errors.

Please hold back for now, I'll try to reproduce on the bug on
the current torvalds tree first. I know it was broken in linux-next
as of a few weeks ago, but something else may have changed in the
meantime.

	Arnd
