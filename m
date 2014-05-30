Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaE3AQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 20:16:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60881 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbaE3AQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 20:16:41 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-32-5387cde6c34d
Message-id: <5387CDE6.8030801@samsung.com>
Date: Fri, 30 May 2014 09:16:38 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/4] dt-bindings: extcon: Add support for SM5502 MUIC device
References: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
 <1401269976-12754-5-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1401269976-12754-5-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsWyRsSkSPfZ2fZggxcztS2uf3nOajH/yDlW
	i/43C1ktzr1ayWhxtukNu8XCtiUsFpd3zWGzWHr9IpPF7cYVbBYTpq9lsXh7ZzqLReveI+wO
	PB5r5q1h9Ljc18vksXL5FzaPzSu0PDat6mTz6NuyitHj8ya5APYoLpuU1JzMstQifbsErowH
	M9YxF0wUrHhzagZbA+Ncvi5GTg4JAROJ7bt3sUHYYhIX7q0Hsrk4hASWMkqcX/CHEaZoU/Nx
	dojEIkaJ/8uaoapeM0o83PSNuYuRg4NXQEti1UoHkAYWAVWJT7svgzWzAYX3v7gBtkFUIExi
	5fQrLCA2r4CgxI/J91hA5ogItDJJ9E98BbaBWWAGo0Tb/RNgHcICAUCTdrOD2EICjYwSm3/Y
	g9icAm4Sbdfvg21gFtCR2N86jQ3ClpfYvOYtM8ggCYFODomzPy4wQZwkIPFt8iEWkEslBGQl
	Nh1ghnhNUuLgihssExjFZiE5ahaSsbOQjF3AyLyKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cT
	IzB+T/971ruD8fYB60OMyUArJzJLiSbnA+M/ryTe0NjMyMLUxNTYyNzSjDRhJXHepIdJQUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY2YuXS594xPil39fo3DKGwKAT95eXaxZceD7d9fjZ
	6/Pn/Nv4u3z5VJ3jn9w+OV3kPDePJczGsmBWd0bdKsa3d/9O2/F/w0we/U3VjY5ndBsU71vo
	G4htmL2em1W+8q7H9pI1k6L1018Z2BoXZr+PPX+qnLcmboJ89fNnU07/ag9tf70xaa1TgBJL
	cUaioRZzUXEiAANu0A31AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd1nZ9uDDXoeS1tc//Kc1WL+kXOs
	Fv1vFrJanHu1ktHibNMbdouFbUtYLC7vmsNmsfT6RSaL240r2CwmTF/LYvH2znQWi9a9R9gd
	eDzWzFvD6HG5r5fJY+XyL2wem1doeWxa1cnm0bdlFaPH501yAexRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCXKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJaxgzHsxYx1wwUbDizakZbA2Mc/m6GDk5JARMJDY1H2eHsMUk
	Ltxbz9bFyMUhJLCIUeL/smYo5zWjxMNN35i7GDk4eAW0JFatdABpYBFQlfi0+zIjiM0GFN7/
	4gYbiC0qECaxcvoVFhCbV0BQ4sfkeywgc0QEWpkk+ie+YgdxmAVmMEq03T8B1iEsEAA0aTfY
	GUICjYwSm3/Yg9icAm4Sbdfvg21gFtCR2N86jQ3ClpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHJ4Zn0DsZVDRaHGAU4GJV4eCektwcLsSaWFVfm
	HmKU4GBWEuF1PAwU4k1JrKxKLcqPLyrNSS0+xJgMDIOJzFKiyfnAxJVXEm9obGJmZGlkbmhh
	ZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzev9pT635Zpb5R/6TjuN5gfkyauaov
	5+w/iz6sSLYKDOZ+GjTnc8iJvVVn2XQtvNKdd+5yWhVo3TV3ammj3+ljgfdmyD7dmSxR8MVG
	k2GCkHGD+690Sz67Fc9XzuTax6zxsMBy3X8/91qx8zzPN2to3731xn67+cuIC6051+6fMb/b
	77Q77JISS3FGoqEWc1FxIgBubCypUgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear DT Maintainer,

Could you please review this patch?

Best Regards,
Chanwoo Choi

On 05/28/2014 06:39 PM, Chanwoo Choi wrote:
> This patch add documentation for binding of SM5502 MUIC (Micro-USB Interface
> Controller) device which is using EXTCON subsystem. The SM5502 MUIC device
> can detect various external accessories when external accessories is attached
> or detached.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> 
> ---
>  .../devicetree/bindings/extcon/extcon-sm5502.txt   | 23 ++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt b/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
> new file mode 100644
> index 0000000..4ecda22
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
> @@ -0,0 +1,23 @@
> +
> +* SM5502 MUIC (Micro-USB Interface Controller) device
> +
> +The Silicon Mitus SM5502 is a MUIC (Micro-USB Interface Controller) device
> +which can detect the state of external accessory when external accessory is
> +attached or detached and button is pressed or released. It is interfaced to
> +the host controller using an I2C interface.
> +
> +Required properties:
> +- compatible: Should be "siliconmitus,sm5502-muic"
> +- reg: Specifies the I2C slave address of the MUIC block. It should be 0x25
> +- interrupt-parent: Specifies the phandle of the interrupt controller to which
> +  the interrupts from sm5502 are delivered to.
> +- interrupts: Interrupt specifiers for detection interrupt sources.
> +
> +Example:
> +
> +	sm5502@25 {
> +		compatible = "siliconmitus,sm5502-muic";
> +		interrupt-parent = <&gpx1>;
> +		interrupts = <5 0>;
> +		reg = <0x25>;
> +	};
> 

