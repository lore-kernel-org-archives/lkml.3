Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaBRNXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:23:37 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39466 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbaBRNX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:23:27 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-1e-53035ecb5a04
Message-id: <53035ECA.5080804@samsung.com>
Date: Tue, 18 Feb 2014 14:23:22 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH RESEND v3] clk: return probe defer when DT clock not yet
 ready
References: <20140208132446.2A26694003E@smtp1-g21.free.fr>
In-reply-to: <20140208132446.2A26694003E@smtp1-g21.free.fr>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xq7qn45iDDeaf0LeYf+Qcq8WBPzsY
	LTY9vsZqcXnXHDaL25d5Ld5emMli8XTCRTaL1r1H2B04PFqae9g8+td9ZvXYtKqTzePOtT1s
	HpuX1Ht83iQXwBbFZZOSmpNZllqkb5fAlfFw5lzmgu/MFV9vvmRsYJzL3MXIySEhYCJxanYb
	C4QtJnHh3nq2LkYuDiGBpYwS6y61M0E4nxgl9uzrAevgFdCS6FgwjbGLkYODRUBV4s9GAZAw
	m4ChRO/RPkYQW1QgQuLV2YksEOWCEj8m3wOzRQSqJBZNmwW2gFlgA6PEr0/bwWYKC4RITFrZ
	wg5iCwlYScxdf4MNxOYUsJb4vHci2FBmAR2J/a3T2CBseYnNa94yT2AUmIVkxywkZbOQlC1g
	ZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERL2X3YwLj5mdYhRgINRiYf3gzJTsBBrYllx
	Ze4hRgkOZiURXs0o5mAh3pTEyqrUovz4otKc1OJDjEwcnFINjOsPqK5sapdx/zfpblKcZteO
	usPdta8LuWcafpNninq94Hr2XG4lXZMLfb/ksvZ//Lr17zpb5rRM345Exw9CPdfjPJuEY189
	q2o8Pn1fjE8ZX6ddmVDWtvTj1asWvbncnblypcnkOB/HpLVrd59RXO3fUHTsyJttafMfZzn/
	+3CR2cfKqGvXRyWW4oxEQy3mouJEAMPsD6BZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/13 19:47, Jean-Francois Moine wrote:
> At probe time, a clock device may not be ready when some other device
> wants to use it.
> 
> This patch lets the functions clk_get/devm_clk_get return a probe defer
> when the clock is defined in the DT but not yet available.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Hope this can be merged for v3.15. Thanks.
