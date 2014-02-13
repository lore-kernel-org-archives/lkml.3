Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaBMOzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:55:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16379 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaBMOzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:55:13 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ab-52fcdcced4d6
Message-id: <52FCDCCB.70908@samsung.com>
Date: Thu, 13 Feb 2014 15:55:07 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 10/14] Documentation: mfd: s2mps11: Document support for
 S2MPS14
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-11-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1392282847-25444-11-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Vd1zd/4EGTydY2WxccZ6VoupD5+w
	Wcw/co7Vov/NQlaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y26x
	9PpFJosJ09eyWLTuPcJucbqb1eLiii9MDoIea+atYfS43NfL5LFz1l12j5XLv7B5bFrVyeZx
	59oeNo95JwM9+rasYvT4vEkugDOKyyYlNSezLLVI3y6BK+Pn1TdMBU1CFZOmNTE1MG7n62Lk
	5JAQMJFY/WcOK4QtJnHh3nq2LkYuDiGBpYwSt5bPY4dwPjNKvL29ggWkildAQ2Jq3xFmEJtF
	QFXifts/JhCbTUBN4nPDIzYQW1QgQuLvvPWMEPWCEj8m32MBGSQi8IRR4tuqO8wgDrPAdmaJ
	P5fmsoNUCQtESmxatIUJYl0bo8TsB//AjuIU8JRYMuMX2GpmAWuJlZO2MULY8hKb17xlnsAo
	MAvJlllIymYhKVvAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyTmvu5gXHrM6hCjAAej
	Eg/vg8W/g4RYE8uKK3MPMUpwMCuJ8IYf+RMkxJuSWFmVWpQfX1Sak1p8iJGJg1OqgXGKxKwT
	ITun3upvfPz3jPWCOQniri/lk30zDpU4f/hy9rnRlVirxxzO68uPnroyqartP49P/AVPztaV
	9y5smrTxtGXnxqfxMw4JX0pYpPFO58BWg6/OFrVb9l3gSmvftPxvQclfBlMpBYdpygwRSnV3
	1s1hcTVIFH2Y8u7Jtq8Trgmk5kueuqaoxFKckWioxVxUnAgAAv1lopcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13.02.2014 10:14, Krzysztof Kozlowski wrote:
> Add bindings documentation for S2MPS14 device to the s2mps11 driver.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> ---
>   Documentation/devicetree/bindings/mfd/s2mps11.txt |   12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> index 15ee89c3cc7b..f69bec294f02 100644
> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -1,5 +1,5 @@
>
> -* Samsung S2MPS11 Voltage and Current Regulator
> +* Samsung S2MPS11 and S2MPS14 Voltage and Current Regulator
>
>   The Samsung S2MPS11 is a multi-function device which includes voltage and
>   current regulators, RTC, charger controller and other sub-blocks. It is
> @@ -7,7 +7,7 @@ interfaced to the host controller using an I2C interface. Each sub-block is
>   addressed by the host system using different I2C slave addresses.
>
>   Required properties:
> -- compatible: Should be "samsung,s2mps11-pmic".
> +- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic".
>   - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
>
>   Optional properties:
> @@ -59,10 +59,14 @@ supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
>   as per the datasheet of s2mps11.
>
>   	- LDOn
> -		  - valid values for n are 1 to 38
> +		  - valid values for n are:
> +			- S2MPS11: 1 to 38
> +			- S2MPS14: 1 to 25
>   		  - Example: LDO1, LD02, LDO28
>   	- BUCKn
> -		  - valid values for n are 1 to 10.
> +		  - valid values for n are:
> +			- S2MPS11: 1 to 10
> +			- S2MPS14: 1 to 5
>   		  - Example: BUCK1, BUCK2, BUCK9
>
>   Example:
>

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
