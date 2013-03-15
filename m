Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3COBap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:30:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11493 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3COBam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:30:42 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-dd-514279c1404a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Rob Landley'" <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1363302046-31684-1-git-send-email-dianders@chromium.org>
In-reply-to: <1363302046-31684-1-git-send-email-dianders@chromium.org>
Subject: Re: [PATCH] usb: Document clocks in samsung,exynos4210-ehci/ohci
 bindings
Date: Fri, 15 Mar 2013 10:30:40 +0900
Message-id: <005c01ce211c$b45da540$1d18efc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hB9HhP6YeGduySqCGIIBtExhuMAAFFF6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI92DlU6BBqcaBS0Wti1hsbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlvjuxkKpjCXbFtYhNbA+MZji5GDg4JAROJHy0FXYyc
	QKaYxIV769m6GLk4hASWMUo87XrHDpEwkZg95yMLRGIRo8TdV0/YIZxfjBJ/N85nBqliE1CT
	+PLlMDvIVBGBYIl/5/1BapgFmpgl7s3ZzgpSIyTgKvFpy0lGEJtTwE3iwvKnbCC2sECIxO+J
	01hBelkEVCXWrHMFCfMK2Eq8e9/DDGELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmiGfUJR79
	1QUJiwgYSTyd1Q9VIiKx78U7RpBzJAQ2sUvMvn8TbC2LgIDEt8mHWCB6ZSU2HWCG+FdS4uCK
	GywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkAibuIPx
	/gHrQ4zJQOsnMkuJJucDIzSvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYy94fM8/z41eOEduVWKfe71TvFKh0Qx3pvJ+UsrLKTlO5JPhsSffd29
	5drsqeea+mRnq2xd81ZSK+zljYtid09sqXb63qDcMmm9zku5UzKhMT22Fks9vqo7HZZYxWTF
	IjHp7/0nqodlRIIn87Fmzjj1+2jkWzP9myzCOSIxvUcnM080LM6tOqLEUpyRaKjFXFScCAC1
	67HoxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd2DlU6BBif+cFssbFvCYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz3hzZyVQwhbti
	28QmtgbGMxxdjJwcEgImErPnfGSBsMUkLtxbz9bFyMUhJLCIUeLuqyfsEM4vRom/G+czg1Sx
	CahJfPlyGCjBwSEiECzx77w/SA2zQBOzxL0521lBaoQEXCU+bTnJCGJzCrhJXFj+lA3EFhYI
	kfg9cRorSC+LgKrEmnWuIGFeAVuJd+97mCFsQYkfk++BHcQsoCWxfudxJghbXmLzmrfMIK0S
	AuoSj/7qgoRFBIwkns7qhyoRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERzBz6R2MK5ssDjEKMDBqMTDe6DfIVCINbGsuDL3EKMEB7OSCK+n
	l2OgEG9KYmVValF+fFFpTmrxIcZkoD8nMkuJJucDk0teSbyhsYmZkaWRmYWRibk5acJK4rwH
	Wq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAe/t0YoPHkiCtD3bcts87vD757ZZ9uq37pmjssr/6t
	7yte+mXS1JQq84rb9+YtPyZ2UDtb4l1PR09lw1aeNdE35j5kzs95crqiLOX9vJNb+7hOLTl8
	5JX2lwLR+g0Pvbl0jnj6rnzdmLKfPenU402Oy/KrnRkiPI5snBot/TN6U9o/Q8F/lftalViK
	MxINtZiLihMBji9YKSQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 15, 2013 8:01 AM, Doug Anderson wrote:
> 
> The exynox4210-ehci and exynos4210-ohci nodes need a clock specified
> using the common clock framework.  Document it.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  Documentation/devicetree/bindings/usb/exynos-usb.txt | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> index f66fcdd..d557cf7 100644
> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> @@ -10,6 +10,8 @@ Required properties:
>   - reg: physical base address of the controller and length of memory mapped
>     region.
>   - interrupts: interrupt number to the cpu.
> + - clocks: from common clock binding: handle to adc clock.
                                                            ^^^
Is it right? I think that 'adc' can be changed to 'usb host'.


Best regards,
Jingoo Han

> + - clock-names: from common clock binding: Shall be "usbhost".
> 
>  Optional properties:
>   - samsung,vbus-gpio:  if present, specifies the GPIO that
> @@ -22,6 +24,9 @@ Example:
>  		reg = <0x12110000 0x100>;
>  		interrupts = <0 71 0>;
>  		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +
> +		clocks = <&clock 285>;
> +		clock-names = "usbhost";
>  	};


