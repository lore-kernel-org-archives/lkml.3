Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaK1JUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:20:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58893 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaK1JUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:20:01 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-63-54783e3e11b5
Message-id: <1417166396.18249.16.camel@AMDC1943>
Subject: Re: [PATCH v4 3/7] regulator: of: Parse ena-gpios property from DTS
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 28 Nov 2014 10:19:56 +0100
In-reply-to: <20141127184544.GD7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-4-git-send-email-k.kozlowski@samsung.com>
 <20141127184544.GD7712@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xy7p2dhUhBvPblS02zljPajH14RM2
	i/lHzrFa9D9+zWxxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CxmnN/HZLH2yF12B26PnbPu
	sntsWtXJ5nHn2h42j81L6j36tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr48GFOcwFl1kqni8s
	bGC8xtzFyMEhIWAiMftAZhcjJ5ApJnHh3nq2LkYuDiGBpYwSDxsns0I4nxkl/izsZARp4BUw
	kJh80AykQVjAR2L/yXNMIDabgLHE5uVL2EBsEQFliavf97KA9DILNDNL/HvwjxWkl0VAVWLT
	jnCQGk4BI4kbe2awQMxfyyixauFFdpAEs4C6xKR5i6COU5Zo7HcDCfMKCEr8mHyPBaJEXmLz
	mrfMExgFZiHpmIWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQiLiyw7Gxces
	DjEKcDAq8fAmPC4LEWJNLCuuzD3EKMHBrCTCe+preYgQb0piZVVqUX58UWlOavEhRiYOTqkG
	xtIXi1Mco7S43X5tj+W8wLIy+86//aG7Y1XWqxX8/rJdc7Xeog9Cql5c8yWXTtxj+GX7Yvtv
	O9JVd5uc6v1Wmrdl2d21x3wSV68/YMVwuscvXEtOL0VmqhDjvZNF8ddCJ8wOsWtT3La3e67T
	mjjj25XbbL/GxwfpSuqrFPm/mL/zVk7aqgs3e5VYijMSDbWYi4oTAU9zj4JmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 18:45 +0000, Mark Brown wrote:
> On Thu, Nov 27, 2014 at 12:20:49PM +0100, Krzysztof Kozlowski wrote:
> 
> > +	constraints->ena_gpio = of_get_named_gpio_flags(np, "ena-gpios", 0,
> > +							&gpio_flags);
> > +	if (gpio_is_valid(constraints->ena_gpio)) {
> 
> No, this isn't sensible - in what way would an enable control GPIO be a
> constraint?  The whole reason we have separate constraint and config
> structures is that these are different things.  Keep the GPIO setup in
> the configuration.

OK, I'll change it to config.

Best regards,
Krzysztof


