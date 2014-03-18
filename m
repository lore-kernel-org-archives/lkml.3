Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaCROaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:30:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36557 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbaCROaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:30:10 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-79-5328586f94e0
Message-id: <5328586B.1010208@samsung.com>
Date: Tue, 18 Mar 2014 15:30:03 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v3 2/3] mfd: sec-core: Add of_compatible strings for clock
 MFD cells
References: <1395047958-17953-1-git-send-email-k.kozlowski@samsung.com>
 <1395047958-17953-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1395047958-17953-3-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xq7r5ERrBBgvP61lsnLGe1eL1C0OL
	s01v2C3ufz3KaLHp8TVWi8u75rBZzDi/j8li7ZG77BZPJ1xkszj5p5fR4nQ3q8XFFV+YLNr/
	7mWzmDP9HZMDn8eda3vYPOadDPTYvKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDLmNExk
	LXjBVNFycyJbA+Nipi5GTg4JAROJNQs2s0LYYhIX7q1n62Lk4hASWMoosXzTEXYI5zOjxIOF
	DcwgVbwCWhKPvn8G62YRUJW4+ncWWJxNQE3ic8MjNhCbH6hmTdN1FhBbVCBCYu7EzWwQvYIS
	PybfYwEZKiKwhUmi68pVRhCHWWAWk8SFzU1gU4UFoiRmTO1hhljdyiixfvtRsFGcAh4SW35f
	BbOZBawlVk7axghhy0tsXvOWeQKj4CwkW2YhKZuFpGwBI/MqRtHU0uSC4qT0XEO94sTc4tK8
	dL3k/NxNjJAY+rKDcfExq0OMAhyMSjy8L9jUg4VYE8uKK3MPMUpwMCuJ8K521wgW4k1JrKxK
	LcqPLyrNSS0+xMjEwSnVwCiQVf/04R6xTN1Q87gp03VmzExyF/m9Rfy/4GVWZ1enl1qTs+ev
	md21qiPjZYr/uRZmhqmn6xt1rbJuHbD2qiiWMzp+l4/TTJItiVug7qLGi1/qYRmMnG9+PVl9
	99WW+VtrtIp01l179EF6c838Lu4pucuvnazN9RKpeWPwyCH226QDW9ZNVFFiKc5INNRiLipO
	BADfxi7CfwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 17.03.2014 10:19, Krzysztof Kozlowski wrote:
> Add of_compatible strings for S5M8767 and S2MPS14 clock MFD cells.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>   drivers/mfd/sec-core.c |    3 +++
>   1 file changed, 3 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
