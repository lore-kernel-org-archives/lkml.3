Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaBKUFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:05:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:39687 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbaBKUE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:04:58 -0500
Message-ID: <1392148971.3835.15.camel@pasglop>
Subject: Re: [PATCH v2 1/5] drivers: of: add initialization code for
 reserved memory
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Date: Wed, 12 Feb 2014 07:02:51 +1100
In-Reply-To: <20140211190104.7E6C5C4140E@trevor.secretlab.ca>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
	 < 1391515773-6112-2-git-send-email-m.szyprowski@samsung.com>
	 <20140205110538. 99E47C40A89@trevor.secretlab.ca>
	 <52FA0D6E.9090304@samsung.com>
	 < 20140211121316.24032C40C4D@trevor.secretlab.ca>
	 <52FA33E2.4050004@samsung. com>
	 <20140211190104.7E6C5C4140E@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 19:01 +0000, Grant Likely wrote:

> > except that the former IMHO better suits the definition of memory 
> > region, which I see as a single contiguous range of memory and can be 
> > simplified to have a single reg entry per region.
> 
> My point is rather if multiple reg tuples are found in a reserved memory
> node, the kernel must respect them and reserve the memory. I'm not
> arguing about whether or not that makes for a good binding.

agreed.

Cheers,
Ben.


