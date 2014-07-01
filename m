Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaGAEFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 00:05:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10546 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaGAEFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 00:05:00 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-53-53b233620795
Message-id: <53B23362.7080103@samsung.com>
Date: Tue, 01 Jul 2014 13:04:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: Add TMU dt node to monitor the temperature for
 Exynos3250
References: <1404175210-9278-1-git-send-email-cw00.choi@samsung.com>
 <CAK5sBcFJMK-y+MZPXCufKEmp=v1nFJHstvNTczsQ3ez3SUPbKw@mail.gmail.com>
In-reply-to: <CAK5sBcFJMK-y+MZPXCufKEmp=v1nFJHstvNTczsQ3ez3SUPbKw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWyRsSkQDfJeFOwwa/rOhaT1h1gsph/5Byr
	Rf+bhawW516tZLToXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBa3L/NaLL1+kcliwvS1LBat
	e4+wW7R8PcdisX7GaxYHfo8189YwerQ097B5XO7rZfL4u+oFs8fOWXfZPVYu/8LmsWlVJ5vH
	5iX1Hn1bVjF6fN4kF8AVxWWTkpqTWZZapG+XwJVxvuUFe8Fa3ornOxYwNjCe4uxi5OSQEDCR
	OPduHxuELSZx4d56IJuLQ0hgKaPE6fvNjDBF+97cZodITGeUeLizhwXCec0ocappAVgVr4CW
	xLHZ08FsFgFViRXT+1hAbDag+P4XN8BWiAqESaycfoUFol5Q4sfke2C2iICaxMyzp8FWMwt8
	ZZFY074baBAHh7BAlMSuQ2C9QgLdjBLbzouB2JwCwRI/3l5mBrGZBdQlJs1bBGXLS2xe85YZ
	ZI6EwEoOiS3HPrBAHCQg8W3yIRaQmRICshKbDjBDfCYpcXDFDZYJjGKzkJw0C8nYWUjGLmBk
	XsUomlqQXFCclF5kpFecmFtcmpeul5yfu4kRGPen/z3r28F484D1IcZkoJUTmaVEk/OBaSOv
	JN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTC6mm51
	ksvyvt6xIKzOyv7Gk1CLtYetg6PXl0UtlbtfuM11hWmXm136pP8bT9yzOZ6y/KvueYnLyzIv
	rnll3zjzmnPaMf6WIvcd6Tw7HKuyNt/+VuTEprAoUCPTdF/5ghg+1uMO3FLBSgzG7pfNFvt5
	nt1rFLp7k01TVh7XStEso23z1qp9XK3EUpyRaKjFXFScCAC7Q0qTEQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jQd0k403BBpd/K1tMWneAyWL+kXOs
	Fv1vFrJanHu1ktGid8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVncvsxrsfT6RSaLCdPXsli0
	7j3CbtHy9RyLxfoZr1kc+D3WzFvD6NHS3MPmcbmvl8nj76oXzB47Z91l91i5/Aubx6ZVnWwe
	m5fUe/RtWcXo8XmTXABXVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QG0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjPMt
	L9gL1vJWPN+xgLGB8RRnFyMnh4SAicS+N7fZIWwxiQv31rN1MXJxCAlMZ5R4uLOHBcJ5zShx
	qmkBI0gVr4CWxLHZ08FsFgFViRXT+1hAbDag+P4XN9hAbFGBMImV06+wQNQLSvyYfA/MFhFQ
	k5h59jTYBmaBrywSa9p3Aw3i4BAWiJLYdQisV0igm1Fi23kxEJtTIFjix9vLzCA2s4C6xKR5
	i6BseYnNa94yT2AUmIVkxSwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZxU
	nkntYFzZYHGIUYCDUYmHV6FhY7AQa2JZcWXuIUYJDmYlEd6/HJuChXhTEiurUovy44tKc1KL
	DzGaAkNgIrOUaHI+MOHllcQbGpuYGVkamRtaGBmbK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+Lg
	lGpgnO21eff0B5u+e+qeWbih6fispTtrOFjVrGdN2PB0xtf62yYNR2osDK7d+WP29u1sPpep
	S9qsVaoSri/+dFPzSoPOHOP7oWffBbHJ8D1fV1t61V5lj9ZE4UX36hf0a/qZsBz8fVX+zd0q
	jw6RqRKNV7y2MBcWd8gXPd7NHp6h+cveyH4qa+X9o0osxRmJhlrMRcWJADSeDQJAAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 07/01/2014 12:33 PM, Sachin Kamat wrote:
> Hi Chanwoo,
> 
> On Tue, Jul 1, 2014 at 6:10 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch add TMU (Thermal Management Unit) dt node to monitor the high
>> temperature for Exynos3250.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> This patch has a dependency on following patch [1]:
>>  [1] https://lkml.org/lkml/2014/6/30/805
>>
>>  arch/arm/boot/dts/exynos3250.dtsi | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
>> index 3660cab..1e566af 100644
>> --- a/arch/arm/boot/dts/exynos3250.dtsi
>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>> @@ -192,6 +192,16 @@
>>                         status = "disabled";
>>                 };
>>
>> +               tmu: tmu@100C0000 {
>> +                       compatible = "samsung,exynos3250-tmu";
>> +                       interrupt-parent = <&gic>;
>> +                       reg = <0x100C0000 0x100>;
>> +                       interrupts = <0 216 0>;
>> +                       clocks = <&cmu CLK_TMU_APBIF>;
>> +                       clock-names = "tmu_apbif";
>> +                       status = "disabled";
> 
> I don't think there would be any board specific properties needed. Hence
> leave the status as enabled (by deleting the above line).
> 

I think that if specific board need TMU feature, dts file for specific board
should include tmu dt node with 'okay' status. The specific board based on
Exynos3250 might not need TMU feature.

Best Regards,
Chanwoo Choi


