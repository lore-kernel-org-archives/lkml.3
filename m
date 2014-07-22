Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaGVU6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:58:23 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:57526 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbaGVU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:58:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Brian Norris <computersforpeace@gmail.com>, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Sebastian Reichel <sre@kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>, Olof Johansson <olof@lixom.net>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v8 00/11] ARM: brcmstb: Add Broadcom STB SoC support
Date: Tue, 22 Jul 2014 22:57:17 +0200
Message-ID: <5044348.IEPQPrahyu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140722204431.GG28323@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com> <5675728.WLk3P96IBM@wuerfel> <20140722204431.GG28323@ld-irv-0074>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:soqorGQ8TdoOK1+OwUhxDR45/XOn/MfzSto8Dbvu9So
 7QFjd9sDcx6uN0/tmIQFKSNVJHrUflWdjDJYPLQ2gwFgrFmPud
 D4B5ENPMxU4IlNdvNQaL1O8C85dkibf5TM3p8RFB32FnwrwL4v
 ivXVbBVP4Gu+8J80g+MFZ7LoL2V+FqUAjb03dVu0rUvHBe6xnZ
 +KseadM7AKmIiQ7tklhAg441ThCqzzeJdu5gWsTHVgdzn7jhjA
 Jmv0dNTCTjOJi+hPC98LR9HZTt5s4vyZcbzhFq3aeM+R3Pq++s
 bN1EVN/olKnWEPsHw98A/OlwMTsF4W0AN+I3DuHoOvi5bwvWrq
 8F0D+Seu3ZcRtHidWfVk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 13:44:31 Brian Norris wrote:
> > For the platform changes in the first patch, I would prefer to have
> > Matt pick up the first patch, but we can also apply it directly into
> > arm-soc if he prefers that.
> 
> That brings up a question related to PATCH 11 in the series (MAINTAINERS
> update); who will be maintaining arch/arm/mach-bcm/*brcmstb*, and how
> will code go upstream? It seems like Matt and Christian are officially
> mach-bcm maintainers, although I don't know if Christian is still
> involved.

You have to solve that question together with Matt. From my perspective
it would be easier if I only have to deal with one person for mach-bcm,
but it's really up to you.

> Also, BCM7xxx shares little in common with the rest of mach-bcm, except
> a company name, so we'd really like at least the 'Maintainer' entries
> for the CC. I was planning on a separate git tree too, although it could
> have conflicts if we touch arch/arm/mach-bcm/{Makefile,Kconfig}.
> 
> So would we send a separate arm-soc pull request for the arm-soc
> targeted changes (and all future development)?

You can definitely have the separate MAINTAINERS entry without necessarily
becoming a maintainer at the same level. I know Matt is very responsive
and can forward your patches to arm-soc if that works for you.

> For the reset of mach-bcm stuff, I'll just send an arm-soc pull request
> soon enough, unless Matt/Arnd/Olof object.

I'll wait for Matt to comment before pulling it, otherwise that sounds
fine.

	Arnd
