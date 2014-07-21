Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaGUBwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:52:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35115 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaGUBwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:52:32 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-8b-53cc725d794b
Message-id: <53CC725C.9010406@samsung.com>
Date: Mon, 21 Jul 2014 10:52:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chanwoo Choi <cwchoi00@gmail.com>, jic23@kernel.org,
        naveen krishna <ch.naveen@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        rdunlap@infradead.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
 <5835825.JtcDoyOP8b@wuerfel>
 <CAGTfZH3mnPJ72wi7aFYoChe_OeuRVsUVo3KGRRLTV5scwPbO4g@mail.gmail.com>
 <5381273.c6GzlyQ7Ea@wuerfel>
In-reply-to: <5381273.c6GzlyQ7Ea@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWyRsSkRDe26Eywwe/5shZ/Jx1jt7j7/DCj
	xbOj2hbzj5xjteh/s5DV4tyrlYwWD5pWMVn0LrjKZnG26Q27xabH11gtFrYtYbGYd+Qdi8Xl
	XXPYLGac38dksfT6RSaLCdPXsli8vTOdxaJ17xF2i/UzXrM4CHusmbeG0eP3r0mMHpf7epk8
	ds66y+6xcvkXNo/NK7Q8Nq3qBDKW1Hv0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXxtX2tYwF
	zeoVz6a8YGlgbJPuYuTgkBAwkVi+3KuLkRPIFJO4cG89WxcjF4eQwFJGiU0zNzNDJEwk7kxb
	wA6RmM4osefxOkYI5zWjxJG2x4wgVbwCWhJvpi9gAbFZBFQlLqycww5iswHF97+4wQZiiwqE
	SaycfoUFol5Q4sfke2C2iICixNQXz5hBhjILTGGV+Ncxmw3kPGGBWInpq2Mhlp1ilDi77yrY
	SZwCmhJnthwEs5kFdCT2t05jg7DlJTaveQs2SELgBIfEy4U72SEuEpD4NvkQC8TPshKbDkC9
	JilxcMUNlgmMYrOQ3DQLydhZSMYuYGRexSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRGYHE7/
	ezZxB+P9A9aHGJOBVk5klhJNzgcml7ySeENjMyMLUxNTYyNzSzPShJXEedMfJQUJCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYOz1UMruEj9mkyX1VKG0WKOgg+Mxb4Puj7NNx1xD5T69a33T
	pabHu5qNszaW+0tE4SLmyUtPMj79cFVgn3ftHAFx9dDOop9JT/W/7lnPFqH5l+12Bu8XNpel
	+4uXrz3r3nVx8b4nP3lVth8+mfP8oMZbh1p7VekJogVPD9wTX3souf71C41WCyWW4oxEQy3m
	ouJEANUNw3gkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd3YojPBBv9fC1n8nXSM3eLu88OM
	Fs+OalvMP3KO1aL/zUJWi3OvVjJaPGhaxWTRu+Aqm8XZpjfsFpseX2O1WNi2hMVi3pF3LBaX
	d81hs5hxfh+TxdLrF5ksJkxfy2Lx9s50FovWvUfYLdbPeM3iIOyxZt4aRo/fvyYxelzu62Xy
	2DnrLrvHyuVf2Dw2r9Dy2LSqE8hYUu/Rt2UVo8fnTXIBXFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QJ8pKZQl5pQChQISi4uV9O0wTQgNcdO1
	gGmM0PUNCYLrMTJAAwlrGDOutq9lLGhWr3g25QVLA2ObdBcjJ4eEgInEnWkL2CFsMYkL99az
	dTFycQgJTGeU2PN4HSOE85pR4kjbY0aQKl4BLYk30xewgNgsAqoSF1bOAetmA4rvf3GDDcQW
	FQiTWDn9CgtEvaDEj8n3wGwRAUWJqS+eMYMMZRaYwirxr2M2UAMHh7BArMT01bEQy04xSpzd
	d5UZpIFTQFPizJaDYDazgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECE4+z6R2MK5ssDjEKMDBqMTD68F4JliINbGsuDL3EKMEB7OS
	CO+JDKAQb0piZVVqUX58UWlOavEhRlNgEExklhJNzgcmxrySeENjEzMjSyNzQwsjY3Mlcd4D
	rdaBQgLpiSWp2ampBalFMH1MHJxSDYzHagQyXFn0z8hIeM2/07an5dw2r/mutgtW3HFYuq9k
	TXn3HMEpOomCnWvfP5zufudu/syCZ3481Rq1sz8HnXic8Cquo6lFs+JJcPOrvXGVc6vXR9Sc
	fnperHC95vND374U8V1hdP/1aVZVt0VMXox6en8wp/9ycZPN3OoNhhwcOfv+dBaVKiuxFGck
	GmoxFxUnAgBhyqIMVAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2014 03:48 AM, Arnd Bergmann wrote:
> On Saturday 19 July 2014 02:02:09 Chanwoo Choi wrote:
>> On Sat, Jul 19, 2014 at 1:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Saturday 19 July 2014 01:23:15 Chanwoo Choi wrote:
>>>> If don't add new compatible including specific exynos version,
>>>> I would add new 'adc-needs-sclk' property with existing 'exynos-adc-v2'
>>>> compatible name.
> 
> What I actually meant is using compatible="exynos-adc-v2.1" or similar
> rather than "exynos3250-adc". However, as you already explained, the
> version numbers are apparently just made up, so using "exynos3250-adc"
> is actually better here. If a future exynos7890 uses the same clocks
> as exynos3250, it can simply use the same "exynos3250-adc" string here.

OK, I'll use "exynos3250-adc" compatible string instead of "exynos3250-adc-v2".

> 
>>>> Dear Naveen, Tomasz,
>>>>
>>>> If existing exynos-adc driver add just one property for 'sclk_adc'
>>>> as following, exynos-adc could not include the exynos version
>>>> in compatible name.
>>>>
>>>> I need your opinion about it.
>>>>
>>>>                 adc: adc@126C0000 {
>>>>                         compatible = "samsung,exynos-adc-v2";
>>>>                         reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>>>>                         interrupts = <0 137 0>;
>>>>                         clock-names = "adc", "sclk_adc";
>>>>                         clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
>>>> +                        adc-needs-sclk;
>>>>                         #io-channel-cells = <1>;
>>>>                         io-channel-ranges;
>>>>                 }
>>>
>>> How about just making it an optional clock? That would be much
>>> easier because then you can simply see if the clock itself is
>>> there and use it, or otherwise ignore it.
>>
>> The v1 of this patchset[1] got the clock of 'sclk_adc'  but if the dt node
>> of ADC in dtsi file didn't include 'sclk_adc', print just warning message
>> without stopping probe as following:
>>
>>  [1] https://lkml.org/lkml/2014/4/10/710
>>
>> +       info->sclk = devm_clk_get(&pdev->dev, "sclk_adc");
>> +       if (IS_ERR(info->sclk)) {
>> +               dev_warn(&pdev->dev, "failed getting sclk clock, err = %ld\n",
>> +                                                       PTR_ERR(info->sclk));
>> +               info->sclk = NULL;
>> +       }
>>
>> But, Tomasz Figa suggested the method[2] of this patchset(v6).
>>  [2] https://lkml.org/lkml/2014/4/11/189
> 
> Yes, your current version is certainly better than this, but another way
> to address Tomasz' comment would be to change the binding to list the "sclk"
> as optional for any device and make the code silently ignore missing sclk
> entries, like:
> 
> 
> 	info->sclk = devm_clk_get(&pdev->dev, "sclk");
> 	if (IS_ERR(info->sclk)) {
> 		switch (PTR_ERR(info->sclk)) {
> 		case -EPROBE_DEFER:
> 			/* silently return error so we can retry */
> 			return -EPROBE_DEFER:
> 		case -ENOENT:
> 			/* silently ignore missing optional clk */
> 			info->sclk = NULL;
> 			break;
> 		default:
> 			/* any other error: clk is defined by doesn't work  */
> 			dev_err(&pdev->dev, "failed getting sclk clock, err = %ld\n",
> 				PTR_ERR(info->sclk));
> 			return PTR_ERR(info->sclk));
> 		}
> 	}

I tested this patch suggested by you.
But, devm_clk_get returns always '-ENOENT' on follwong two cases:

Case 1.
ADC dt node in exynos3250.dtsi don't include 'sclk' clock as following:

                adc: adc@126C0000 {
                        compatible = "samsung,exynos3250-adc";
                        reg = <0x126C0000 0x100>, <0x10020718 0x4>;
                        interrupts = <0 137 0>;
                        clock-names = "adc";
                        clocks = <&cmu CLK_TSADC>;
                        #io-channel-cells = <1>;
                        io-channel-ranges;
		};

Case 2.
ADC dt node in exynos3250.dtsi don't include 'sclk' clock
but, exynos3250 clock controller don't support CLK_SCLK_TSADC clock as following:

                adc: adc@126C0000 {
                        compatible = "samsung,exynos3250-adc";
                        reg = <0x126C0000 0x100>, <0x10020718 0x4>;
                        interrupts = <0 137 0>;
                        clock-names = "adc", "sclk";
                        clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
                        #io-channel-cells = <1>;
                        io-channel-ranges;
		};


So, I think exynos-adc needs to use 'needs_sclk' field suggested by Tomasz Figa.

> 
> One more comment about the name: Both in the code you use "sclk" as the
> name, so presumably that is the actual name of the clk as known to this
> driver, and it makes sense to use clock-names="sclk" as well, if you want
> to have any name.

OK, I'll use 'sclk' clock name for special clock of ADC.

Thanks,
Chanwoo Choi
