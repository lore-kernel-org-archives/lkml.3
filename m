Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaK1I2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:28:20 -0500
Received: from mout.web.de ([212.227.17.12]:49880 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaK1I2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:28:19 -0500
From: Alexander Stein <alexanders83@web.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Date: Fri, 28 Nov 2014 09:27:38 +0100
Message-ID: <1422574.pPO36BQRH8@kongar>
User-Agent: KMail/4.14.3 (Linux/3.14.14-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141128002822.GM4508@piout.net>
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <3935244.Dm2HkZj2Bg@wuerfel> <20141128002822.GM4508@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:J14VESfhWPm8HqIvD5fZ/FTV8kiGKwIDm96efnRTWRnRgsa3Pji
 D6N4qyOw9I0qBSuV/higHSrjuqYGcvPdSlvCMdzLelkuQX6Wq/WQ2ENtCHYBVBtwALsUiyU
 MDT/ql5svPxgz0htA17R2falUVPWV+oa34CqTl9otIIs+Tr70egO1DxDlPPPe0c85+y2Yad
 47wnqBTlbUnc9XtkpvNPg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Friday 28 November 2014, 01:28:22 wrote Alexandre Belloni:
> > >  - sound/atmel/ac97c.c (that one is still not converted to DT anyway...)
> > 
> > This one seems fairly straightforward to do, including a DT binding,
> > but the result is still ugly as it supports the at32 chips that
> > do things very differently.
> > 
> > The patch below gets it to compile and should be enough as a replacement
> > once a compatible string gets added.
> > 
> 
> Actually, some work was done but we never saw an other version of the
> series. Alexander, are you still interested? Else we can take the patch
> below.
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/246679.html

Well, I tried to get a ac97c driver based on alsa soc framework as suggested 
by Takashi. But I failed so far, I could not get my head around those 
architecture.
When keeping my DT support on the current driver, the only thing which is open 
that the bindings should be modifed that they are like soc-ac97link bindings.
I could work on that, but I currently don't know when I can get access again 
to that hardware for testing.

Best regards,
Alexander

