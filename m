Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaLXQgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:36:37 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46720 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaLXQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:36:34 -0500
Date: Wed, 24 Dec 2014 17:36:26 +0100
From: Paolo Pisati <p.pisati@gmail.com>
To: Kevin Hilman <khilman@kernel.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] clk: samsung: Fix Exynos 5420 pinctrl setup and clock
 disable failure due to domain being gated
Message-ID: <20141224163626.GA3902@peachpi>
References: <1417788934-23447-1-git-send-email-k.kozlowski@samsung.com>
 <1418129982.19339.6.camel@AMDC1943>
 <5486F69B.6020005@samsung.com>
 <7hlhmfo1b0.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hlhmfo1b0.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 09:35:31AM -0800, Kevin Hilman wrote:
> 
> I confirm it fixes the boot hang in linux-next (next-20141210) on my
> exynos5800-peach-pi and exynos5420-arndale-octa.  Tested both
> exynos_defconfig and multi_v7_defconfig.
> 
> Tested-by: Kevin Hilman <khilman@linaro.org>

does audio work on your peach pi? because kernel boots fine, but i can't get any
audio out of it

-- 
bye,
p.
