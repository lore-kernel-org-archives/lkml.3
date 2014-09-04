Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaIDJmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:42:25 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:56385 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbaIDJmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:42:24 -0400
Message-ID: <1409823741.5546.82.camel@x220>
Subject: Re: [PATCH 04/19] serial: samsung: Remove support for legacy clock
 code
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Thu, 04 Sep 2014 11:42:21 +0200
In-Reply-To: <1409823567.5546.80.camel@x220>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-5-git-send-email-t.figa@samsung.com>
	 <1405502840.4408.2.camel@x220> <53C67386.5070401@samsung.com>
	 <1405520767.4408.39.camel@x220> <1405521324.4408.44.camel@x220>
	 <53C68FAB.9070102@samsung.com> <1409823567.5546.80.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 09:42:21.0599 (UTC) FILETIME=[866222F0:01CFC824]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Use Tomasz's new address and add Sylwester.]

On Thu, 2014-09-04 at 11:39 +0200, Paul Bolle wrote:
> On Wed, 2014-07-16 at 16:43 +0200, Tomasz Figa wrote:
> > On 16.07.2014 16:35, Paul Bolle wrote:
> > > On Wed, 2014-07-16 at 16:26 +0200, Paul Bolle wrote:
> > >> On Wed, 2014-07-16 at 14:43 +0200, Tomasz Figa wrote:
> > >>> That's right. Apparently I missed them. I guess that's not critical,
> > >>> though, and could be done in separate patch, right?
> > >>
> > >> This is not critical at all, so that's fine with me. 
> > > 
> > > Actually, that's only correct if the solution here is to just remove the
> > > (currently) dead code hidden behind CONFIG_SAMSUNG_CLOCK. But if the
> > > solution requires something less trivial, that might be quite wrong.
> > > 
> > > So please disregard my comment!
> > 
> > The code between those ifdefs is no longer used, because all Samsung
> > platforms use the Common Clock Framework after this series. So I believe
> > we can safely remove this dead code.
> 
> The three checks for CONFIG_SAMSUNG_CLOCK can still be seen in v3.17-rc3
> and next-20140903. Should I perhaps submit the trivial patch to remove
> them (and the code they hide) or did things turn out to be more
> complicated?
> 
> 
> Paul Bolle

