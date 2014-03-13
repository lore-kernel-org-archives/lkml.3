Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaCMOd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:33:28 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55712 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaCMOd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:33:26 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-10-5321c1b41ed5
Message-id: <5321C1B3.2050806@samsung.com>
Date: Thu, 13 Mar 2014 15:33:23 +0100
From: Tomasz Figa <t.figa@samsung.com>
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
Subject: Re: [PATCH v2 1/3] clk: s2mps11: Add support for S2MPS14 clocks
References: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
 <1394703425-6462-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1394703425-6462-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xK7pbDioGG1xfJG+xccZ6VovXLwwt
	zja9Ybe4//Uoo8Wmx9dYLS7vmsNmMeP8PiaLtUfusls8nXCRzeLkn15Gi9PdrBYXV3xhsmj/
	u5fNYs70d0wOfB53ru1h85h3MtBj85J6j74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL4MpY2TmN
	rWA1S8X5rUYNjEeZuxg5OSQETCQ+35oFZYtJXLi3nq2LkYtDSGApo8TZj6+ZIZzPjBLNzR/Y
	QKp4BbQk/vVNZOxi5OBgEVCVuHInGyTMJqAm8bnhEViJqECExNyJm6HKBSV+TL7HAjJHRGAL
	k0TXlauMIA6zwCwmiQubm5hAqoQFPCRuXtrHBLGtmVHi7/bJ7CAJTgF3iXvrDjCC2MwC1hIr
	J22DsuUlNq95yzyBUWAWki2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI
	nHzZwbj4mNUhRgEORiUe3hXLFYKFWBPLiitzDzFKcDArifBab1IMFuJNSaysSi3Kjy8qzUkt
	PsTIxMEp1cDIIrTd4EfZfecfizPdry2bfONc0tHS9t1f/BZ9mlnwWeHtF00D33qj7Ev7KvkF
	P7+eueWOWeZzyT0n/q/Zd87w1aOt+ZZH9ko7nRLhebimoMojY2OJ4O7dqlclV/PLtWhmu00s
	mGDBlSxzh7FuTg33j7jn95ZVM+kzTHa56B4r7zJvzRs+zXeySizFGYmGWsxFxYkAKn6YCnEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 13.03.2014 10:37, Krzysztof Kozlowski wrote:
> This patch adds support for S2MPS14 PMIC clocks (BT and AP) to the
> s2mps11 clock driver.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> ---
>   drivers/clk/Kconfig       |    8 +++---
>   drivers/clk/clk-s2mps11.c |   61 ++++++++++++++++++++++++++++++++++-----------
>   2 files changed, 50 insertions(+), 19 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
