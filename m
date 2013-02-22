Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3BVHMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:12:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33967 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3BVHMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:12:42 -0500
X-AuditID: cbfee68e-b7fc26d000001938-92-51271a649347
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20130222065345.GA30816@core.coreip.homeip.net>
In-reply-to: <20130222065345.GA30816@core.coreip.homeip.net>
Subject: Re: Dangerous devm_request_irq() conversions
Date: Fri, 22 Feb 2013 16:12:36 +0900
Message-id: <000c01ce10cb$fdd4a4a0$f97dede0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QyV580+J5DwnZQva7yRgLCk8/7wAAEuBg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zfd0UKfVAg57zqhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSujdaFnwWL+iqNn9rM1MH7l6WLk5JAQMJE4tu8YI4QtJnHh3nq2
	LkYuDiGBZYwSL5+dY4Ip2tiyix0iMZ1R4uLhT1DObCaJncteg1WxCahJfPlyGCjBwSEiYCgx
	Y00VSA2zwHJGidXP3zGD1AgJWEt8nD4ZbB2ngI3E09/XWEBsYQFTidbl79lBbBYBVYlHy3+x
	gdi8ArYSk28vZ4SwBSV+TL4HVs8soCWxfudxJghbXmLzmrfMIHslBNQlHv3VBQmLCBhJ/FsP
	8RmzgIjEvhfvGEHukRBYxS7RM+EoC8QuAYlvkw+xQPTKSmw6wAzxsKTEwRU3WCYwSsxCsnkW
	ks2zkGyehWTFAkaWVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxghkdW3g/HmAetDjMlA6ycy
	S4km5wMjM68k3tDY2MTMxNTE3NLU3JQ0YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGNV7D+0w2RuX3/I/ae2XpPCmHK5H0qXiywXa8g+uUIjgLM2ck7ObxbJEacIvtduzl/h/
	ioo9tb0hs+q+ftmKYH85lYItV7+em33B+XfdnJvs0yqiow2/TuRbymp8aMv1Lu+WdPOTE7xl
	uMTmJx3tD2XbYyqY1XOix2uj3NkFr1UsFs0Nmuzoo8RSnJFoqMVcVJwIAM2NypfCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoG6KlHqgwdZ2eYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0brQs2Axf8XRM/vZGhi/
	8nQxcnJICJhIbGzZxQ5hi0lcuLeerYuRi0NIYDqjxMXDn9ghnNlMEjuXvWYCqWITUJP48uUw
	UIKDQ0TAUGLGmiqQGmaB5YwSq5+/YwapERKwlvg4fTIjiM0pYCPx9Pc1FhBbWMBUonX5e7Bt
	LAKqEo+W/2IDsXkFbCUm317OCGELSvyYfA+snllAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsL
	EhYRMJL4t/4YI0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjOC4fSa9g3FVg8UhRgEORiUe3g5vtUAh1sSy4srcQ4wSHMxKIrz6oUAh3pTE
	yqrUovz4otKc1OJDjMlAj05klhJNzgemlLySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhP
	LEnNTk0tSC2C2cLEwSnVwOjGNumpWJ6SiILGzcQHO15OVfnDpzbtWbdh3stvoSfOnH7/Lb78
	cN/BpOUcLpl/evZsi3ly47W4UJ5JaofSV5cl7x91u7czHN7HfTK/9HHN7Q7TlI7px3MYXa5t
	PnFaRbgmR4Brr0rF0ptGy1kti9m3SxiZdeuI7D/CuEf0auTKOW4brHeuqVBiKc5INNRiLipO
	BAB7jFUbHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 3:54 PM, Dmitry Torokhov wrote:
> 
> Hi,
> 
> It looks like a whole slew of devm_request_irq() conversions just got
> applied to mainline and many of them are quite broken.
> 
> Consider fd5231ce336e038037b4f0190a6838bdd6e17c6d or
> c1879fe80c61f3be6f2ddb82509c2e7f92a484fe: the drivers udsed first to
> free IRQ and then unregister the corresponding device ensuring that IRQ
> handler, while it runs, has the device available. The mechanic
> conversion to devm_request_irq() reverses the order of these operations
> opening the race window where IRQ can reference device (or other
> resource) that is already gone.
> 
> It would be nice if these could be reverted and revioewed again for
> correctness.

Um, other RTC drivers already have been using devm_request_threaded_irq() or
devm_request_irq() like this, before I added these patches.

For example, 
./drivers/rtc/rtc-tegra.c
./drivers/rtc/rtc-spear.c
./drivers/rtc/rtc-s3c.c
./drivers/rtc/rtc-mxc.c
./drivers/rtc/rtc-ds1553.c
./drivers/rtc/rtc-ds1511.c
./drivers/rtc/rtc-snvs.c
./drivers/rtc/rtc-imxdi.c
./drivers/rtc/rtc-tx4939.c
./drivers/rtc/rtc-mv.c
./drivers/rtc/rtc-coh901331.c
./drivers/rtc/rtc-stk17ta8.c
./drivers/rtc/rtc-lpc32xx.c
./drivers/rtc/rtc-tps65910.c
./drivers/rtc/rtc-rc5t583.c


Also, even more, some RTC drivers calls rtc_device_unregister() first,
then calls free_irq() later.

For example,
./drivers/rtc/rtc-vr41xx.c
./drivers/rtc/rtc-da9052.c
./drivers/rtc/rtc-isl1208.c
./drivers/rtc/rtc-88pm860x.c
./drivers/rtc/rtc-tps6586x.c
./drivers/rtc/rtc-mpc5121.c
./drivers/rtc/rtc-m48t59.c


Please, don't argue revert without concrete reasons.

If these devm_request_threaded_irq() or devm_request_irq() make the problem,
devm_free_irq() will be added later.


> 
> In general any conversion to devm_request_irq() needs double and triple
> checking.
> 
> Thanks.
> 
> --
> Dmitry

