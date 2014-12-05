Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaLENDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:03:11 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18593 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaLENDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:03:09 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0b-5481ad0aed7b
Message-id: <5481ACFC.8000502@samsung.com>
Date: Fri, 05 Dec 2014 14:02:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 1/3] clk: samsung: Fix clock disable failure because
 domain being gated
References: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
 <1417777254-26579-2-git-send-email-k.kozlowski@samsung.com>
 <5481955A.9000703@samsung.com> <5481A650.8020408@collabora.co.uk>
In-reply-to: <5481A650.8020408@collabora.co.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xq7pcaxtDDC6t0bHYOGM9q0XblYPs
	Fkd/F1i8fmFo0f/4NbPF082PmSzONr1ht9j0+BqrxeVdc9gsZpzfx2Sx9shddounEy6yWaza
	9YfRgdfj7/PrLB47Z91l99i0qpPN4861PWwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5d
	AlfGjkObWQves1R0bFvG1MD4kbmLkZNDQsBEYtnRdVC2mMSFe+vZuhi5OIQEljJKfOt/zQTh
	fGKUePvkMTtIFa+AlsS/Tw8Zuxg5OFgEVCWubLIDCbMJGEr0Hu1jBLFFBSIkTt7dA1UuKPFj
	8j0WEFtEwE7ixuqHzCAzmQXeMEu8PvseLCEskCBx/eBDFohlJxklXn4+ygaS4BTQl1h44hXY
	MmYBPYn7F7VAwswC8hKb17xlnsAoMAvJjlkIVbOQVC1gZF7FKJpamlxQnJSea6hXnJhbXJqX
	rpecn7uJERIvX3YwLj5mdYhRgINRiYf3gnVjiBBrYllxZe4hRgkOZiUR3uTZQCHelMTKqtSi
	/Pii0pzU4kOMTBycUg2MibqWRyp/2hXI5J4Q2CQT7ns8y1mJtXh3reC8jmkFAffPbHjuEai9
	MJdFQfH6l8fJWZ6LmHgSDa3P73+ZscjkL/dWj1vR2ofW90SuORUyZ13vA5uCc01bJt2ZUlok
	K+zF+jRhY4bu+fc9DAZHhA7EVb8N21h5n/9zIAfnoQMMKi2t6hKc6ZJKLMUZiYZazEXFiQAK
	dIJTdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 13:34, Javier Martinez Canillas wrote:
> Hello Sylwester,
> 
> On 12/05/2014 12:22 PM, Sylwester Nawrocki wrote:
>>> >> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> > 
>> > Can you confirm sound works with this patch on exynos5420 ? Or does
>> > your Tested-by refer only to successful booting ?
>> > 
> I tested latest linux-next + "clk: samsung: Fix double add of syscore
> ops after driver rebind" [0] + this series and I confirm that sound is
> also working on my Exynos5420 Peach Pit Chromebook.

OK, thanks a lot for checking it again.

--
Regards,
Sylwester
