Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbaLIOFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:05:51 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58178 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaLIOFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:05:49 -0500
Message-ID: <548701B6.2030902@collabora.co.uk>
Date: Tue, 09 Dec 2014 15:05:42 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Kukjin Kim <kgene@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] clk: samsung: Fix Exynos 5420 pinctrl setup and clock
 disable failure due to domain being gated
References: <1417788934-23447-1-git-send-email-k.kozlowski@samsung.com> <1418129982.19339.6.camel@AMDC1943> <5486F69B.6020005@samsung.com>
In-Reply-To: <5486F69B.6020005@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/09/2014 02:18 PM, Sylwester Nawrocki wrote:
>> 
>> This is a non-intrusive workaround for that issue, as wanted by
>> Sylwester:
>> https://lkml.org/lkml/2014/12/5/223
>> 
>> Any comments on this?
> 
> The patch looks OK to me, it would be good though if someone else
> has confirmed it fixes the bug. I don't have any clock patches queued
> at the moment. Perhaps you could apply it directly, Mike ?
> 

This patch fixes the boot failure bug on my Exynos5420 Peach Pit
Chromebook and I've audio working as well.

> From my side:
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
