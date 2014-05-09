Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaEICUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:20:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8211 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbaEICUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:20:41 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-5f-536c3b784c5f
Message-id: <536C3B5A.2030107@samsung.com>
Date: Fri, 09 May 2014 11:20:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: t.figa@samsung.com, linux@arm.linux.org.uk, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, chanho61.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
References: <1398735462-1938-1-git-send-email-cw00.choi@samsung.com>
 <5369B88E.9030901@samsung.com> <034d01cf6b2c$748bdd50$5da397f0$@samsung.com>
In-reply-to: <034d01cf6b2c$748bdd50$5da397f0$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWyRsSkQLfCOifYYOIHeYvL+7UtPn9oYbeY
	dH8Ci0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddixuSXbBbrZ7xmsdi7czKjA49H
	S3MPm8fmJfUefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXH3WDtzwUXGiltXrrM1MM5l7GLk
	5JAQMJGYfuAQM4QtJnHh3nq2LkYuDiGBpYwSx7c2sMAUvX/ZyQpiCwlMZ5To288OUfSaUeLK
	xJlgk3gFtCTurpjKBmKzCKhKPDn5jh3EZgOK739xAywuKhAmsXL6FRaIekGJH5PvgdkiAmoS
	PYu3MoIMZRbYwCTx+PtLsJOEBXwkHv3ZygyxbTKjxMIbx8GmcgpYScw5/hmsm1lAR2J/6zQ2
	CFteYvOat1D/vGWXmPApFeIiAYlvkw8B1XMAxWUlNh2AKpGUOLjiBssERrFZSG6ahWTqLCRT
	FzAyr2IUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIjM3T/55N3MF4/4D1IcZkoJUTmaVEk/OB
	sZ1XEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzr
	jlq/DGd7n8J8VvW5WeUnZqVsbXGPabnXJwVI3fL/sPL4Fp1f59YwKojs3LzD8KLA4riq4mcV
	Ip7mVWUxHSwGvq8SPKb9KEp9djJJbNrtS4eFdxzSzr75SiT7ak7f0X27p36vPZ10VeWL18/a
	hqdOt3KSuBM9X21UuVx7KmWe+fccn3TH/rdKLMUZiYZazEXFiQBOCLpa4wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd1o65xgg+2HBCwu79e2+Pyhhd1i
	0v0JLBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyeL2ZV6LGZNfslmsn/GaxWLvzsmMDjwe
	Lc09bB6bl9R79G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWF
	uZJCXmJuqq2Si0+ArltmDtBhSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDC
	GsaMu8famQsuMlbcunKdrYFxLmMXIyeHhICJxPuXnawQtpjEhXvr2UBsIYHpjBJ9+9m7GLmA
	7NeMElcmzgRr4BXQkri7YipYEYuAqsSTk+/YQWw2oPj+FzfA4qICYRIrp19hgagXlPgx+R6Y
	LSKgJtGzeCsjyFBmgQ1MEo+/v2QGSQgL+Eg8+rOVGWLbZEaJhTeOg03lFLCSmHP8M1g3s4CO
	xP7WaWwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAiO/WdSOxhXNlgcYhTgYFTi4X0xJTtYiDWxrLgy9xCjBAezkgjvHf2cYCHelMTKqtSi/Pii
	0pzU4kOMycAwmMgsJZqcD0xLeSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAaOloHuaXFyTAenJJzYx5VzKnPuG48m/O8+kyW2bpHHisdP3pPDF3i60GiqeP
	t/+btvZ2surVjbvW/578dHViVYDTlKi5vYmr876vDuU8Yi1U959BuDzn7Ox8Tq2iBpVJT24+
	MPl7j+vHnD21Ex6Xph8t5PFIPr3pZ8rmzGUaJ+U03mzgfPfmbZ8SS3FGoqEWc1FxIgDNX8JT
	QQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 11:14 AM, Kukjin Kim wrote:
> Chanwoo Choi wrote:
>>
>> Dear Kukjin,
>>
>> Could you please pick this patch?
>>
> I've applied.

Thanks for your apply.

Best regards,
Chanwoo Choi

