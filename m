Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006AbaGPO0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:26:14 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:56985 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934390AbaGPO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:26:10 -0400
Message-ID: <1405520767.4408.39.camel@x220>
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
Date: Wed, 16 Jul 2014 16:26:07 +0200
In-Reply-To: <53C67386.5070401@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-5-git-send-email-t.figa@samsung.com>
	 <1405502840.4408.2.camel@x220> <53C67386.5070401@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2014 14:26:08.0379 (UTC) FILETIME=[E27B14B0:01CFA101]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 14:43 +0200, Tomasz Figa wrote:
> On 16.07.2014 11:27, Paul Bolle wrote:
> > There are three further references to CONFIG_SAMSUNG_CLOCK in this file.
> > Those should be removed too, shouldn't they?
> 
> That's right. Apparently I missed them. I guess that's not critical,
> though, and could be done in separate patch, right?

This is not critical at all, so that's fine with me. 


Paul Bolle

