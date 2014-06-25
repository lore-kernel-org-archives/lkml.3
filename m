Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaFYSwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:52:40 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:57163 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaFYSwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:52:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org, pebolle@tiscali.nl,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.16 #1 (ter)
Date: Wed, 25 Jun 2014 20:49:59 +0200
Message-ID: <4184712.OOQdXC98UK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403713316-28253-1-git-send-email-nicolas.ferre@atmel.com>
References: <1403713316-28253-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bC9kXin3feM75dfDZTw2/SZhNfbZGn7vKAIYTU9lap8
 21HjFHxYO1R5rOBAHlpEO5OP3KrTO0c0IHAhY8HKWGdQ8uX2rr
 b8IZmw83PwDuZgOXmKAlgbXpQlR0/Ywp3ExNDRdQAM/KNUOmdq
 hmf3n0a4O4OTgn/cjFh5rIcxjCXFmayKJPIE6rzqFhZ/Jqrmub
 piExAlLILQ1LS7J1Md1K8ww1XthjdiDcd8t+P3CMpuViRxRWnV
 yp58Q+eXSv0qTV1J9iT2QQqRQlYb+qWb6+k+iuCr1f+mF27iOx
 rCMiEW9FrFSTEAQCu7GubTt3m/xuLCVIEoBfdLD3kHR7Wi9Vaj
 oCT53qZ4EfPiKciO2hrQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 18:21:56 Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> An AT91 fixes batch for 3.16 that collects mainly DT fixes in relation
> to the recent move to CCF on a couple of platforms.
> A Kconfig symbol fix in drivers/misc is also included.
> 
> As the previous "fixes" pull-requests will be re-spin for 3.17 and shall be
> ignored, I use the same tag name "at91-fixes".
> 
> Thanks, best regards,
> 
> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
> 
> for you to fetch changes up to 971dc9ce106110745f246337f229013589354536:
> 
>   ARM: at91/dt: sam9261: remove slow RC osc (2014-06-25 18:00:17 +0200)
> 
> ----------------------------------------------------------------
> First AT91 fixes batch for 3.16:
> - drivers/misc fix for Kconfig PWM symbol
> - correction of several values in DT after conversion to CCF
> - fix at91sam9261/at91sam9261ek mistake in slow crystal vs. slow RC osc

Pulled and sent out again now. Thanks for following up so quickly.

	Arnd
