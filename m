Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaGWMrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:47:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34040 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaGWMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:47:46 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-9b-53cfaef01f0f
Message-id: <53CFAEEE.7040702@samsung.com>
Date: Wed, 23 Jul 2014 14:47:42 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/2] clk: samsung: exynos4: Enable ARMCLK down feature
References: <1405694193-29643-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1405694193-29643-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xy7of1p0PNvj8XMRi44z1rBavXxha
	9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLtUfusls8nXCRzYHT4861PWwem5fUe/RtWcXo
	8XmTXABLFJdNSmpOZllqkb5dAlfGvVuN7AVTmSoWH2hnaWC8w9jFyMkhIWAisehaNzOELSZx
	4d56ti5GLg4hgaWMEv0nfrNCOJ8ZJbqm32ACqeIV0JJofTMHqIqDg0VAVeL+pwyQMJuAmsTn
	hkdsIDY/UMmapussILaoQITEgb5nrBCtghI/Jt8Di4sIvGKUOPzQCWQ+s8AURonmSUvB5gsL
	+Eos+vKBHcQWEnCXOLbpHwvILk4BD4nfF2NAwswCOhL7W6exQdjyEpvXvGWewCg4C8mKWUjK
	ZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJAa+7GBcfMzqEKMAB6MSDy/Dw1PB
	QqyJZcWVuYcYJTiYlUR4V/ecDxbiTUmsrEotyo8vKs1JLT7EyMTBKdXA2Lxqo8oXtvptjzRL
	M4rSzsRNv76xJu6r0fT9ttdXJSXkaf0RPt667PnXRzmxxQ+W5jnHeHzp7+SqcS/MFPXevCO/
	ctUTbj+PKmNzI6M/x4OkJko+ujBhw9KThVP27GJd0G+V8vHtNu+dxXO0r/9t7/6V7xU/U/LH
	jgT/AC6zxjuOVcuW9nomKbEUZyQaajEXFScCAGCVq5pfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 18.07.2014 16:36, Krzysztof Kozlowski wrote:
> Enable ARMCLK down feature on all Exynos4 SoCs. The frequency of
> ARMCLK will be reduced upon entering idle mode (WFI or WFE).

Will apply the whole series to Samsung clock tree.

Best regards,
Tomasz
