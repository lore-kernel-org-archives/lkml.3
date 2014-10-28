Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaJ1K5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:57:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65366 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaJ1K5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:57:42 -0400
X-AuditID: cbfee68f-f791c6d000004834-11-544f76a46a34
From: Kukjin Kim <kgene@kernel.org>
To: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
References: <1414421995-22618-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1414421995-22618-1-git-send-email-k.kozlowski@samsung.com>
Subject: RE: [PATCH v2] ARM: dts: exynos4412-trats: Add micro SD card SDHCI node
Date: Tue, 28 Oct 2014 19:57:40 +0900
Message-id: <047101cff29d$fdedc880$f9c95980$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKQ9hn2h6YkSEKt/9WAWGSJgVoWgJrDT2kg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zQ90lZf4hBp9eCVtsnLGe1WLSugNM
	FvOPnGO1eP3C0OJs0xt2i02Pr7FaXN41h81ixvl9TBa3L/NarD1yl92By6OluYfN4++qF8we
	m5fUe/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGu4UX2QqucFb8ufCFpYHxDHsXIweHhICJ
	xPEp+l2MnECmmMSFe+vZuhi5OIQEljFKnDzzlAUiYSLx/tccZojEdEaJ3onzWSCcv4wSS841
	M4JMYhNQlmhsApskLKAlsXBLE1iNiEAHk0TLnr1gDrPALEaJzs6z7CBVQgLuEudWn2AFsTkF
	PCRm7DzIBjJIWCBAYmObFkiYRUBVYt+FWWDlvAIWEk/P/WeDsAUlfky+B3YdM9Cy9TuPM0HY
	8hKb17xlhrhaQWLH2deMILaIgJHEhen32CFqRCT2vXjHCHKPhEAvh8TcY/+YIJYJSHybfIgF
	EiyyEpsOQM2RlDi44gbLBEbJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yFivODG3uDQv
	XS85P3cTIyTe+3cw3j1gfYhRgINRiYfX4KFfiBBrYllxZe4hRlOgiyYyS4km5wOTSl5JvKGx
	mZGFqYmpsZG5pZmSOO9CqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhinqDYKLct70/D4
	YPPXVI9lp4rjmVZ8ueLNcXH3fUXrWy/vVtxhMDIMd18WwxSyYUH555Iz8Rb3g5vL175s5587
	O9tjPv//yW5ijT9rQ5h8LUyYtPQTb7Uunc1WtnLZlc/FjuymAk6ntjSsWuRQMa28We/3mUfT
	LuhfF3mQz3QmmTFAuIn51RQlluKMREMt5qLiRABYrSjF8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd0lZf4hBps281tsnLGe1WLSugNM
	FvOPnGO1eP3C0OJs0xt2i02Pr7FaXN41h81ixvl9TBa3L/NarD1yl92By6OluYfN4++qF8we
	m5fUe/RtWcXo8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjHcL
	L7IVXOGs+HPhC0sD4xn2LkZODgkBE4n3v+YwQ9hiEhfurWfrYuTiEBKYzijRO3E+C4Tzl1Fi
	yblmxi5GDg42AWWJxiZ9kAZhAS2JhVuawGpEBDqYJFr27AVzmAVmMUp0dp4FWyEk4C5xbvUJ
	VhCbU8BDYsbOg2wgg4QFAiQ2tmmBhFkEVCX2XZgFVs4rYCHx9Nx/NghbUOLH5HssIDYz0LL1
	O48zQdjyEpvXvIW6WkFix9nXjCC2iICRxIXp99ghakQk9r14xziBUXgWklGzkIyahWTULCQt
	CxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Nn0jsYVzVYHGIU4GBU4uE1fOgXIsSa
	WFZcmXuIUYKDWUmENyLGP0SINyWxsiq1KD++qDQntfgQoynQpxOZpUST84GpLq8k3tDYxMzI
	0sjMwsjE3FxJnPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUA2P5wqRUvqeXZPRMb5ZfXV0x9dg8
	rr3XPptPcXG7m8U/I4J7TkuN2WfZSLWfSjOFPp2JfXkqs7y1uy4m9dSSdJV3rE936IbFl8Zu
	Wtnn6dXC+XtTiJD0u/MOOovbOY4H338U9C2F0+V+QFQOz99lrudza2+WqUdu+rVYPuIC77fj
	E4u5vsbUKCuxFGckGmoxFxUnAgBzIwbcPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Kozlowski wrote:
> 
Hi,

> Add SDHCI node for supporting the micro SD card. On Trats2 board the
> SDHCI does not use sd2_cd pins (gpk2-2) for card detect but gpx3-4
> instead.
> 
> Power is supplied from LDO21 regulator which in off state is controlled
> by external GPIO pin.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Changes since v1:
> 1. Drop FIXME comment (about findings during testing).
> ---
>  arch/arm/boot/dts/exynos4412-trats2.dts | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index a5aa52bba72c..7a68e0832cd6 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> @@ -603,6 +603,16 @@
>  		cap-mmc-highspeed;
>  	};
> 
> +	sdhci@12530000 {
> +		bus-width = <4>;
> +		cd-gpios = <&gpx3 4 0>;
> +		cd-inverted;
> +		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
> +		pinctrl-names = "default";
> +		vmmc-supply = <&ldo21_reg>;
> +		status = "okay";
> +	};
> +
>  	serial@13800000 {
>  		status = "okay";
>  	};
> --
> 1.9.1

Looks good to me, will apply.

Thanks,
Kukjin

