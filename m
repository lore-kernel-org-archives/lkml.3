Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaIVI3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:29:45 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:41929 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaIVI3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:29:43 -0400
Message-ID: <541FDDF3.6020609@gmail.com>
Date: Mon, 22 Sep 2014 10:29:39 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 1/3] clk: samsung: exynos3250: Register DMC clk provider
References: <1409664077-27121-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1409664077-27121-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.09.2014 15:21, Krzysztof Kozlowski wrote:
> Add clock provider for clocks in DMC domain including EPLL and BPLL. The
> DMC clocks are necessary for Exynos3 devfreq driver.
> 
> The DMC clock domain uses different address space (0x105C0000) than
> standard clock domain (0x10030000 - 0x10050000). The difference is huge
> enough to add new DT node for the clock provider, rather than extending
> existing address space.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Changes since v1:
> =================
> 1. Fix overwritteing main clock provider reg_base with DMC clock domain
>    reg_basr. This leads to OOPS in suspend.

Applied the whole series for next.

Best regards,
Tomasz
