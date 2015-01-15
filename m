Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbbAOIO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:14:29 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43934 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbbAOIO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:14:27 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-b0-54b776e2c262
Content-transfer-encoding: 8BIT
Message-id: <1421309663.12511.2.camel@AMDC1943>
Subject: Re: [PATCH 2/2] clk: exynos-audss: Fix memory leak on driver unbind or
 probe failure
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Jan 2015 09:14:23 +0100
In-reply-to: <20150114222504.22722.49023@quantum>
References: <1420451561-12360-1-git-send-email-k.kozlowski@samsung.com>
 <1420451561-12360-2-git-send-email-k.kozlowski@samsung.com>
 <54AEF541.1090700@codeaurora.org> <20150114222504.22722.49023@quantum>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7qPyraHGCy6xm7R//g1s8Wmx9dY
	LS7vmsNmMeP8PiaLpxMuslkcftPOavHjTDeLxapdfxgdODwu9/UyeeycdZfdY9OqTjaPO9f2
	sHlsXlLv0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBkH7z1lK5jCUXGqK7CBcSdbFyMHh4SA
	iUT/f54uRk4gU0ziwr31bCC2kMBSRokf+xVBbF4BQYkfk++xgJQzC8hLHLmUDRJmFlCXmDRv
	EXMXIxdQ+WdGiR073jFB1OtLrLx8kx3EFhaIl7h5YRGYzSZgLLF5+RKw+SICWhLbDrSygTQz
	C7QzSUw9/4UZJMEioCrxfOddVhCbU8BQou3PGmaIg84xSqw5kQpxs7JEY7/bBEaBWUjOm4Vw
	3iwk5y1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERL4X3cwLj1mdYhRgINRiYeXwW97
	iBBrYllxZe4hRgkOZiUR3s4coBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGniNle6PZzAqyF8XW
	3Qn682N379OcCzyM66O0on88UZmqM4FlhofiyZtpOkfM/C9+ETF71VN5kT9xjmr03RKvlvfa
	8xze9Tqf+vMq5MJxPavNk3tSHyVNlVaecMj5+tdvvzq99krlliQe7zYssZrHtlixV+LR74CP
	UVf+G18KOO4TbHNx0/wFSizFGYmGWsxFxYkAQeMtv1oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2015-01-14 at 14:25 -0800, Mike Turquette wrote:
> Quoting Stephen Boyd (2015-01-08 13:23:13)
> > On 01/05/2015 01:52 AM, Krzysztof Kozlowski wrote:
> > > The memory allocated by basic clock divider/gate/mux (struct clk_gate,
> > > clk_divider and clk_mux) was leaking. During driver unbind or probe
> > > failure the driver only unregistered the clocks.
> > >
> > > Use clk_unregister_{gate,divider,mux} to release all resources.
> > >
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > >
> > 
> > Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> I've applied both patches to clk-next. Krzysztof, let me know if you
> would prefer to take the audss patch through the samsung clock branch
> instead (to include it in a later pull request).

Thanks! I'm fine with applying them to clk-next.

Best regards,
Krzysztof


> 
> Regards,
> Mike
> 
> > 
> > -- 
> > Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> > a Linux Foundation Collaborative Project
> > 

