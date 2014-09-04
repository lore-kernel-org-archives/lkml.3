Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaIDQET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:04:19 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50826 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaIDQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:04:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
Date: Thu, 4 Sep 2014 18:03:45 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com> <53C67783.4090407@samsung.com> <1409825317.5546.94.camel@x220>
In-Reply-To: <1409825317.5546.94.camel@x220>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201409041803.46098.arnd@arndb.de>
X-Provags-ID: V02:K0:6EyhYRByjt4nLo2yYvQsNVtVicHIscgrZS6r+utNHHg
 Fkv7C6tOs3ACAWG7YbIgAyZKMB8Zx0WSDHzlOhwNCjeSsdUQsI
 MteIqz1csRIRqctItk+nORGBkp8MJsShur7wWNEAYIRCKdktTq
 NCHd6OV5CMxhXgdo/9vhJtnwHB30wqb/z1allD3pXfaqOq+RQ5
 1SoDg2hKodJ4rg1ab1tCJm2LTIDjpQenMuXkVSg5SAtefhI7ks
 9VePXHgAt2bzO34TvH5aOHPkL8RKxyImPqDsS6QRq5WTv6Gczh
 tqQJzsmP7IaWivyBfDjKKjUT3j/MW5uqRTUYHDqagnZy2E/HlQ
 UcsEDYPzLdWCdRbnzLBo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 September 2014, Paul Bolle wrote:
> On Wed, 2014-07-16 at 15:00 +0200, Tomasz Figa wrote:
> > On 16.07.2014 12:24, Paul Bolle wrote:
> > > On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:
> > >> -config S5P_GPIO_DRVSTR
> > >> -  bool
> > >> -  help
> > >> -    Internal configuration to get and set correct GPIO driver strength
> > >> -    helper
> > >> -
> > > 
> > > This one is used (as a macro) in drivers/gpio/gpio-samsung.c. Is a patch
> > > that touches that macro queued somewhere?
> > 
> > The code you mention should be removed as well as it's no longer needed.
> > Will include in a follow-up series. Thanks for reporting this and
> > remaining missed parts.
> 
> That check for CONFIG_S5P_GPIO_DRVSTR is still present in v3.17-rc3 and
> next-20140903. Should I submit the trivial patch to remove it (and the
> dead code it hides)?
> 

Yes, I think this one is an obvious candidate for removal.

	Arnd
