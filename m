Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaGGPfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:35:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65006 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaGGPfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:35:17 -0400
X-AuditID: cbfee61b-f79f86d00000144c-5a-53babe322107
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: EXYNOS: add EXYNOS3250 PMU support
Date: Mon, 07 Jul 2014 17:34:56 +0200
Message-id: <1807423.y4ukxv9Bv7@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <2031373.hXVBStNvpj@amdc1032>
References: <2031373.hXVBStNvpj@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQV2jfbuCDX7eUbG4/uU5q0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsli09Qu7xfoZr1kcODw2L6n36NuyitHj8ya5AOYoLpuU
	1JzMstQifbsEroxH6ycyF7SwVKydepOpgXEpcxcjJ4eEgInE0TkHGSFsMYkL99azdTFycQgJ
	TGeUWHT4KCOE08IksX/LUXaQKjYBK4mJ7avAOkQE1CR6Fm8FK2IW6GaS2LP3LitIQljARqJ5
	VzcLiM0ioCrx/PkXsGZeAU2Ji1d2gK0WFfCU2LF9JRuIzSmgJfHu7hwmEFsIqGbrkQ1sEPWC
	Ej8m3wObwywgL7Fv/1RWCFtLYv3O40wTGAVmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGCg/uZ9A7GVQ0WhxgFOBiVeHgPrNoZLMSaWFZcmXuIUYKDWUmEd8XyXcFC
	vCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGDkE12s/z3n1
	5dH5w2pbtC6lxB6dHLfAkvmNUkny6eT17lrMHRsV3nm8SP/H5mbyydBHP9OpZq9p65qZ6xbw
	+Hja6l/XVbFQTdfuVls5dcN/L5072ud1+8uSTy49d/uPxvpfe+wmihvU5jxrmqyYIKr0U5f9
	hjff4dl93MdvCkbKnGT9eLC3SYmlOCPRUIu5qDgRAOkl7UpqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kukjin,

On Monday, June 02, 2014 06:54:07 PM Bartlomiej Zolnierkiewicz wrote:
> 
> This is needed for suspend/resume and cpuidle AFTR mode support.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> against next-20140602

Could this patch be applied for v3.17 please?

[ It still applies fine to next-20140707. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

