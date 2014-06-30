Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaF3Nux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:50:53 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63848 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaF3Nuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:50:50 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-1f-53b16b384aa9
Message-id: <53B16B1E.8090206@samsung.com>
Date: Mon, 30 Jun 2014 15:50:22 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 3/6] clk: samsung: exynos4: Remove SRC_MASK_ISP gates
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-4-git-send-email-t.figa@samsung.com>
In-reply-to: <1403618235-19353-4-git-send-email-t.figa@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xq7oW2RuDDXZ9s7DoXXCVzWLT42us
	Fpd3zWGzmHF+H5PF2iN32S2eTrjIZrFq1x9GB3aPnbPusnvcubaHzWPzknqPvi2rGD0+b5IL
	YI3isklJzcksSy3St0vgyrjfc5i54DBLxYbHr1gaGG8xdzFycEgImEicvJbXxcgJZIpJXLi3
	nq2LkYtDSGApo8Slm+3MIAkhgc+MEp+nKoDYvAJaEsvPdoDFWQRUJf4dvghmswmoSXxueMQG
	YvMD1axpus4CMl9UIELi8QUhiFZBiR+T77GA2CJArZ/bFrCD2MwCrxglplyMArGFBTwlPs6f
	zQaxtlpiw4k5YOM5BZwl3r5sZYOo15HY3zoNypaX2LzmLfMERsFZSFbMQlI2C0nZAkbmVYyi
	qaXJBcVJ6bmGesWJucWleel6yfm5mxghYf9lB+PiY1aHGAU4GJV4eBtXbAgWYk0sK67MPcQo
	wcGsJMJ702djsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGo1MOUklcl+/sMhG4frIpe4o8Q4TJ
	G24X7cxZn5mefYw2b/J79mMGp6iWQG1YGo/RcmaO/xkXT1op25vM+JK/q1mnYF5yyMp5Z5cq
	zf0801P+hERF9O1L/3Mtjp8o6fvFnvLD0l85Xn2b5oWHbU/yFINdjXQK98wvOLGgUf/qXeUT
	m6QK69yUWIozEg21mIuKEwGWq6DXWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.2014 15:57, Tomasz Figa wrote:
> ISP special clocks have dedicated gating registers and so MUX SRC_MASK
> register should not be used. This patch fixes the problem of
> Exynos4x12-based boards freezing on system suspend, because those
> mux outputs need not to be masked while suspending.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/samsung/clk-exynos4.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)

Applied as a fix for 3.16.

Best regards,
Tomasz
