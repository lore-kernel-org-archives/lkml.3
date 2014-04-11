Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaDKEuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:50:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34923 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaDKEud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:50:33 -0400
X-AuditID: cbfee690-b7f266d00000287c-cf-5347749722a4
Message-id: <53477499.3030901@samsung.com>
Date: Fri, 11 Apr 2014 13:50:33 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 15/27] ARM: dts: exynos3250: Add uart dt node to support
 seiral ports
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397124377-16969-7-git-send-email-cw00.choi@samsung.com>
 <CAK9yfHxdeJarGCYgLADpxYS3BtxLt6hg0NJBrdYqrcKctFqU1g@mail.gmail.com>
In-reply-to: <CAK9yfHxdeJarGCYgLADpxYS3BtxLt6hg0NJBrdYqrcKctFqU1g@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkRHd6iXuwwc8TVhafP7SwW0y6P4HF
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZnPzTy2gxY/JLNov1M16zWOzdOZnRgdvjzrU9
	bB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8anuSuYC86wVFxf4tvAeJ+5i5GTQ0LA
	RGL2nBNsELaYxIV764FsLg4hgaWMEns+3gIq4gArarmiDhFfxCix9v1MFgjnNaPElA//2EG6
	eQW0JJY9e8ECYrMIqEps/HoXbAMbUHz/ixtgG0QFwiRWTr/CAlEvKPFj8j0wWwSo5mX3ciaQ
	ocwCXcwSj89MBEsIC0RL3Fj3mQli2wlGiTXTp4Bt4xQIljj1Zz2YzSygI7G/dRobhC0vsXnN
	W2aQBgmBR+wS+/5uYoI4SUDi2+RDLBD/yEpsOgD1v6TEwRU3WCYwis1CctQsJGNnIRm7gJF5
	FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZgVJ7+92zCDsZ7B6wPMSYDrZzILCWanA+M6ryS
	eENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYMzS/rF8
	+aZXF6Kklx43uvl119Q5R1wcTgXwLLI453T2vQDTpsCeWwfq2v5ofeCffyHRTlh2rnRW8k6u
	V5ERH/Zdke117J7EdGfys5YYzf49z1tymZdFcPi5v2FRfp8xz3ih6rL7u37MvP9bjGnJ9w4j
	9lU3Jy5vejE750TUrqNGl90vvKtamqCuxFKckWioxVxUnAgARPWT0uACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd3pJe7BBtOnGll8/tDCbjHp/gQW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfJPL6PFjMkv2SzWz3jNYrF352RGB26PO9f2
	sHlsXlLv0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	Ps1dwVxwhqXi+hLfBsb7zF2MHBwSAiYSLVfUuxg5gUwxiQv31rN1MXJxCAksYpRY+34mC4Tz
	mlFiyod/7CBVvAJaEsuevWABsVkEVCU2fr3LDGKzAcX3v7jBBmKLCoRJrJx+hQWiXlDix+R7
	YLYIUM3L7uVMIEOZBbqYJR6fmQiWEBaIlrix7jMTxLYTjBJrpk8B28YpECxx6s96MJtZQEdi
	f+s0NghbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525i
	BMf8M6kdjCsbLA4xCnAwKvHwZlxwCxZiTSwrrsw9xCjBwawkwmvm7x4sxJuSWFmVWpQfX1Sa
	k1p8iDEZGAYTmaVEk/OB6SivJN7Q2MTMyNLI3NDCyNicNGElcd4DrdaBQgLpiSWp2ampBalF
	MFuYODilgCmo25hbTCR2BWvsF+b+lecq795UP5IW4GdrFpm62/JPB/e6JUwmjydd+7O4Y1tm
	UdfNEzt/hZ+2ZXx/yv1Tmlhy0ixz75OTAvMWR6jE+Wxa3fomPkvx8dd1e24JexwWqtS2WeVe
	FR04R9G5+FTO0X7DcFH++g0bInp1dCUOe4YFRs/xCp9bosRSnJFoqMVcVJwIADDqu5E9AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/11/2014 01:03 PM, Sachin Kamat wrote:
> On 10 April 2014 15:36, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch add UART dt node for Exynos3250. Exynos3250 uses same UART IP
>> of Exynos4 SoC and has only two independent channels.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> [Fix incorrect clock id by Tomasz Figa]
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
> 
> typo in patch subject: s/seiral/serial
> 

I'll fix it. Thanks.

Best Regards,
Chanwoo Choi
