Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaC0SC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:02:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37509 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaC0SCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:02:53 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-9f-533467cbe063
Message-id: <533467C7.7020804@samsung.com>
Date: Thu, 27 Mar 2014 19:02:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, gregkh@linuxfoundation.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 1/2] clk: Add function parsing arbitrary clock list
 DT property
References: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com>
 <1395922579-28547-2-git-send-email-s.nawrocki@samsung.com>
 <3164460.aT5tTxdc17@amdc1032>
In-reply-to: <3164460.aT5tTxdc17@amdc1032>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xa7qn002CDT7dZ7bYOGM9q8X8I+dY
	LfrfLGS1OPBnB6NF8+L1bBZnm96wW2x6fI3V4vKuOWwWty/zWqw9cpfdYun1i0wWTydcZLNo
	3XuE3WLG5JdsFutnvGZx4PdYM28No0dLcw+bx+W+XiaPTas62TzuXNvD5rF/7hp2j81L6j36
	tqxi9Pi8SS6AM4rLJiU1J7MstUjfLoEr4+fcp2wF35kqZrQ0MjcwbmDqYuTgkBAwkTj3qL6L
	kRPIFJO4cG89WxcjF4eQwFJGifcHXjBCOJ8YJbZcfsUGUsUroCUxp/UFK4jNIqAqsf3YF3YQ
	m03AUKL3aB8jiC0qECExd+JmqHpBiR+T77GA2CICFhJrV7xlARnKLPCRSeLKjWfMIFcIC8RI
	XDxuDlIjJLCYUWLZcisQmxNo1/KND8BmMgvoSOxvncYGYctLbF7zlnkCo8AsJCtmISmbhaRs
	ASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQyPqyg3HxMatDjAIcjEo8vDOsTIKFWBPL
	iitzDzFKcDArifCejAIK8aYkVlalFuXHF5XmpBYfYmTi4JRqYLTrlnt5VWz3LVv7q9K1/Z9r
	LNWjrj18eix9tTDXgQ3JvTHms8s2RYjbT9EvVTVzPxD50r7bUaFuU0jr5Ln653XlI+eJ8C6e
	IqDz8PZN/pIGxUnVfs51IoZXow25T/m37rdonZssxjJh3oRjq29uW1j2XEB06RLtSzFczGlT
	HLyXR3ywneTHr8RSnJFoqMVcVJwIAPolQmuKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On 27/03/14 18:17, Bartlomiej Zolnierkiewicz wrote:
>> +struct clk *of_clk_get_by_property(struct device_node *np,
>
> This causes build brake with s3c6400_defconfig
> (it should be 'static inline').

Thanks for reporting it, I assume you meant "build break"? ;)
Will fix that and similar issue in patch 2/2 for next iteration.

--
Regards,
Sylwester
