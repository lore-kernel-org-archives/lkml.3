Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaBGMkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:40:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43663 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaBGMkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:40:37 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-01-52f4d4423d59
Message-id: <1391776833.16500.1.camel@AMDC1943>
Subject: Re: [PATCH v3 1/2] regulator: s5m8767: Use GPIO for controlling
 Buck9/eMMC
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 07 Feb 2014 13:40:33 +0100
In-reply-to: <20140127202524.GQ11841@sirena.org.uk>
References: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
 <1390570678-30686-2-git-send-email-k.kozlowski@samsung.com>
 <20140127202524.GQ11841@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xK7pOV74EGXQvMrfYOGM9q8XUh0/Y
	LOYfOcdqcbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y25x8k8vo8XpblaLiyu+MDnw
	eOycdZfdY9OqTjaPO9f2sHnMOxno0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBm7H95iKljM
	XPF6Wg9jA+MJpi5GTg4JAROJR48fMULYYhIX7q1n62Lk4hASWMooMX3rC1YI5zOjxPrT7UBV
	HBy8AvoSt37xgTQIC4RKLGs7zwxiswkYS2xevoQNxBYRUJa4+n0vC0gvs8AmZokZZ0+xgyRY
	BFQljl3ZA2ZzAjXc6JvBCLFgHaPEr3VNYCcxC6hLTJq3iBniJCWJ3e2d7BBxeYnNa96CxXkF
	BCV+TL7HMoFRYBaSlllIymYhKVvAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyRCvuxg
	XHzM6hCjAAejEg/viaWfg4RYE8uKK3MPMUpwMCuJ8J6+8CVIiDclsbIqtSg/vqg0J7X4ECMT
	B6dUA+M6Xa9+5cT/i9k0bt070bFw5tTmtjpPFqcDX2+wL5R5xOByOTzm5D/FIIPgNQ80HgTO
	jZP0XtQReOfJ7Aj1vVf3+3BIZ5oK6MyQ0LPU16las4Dn9ox/3W7OT95lRi1O8LwgJdtksaPd
	3v/lxqV8ZV7hmnemR+Q1dbzZt2n5plXrhPpWlz+faafEUpyRaKjFXFScCABWwrDibgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, 2014-01-27 at 20:25 +0000, Mark Brown wrote:
> On Fri, Jan 24, 2014 at 02:37:57PM +0100, Krzysztof Kozlowski wrote:
> > Add support for GPIO control (enable/disable) over Buck9. The Buck9
> > Converter is used as a supply for eMMC Host Controller.
> 
> Applied, thanks.

I can't find these patches in your tree. Did you applied them or am I
missing something?

Best regards,
Krzysztof

