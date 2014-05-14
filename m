Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaENJSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:18:48 -0400
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:38524 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbaENJSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:18:44 -0400
Message-ID: <1400058938.3395.13.camel@linaro1.home>
Subject: Re: [PATCH v6 05/11] drivers: of: add automated assignment of
 reserved regions to client devices
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Grant Likely <grant.likely@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tomasz Figa <t.figa@samsung.com>, Will Deacon <will.deacon@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Michal Nazarewicz <mina86@mina86.com>, Marc <marc.ceeeee@gmail.com>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Date: Wed, 14 May 2014 10:15:38 +0100
In-Reply-To: <20140302054043.4F48AC414EF@trevor.secretlab.ca>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
	 < 1393594976-16728-6-git-send-email-m.szyprowski@samsung.com>
	 <20140302054043.4F48AC414EF@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-02 at 13:40 +0800, Grant Likely wrote:
> On Fri, 28 Feb 2014 14:42:50 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > This patch adds code for automated assignment of reserved memory regions
> > to struct device. reserved_mem->ops->device_init()/device_cleanup()
> > callbacks are called to perform reserved memory driver specific
> > initialization and cleanup
> > 
> > Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>
> > 
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Hi Marek,
> 
> I've not applied this one yet, only because there is still the open
> issue of whether or not these functions should be called from drivers or
> from core code. I don't actually have any problems with the content of
> this patch. Once the user is sorted out I'll merge it.

Has anything more come of these patches? I see some of the series is now
in Linux 3.15, but the actual patches to let people use the feature
aren't there yet, namely patches 5 though 8.

My personal immediate interest in these is as a mechanism on arm64 to
limit CMA to a region of memory that is actually DMA-able devices (e.g.
below 4GB for 32-bit devices without an iommu).

For reference, the mail archives for this series is at
http://lkml.org/lkml/2014/2/28/237

-- 
Tixy

