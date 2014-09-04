Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaIDKIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:08:41 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:54391 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbaIDKIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:08:39 -0400
Message-ID: <1409825317.5546.94.camel@x220>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Thu, 04 Sep 2014 12:08:37 +0200
In-Reply-To: <53C67783.4090407@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-19-git-send-email-t.figa@samsung.com>
	 <1405506268.4408.28.camel@x220> <53C67783.4090407@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 10:08:38.0579 (UTC) FILETIME=[32563030:01CFC828]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 15:00 +0200, Tomasz Figa wrote:
> On 16.07.2014 12:24, Paul Bolle wrote:
> > On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:
> >> -config S5P_GPIO_DRVSTR
> >> -	bool
> >> -	help
> >> -	  Internal configuration to get and set correct GPIO driver strength
> >> -	  helper
> >> -
> > 
> > This one is used (as a macro) in drivers/gpio/gpio-samsung.c. Is a patch
> > that touches that macro queued somewhere?
> 
> The code you mention should be removed as well as it's no longer needed.
> Will include in a follow-up series. Thanks for reporting this and
> remaining missed parts.

That check for CONFIG_S5P_GPIO_DRVSTR is still present in v3.17-rc3 and
next-20140903. Should I submit the trivial patch to remove it (and the
dead code it hides)?


Paul Bolle

