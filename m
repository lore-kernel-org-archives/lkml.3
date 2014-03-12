Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaCLDb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:31:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12561 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaCLDb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:31:57 -0400
X-AuditID: cbfee68e-b7f566d000002344-c1-531fd52b9cf0
Message-id: <531FD52B.8040007@samsung.com>
Date: Wed, 12 Mar 2014 12:31:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 1/5] ARM: dts: exynos4x12: Add ADC's dt data to read raw
 data
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
 <1394524494-30641-2-git-send-email-cw00.choi@samsung.com>
 <531EFF7F.9010405@samsung.com>
In-reply-to: <531EFF7F.9010405@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkWFf7qnywwbwNChbzj5xjtTj3aiWj
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12Lp9YtMFhOmr2WxOLziAJPFq4NtLBbr
	Z7xmceD1WDNvDaNHS3MPm8eCz1fYPVYu/8LmsXlJvUffllWMHp83yXlsnBsawBHFZZOSmpNZ
	llqkb5fAlTHtt1hBI1/Fzt+XWRsYP3B1MXJySAiYSJxbcIIdwhaTuHBvPVsXIxeHkMBSRon5
	PyazwBQ9nnyTFSIxnVFidd93ZgjnFVBVE4jDycEroCXx7sVxVhCbRUBVYs+E/2BxNqD4/hc3
	2EBsUYEwiZXTr7BA1AtK/Jh8D8wWEVCRuHxqOiOIzSxwgUliz94iEFtYIFji1cadLBDLFjFK
	bLt+HmwBp4C2xNuTO6EadCT2t05jg7DlJTaveQt2nYRAK4fErvOTmSEuEpD4NvkQ0CQOoISs
	xKYDzBCvSUocXHGDZQKj2CwkN81CMnYWkrELGJlXMYqmFiQXFCelFxnpFSfmFpfmpesl5+du
	YgRG8+l/z/p2MN48YH2IMRlo5URmKdHkfGAyyCuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAh
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJKe+R9Ug4+Uz9o6zTbB+cO8zRp+149wJ9c9trW3
	3iXRPydUtcs3wuHz/pVSpjkXb7rEXpmrfNLi8vH4V7O/h1jyFMtOL7DWtI457Ofxb+nJSyI2
	em9quc4c1Ele+OBw/8eAE7UPD54XjN6eI223jOtknnC+1KGrZQzXp/zo7/x5mMH+la2zpxJL
	cUaioRZzUXEiAATIx+n8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQV3tq/LBBuvnilvMP3KO1eLcq5WM
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXoul1y8yWUyYvpbF4vCKA0wWrw62sVis
	n/GaxYHXY828NYweLc09bB4LPl9h91i5/Aubx+Yl9R59W1YxenzeJOexcW5oAEdUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMab/FChr5Knb+vszawPiBq4uRk0NCwETi
	8eSbrBC2mMSFe+vZuhi5OIQEpjNKrO77zgzhvGKUmN8E4nBy8ApoSbx7cRysg0VAVWLPhP9g
	cTag+P4XN9hAbFGBMImV06+wQNQLSvyYfA/MFhFQkbh8ajojiM0scIFJYs/eIhBbWCBY4tXG
	nSwQyxYxSmy7fh5sAaeAtsTbkzuhGnQk9rdOY4Ow5SU2r3nLPIFRYBaSHbOQlM1CUraAkXkV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCqeCa9g3FVg8UhRgEORiUe3oWa8sFCrIllxZW5
	hxglOJiVRHg/goR4UxIrq1KL8uOLSnNSiw8xJgODYCKzlGhyPjCN5ZXEGxqbmBlZGpkbWhgZ
	m5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD42yF5tIzixNOfTw6I3dtbMCbzQnzXz7q
	W/DC8ap+2x7ZZXfL+i95nnbcY/+V4/SemnuTdh/h/+s0u9bCra18Q/HX+Rc8XGoktVwmrola
	wnErX3GBgtDtaoWN0sUqE0x5HJy/pyvyqh9Mkap/VMBrq1Gve3hWyMawa8yLZ91RdDvwo8qc
	lUUsVomlOCPRUIu5qDgRADUDA7ZZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/11/2014 09:20 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 11.03.2014 08:54, Chanwoo Choi wrote:
>> This patch add ADC(Analog to Digital Converter)'s dt data to get raw data
>> with IIO subsystem. Usually, ADC is used to check temperature, jack type, and
>> so on.
>>
> 
> 8< ---
> 
>> Register map
>> - <0x126C0000 0x100> : ADC register's base address
>> - <0x10020718 0x4> : ADC_PHY_CONTROL, TS-ADC control register address
>>
>> Clock
>> - <&clock 326> : ADC clock (clock name :'tsadc')
>>
>> Interrupt
>> - INTG10[3] : ADC for General ADC
> 
> --- >8
> 
> I don't think there is a need to include such data in commit message. A commit message should say what is done and why it's done (and sometimes how it's done, in case of some complex code being added) and I guess that's all.

OK, I'll remove it on patch description.

> 
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   arch/arm/boot/dts/exynos4x12.dtsi | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
>> index 5c412aa..5a3e551 100644
>> --- a/arch/arm/boot/dts/exynos4x12.dtsi
>> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
>> @@ -80,6 +80,18 @@
>>           };
>>       };
>>
>> +    adc: adc@126C0000 {
>> +        compatible = "samsung,exynos-adc-v1";
>> +        reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>> +        interrupt-parent = <&combiner>;
>> +        interrupts = <10 3>;
>> +        clocks = <&clock 326>;
> 
> Please use clock macros instead of numbers, as introduced by Andrzej Hajda's patches merged to Kgene's tree.
> 
OK, I'll modify it.

Thanks,
Chanwoo Choi
