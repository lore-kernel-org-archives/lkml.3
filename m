Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbaGPOfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:35:30 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:59427 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964942AbaGPOf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:35:27 -0400
Message-ID: <1405521324.4408.44.camel@x220>
Subject: Re: [PATCH 04/19] serial: samsung: Remove support for legacy clock
 code
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Wed, 16 Jul 2014 16:35:24 +0200
In-Reply-To: <1405520767.4408.39.camel@x220>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-5-git-send-email-t.figa@samsung.com>
	 <1405502840.4408.2.camel@x220> <53C67386.5070401@samsung.com>
	 <1405520767.4408.39.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2014 14:35:25.0257 (UTC) FILETIME=[2E67EB90:01CFA103]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 16:26 +0200, Paul Bolle wrote:
> On Wed, 2014-07-16 at 14:43 +0200, Tomasz Figa wrote:
> > That's right. Apparently I missed them. I guess that's not critical,
> > though, and could be done in separate patch, right?
> 
> This is not critical at all, so that's fine with me. 

Actually, that's only correct if the solution here is to just remove the
(currently) dead code hidden behind CONFIG_SAMSUNG_CLOCK. But if the
solution requires something less trivial, that might be quite wrong.

So please disregard my comment!


Paul Bolle

