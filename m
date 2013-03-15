Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3COBhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:37:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60382 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3COBhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:37:31 -0400
X-AuditID: cbfee68e-b7f946d000001e37-95-51427b57ce04
From: Jingoo Han <jg1.han@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Padmavathi Venna'" <padma.v@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1363195099-15919-1-git-send-email-dianders@chromium.org>
In-reply-to: <1363195099-15919-1-git-send-email-dianders@chromium.org>
Subject: Re: [PATCH] ARM: dts: add usb 2.0 clock references to exynos5250
 device tree
Date: Fri, 15 Mar 2013 10:37:27 +0900
Message-id: <006301ce211d$a6caa670$f45ff350$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gDszsyoBKoRePSbSKgvW6j2LydwBDm3jw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zI93waqdAg3kzbSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGmWOPWQsaOStWXe1nbGD8z9bFyMkhIWAicevTHmYIW0ziwr31
	QHEuDiGBZYwSu14/hiuavv8nC0RiEaPE5J3rmSGc2UwSk1c1soBUsQmoSXz5cpgdxBYRKJPo
	mDGdCaSIWeAaUFHHEbAdQgKuEssWrmIFsTkF3CSm/zoH1iwsEC5xYeo1MJtFQFXi9KdWMJtX
	wFZi8efZTBC2oMSPyffA4swCWhLrdx5ngrDlJTaveQs0nwPoVHWJR391IW4wkuj/c4kRokRE
	Yt+Ld4wg90gILGKXODt3GRvELgGJb5MPsUD0ykpsOgANCkmJgytusExglJiFZPMsJJtnIdk8
	C8mKBYwsqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCoqtvB+PNA9aHGJOB1k9klhJNzgdG
	Z15JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGGd1
	K8ZKRWw2L1pY6Jly58HxcDPhqOyLfQGiOpwdM8/aH1P7dFatg5X3U5tZwGuRZYc2l8YLKRXc
	sP5aGf5XS6rQ6v+0ziu5XZOT1zdX7Lj3d2HlvyXXTt79abFYVDKjYQLvj1fru4vfzi93i+O8
	G+qR9uJzLGf12axle+c0vb24xZx1A19gnBJLcUaioRZzUXEiAFV3gHzEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgG54tVOgwZF+M4vLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcebYY9aCRs6KVVf7GRsY
	/7N1MXJySAiYSEzf/5MFwhaTuHBvPVCci0NIYBGjxOSd65khnNlMEpNXNYJVsQmoSXz5cpgd
	xBYRKJPomDGdCaSIWeAaUFHHEWaQhJCAq8SyhatYQWxOATeJ6b/OgTULC4RLXJh6DcxmEVCV
	OP2pFczmFbCVWPx5NhOELSjxY/I9sDizgJbE+p3HmSBseYnNa94CzecAOlVd4tFfXYgbjCT6
	/1xihCgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJERy7z6R3MK5qsDjEKMDBqMTD6/DQMVCINbGsuDL3EKMEB7OSCO+uv0Ah3pTEyqrUovz4
	otKc1OJDjMlAj05klhJNzgemlbySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YW
	pBbBbGHi4JRqYBQNbUwK36N/geGB+Llt09t4Vh08Psn17BG/uufWa57JxDUXXz6k/cA8Tl9G
	LaXx4eZoo30rb94V1WQWCtdLaK/uCey8WLrqie3VA9cnTKx+dfvU0kcZ7Ks4T9hwC715yrLu
	6QOn8hlLeLeqfI259XiuUtXnX0cnpnlvvu+SHKHQcpKvgM9IqkWJpTgj0VCLuag4EQDozC+X
	IQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday, March 14, 2013 2:18 AM, Doug Anderson wrote:
> 
> This is a fixup to two device tree nodes that have already landed but
> without clock nodes since the transition to common clock happened at
> the same time.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

The clock number and name are right.

Reviewed-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> ---
>  arch/arm/boot/dts/exynos5250.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 24c52e6..59be603 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -402,12 +402,18 @@
>  		compatible = "samsung,exynos4210-ehci";
>  		reg = <0x12110000 0x100>;
>  		interrupts = <0 71 0>;
> +
> +		clocks = <&clock 285>;
> +		clock-names = "usbhost";
>  	};
> 
>  	usb@12120000 {
>  		compatible = "samsung,exynos4210-ohci";
>  		reg = <0x12120000 0x100>;
>  		interrupts = <0 71 0>;
> +
> +		clocks = <&clock 285>;
> +		clock-names = "usbhost";
>  	};
> 
>  	amba {
> --
> 1.8.1.3

