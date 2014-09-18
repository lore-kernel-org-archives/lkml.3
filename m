Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaIRT33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:29:29 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:52504 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbaIRT32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:29:28 -0400
Message-ID: <1411068565.2017.83.camel@x220>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Date: Thu, 18 Sep 2014 21:29:25 +0200
In-Reply-To: <1409825817.5546.99.camel@x220>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-19-git-send-email-t.figa@samsung.com>
	 <1405505756.4408.24.camel@x220> <53C676DB.6070002@samsung.com>
	 <1409825817.5546.99.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2014 19:29:25.0873 (UTC) FILETIME=[DB784E10:01CFD376]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 12:16 +0200, Paul Bolle wrote:
> On Wed, 2014-07-16 at 14:58 +0200, Tomasz Figa wrote:
> > I had two patches fixing those, but apparently this was lost in action.
> > The correct solution is s/PLAT_S5P/ARCH_S5PV210/. I will include this in
> > a follow-up series if nobody objects.
> 
> No one objected, as far as I know.
> 
> Exactly the same references are still to be found in v3.17-rc3 and
> next-20140903. Perhaps someone actually familiar with this matter (ie,
> not me) could submit one or more patches that implement Tomasz'
> proposal.

We're now at v3.17-rc5 and next-20140918 and nothing has changed. I
raised this issue the day it hit linux-next. After two months it's still
not fixed. Could anyone familiar with ARCH_S5PV210 please jump in?

Thanks,


Paul Bolle

