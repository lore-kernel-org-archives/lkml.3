Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaJ1Ix2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:53:28 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54141 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbaJ1IxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:53:24 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-8a-544f59812685
Message-id: <1414486399.24949.20.camel@AMDC1943>
Subject: Re: [PATCH 7/8] mfd/regulator: dt-bindings: max77686: Document gpio
 property
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 28 Oct 2014 09:53:19 +0100
In-reply-to: <544EA7D4.8070406@collabora.co.uk>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-8-git-send-email-k.kozlowski@samsung.com>
 <544EA7D4.8070406@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xy7qNkf4hBmsOKVtsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdov7X48yWny70sFksenxNVaLy7vmsFnM
	OL+PyeL2ZV6LtUfusluc7mZ1EPBoae5h8/j7/DqLx99VL5g9ds66y+6xaVUnm8eda3vYPOad
	DPTYvKTeo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDKeHVErOMBVsXXXD9YGxsMcXYycHBIC
	JhIvn3YyQdhiEhfurWfrYuTiEBJYyijR1nYfyvnMKPH+6mHmLkYODl4BA4ntu7xBGoQFwiVa
	93xgB7HZBIwlNi9fwgZiiwjYSdxY/ZAZpJdZ4DCLxKIH18ESLAKqEgtu3GUBsTkF9CVev3vD
	CLFgFaPE3hmdzCAJZgF1iUnzFoEtkxBQlmjsdwMJ8woISvyYfI8FokReYvOat8wTGAVmIemY
	haRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFC4uzLDsbFx6wOMQpwMCrx8O6Y
	5hsixJpYVlyZe4hRgoNZSYR3uYp/iBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG5y8Bf1WPlJc0
	Pji11aWgjOGPaKps35EDSx97NjPKq+gZHb6TkpU7Lyj+6vTOm0vXSM/sebM/9qKpXfHmfe4m
	3bWTGBRTz+sb6yu4Hn2bdKc0UJxz3UTtnTd0eCfsZmvQO3J42fvNVS2nPJnfq0k/n3/1RdTf
	jes2L0us23p0quujte++ZVkcU2Ipzkg01GIuKk4EALR3KveRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On pon, 2014-10-27 at 21:15 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> > Document usage of gpio property which turns on external control over
> > regulator.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/max77686.txt | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
> > index 75fdfaf41831..e41dfa7e2b90 100644
> > --- a/Documentation/devicetree/bindings/mfd/max77686.txt
> > +++ b/Documentation/devicetree/bindings/mfd/max77686.txt
> > @@ -39,6 +39,9 @@ to get matched with their hardware counterparts as follow:
> >  	-BUCKn	:	1-4.
> >    Use standard regulator bindings for it ('regulator-off-in-suspend').
> >  
> > +  Optional properties:
> > +  - gpio : GPIO to use for external control. Valid only for LDO20, LDO21,
> > +    LDO22, BUCK8 and BUCK9 regulators.
> 
> When using the descriptor-based GPIO interface the standard is to use as the DT
> property name a prefix documenting the GPIO function + a -gpios or -gpio suffix.
> So this should be something like ec-gpio.

OK.

Best regards,
Krzysztof

> 
> Best regards,
> Javier

