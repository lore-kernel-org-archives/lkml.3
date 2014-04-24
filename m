Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbaDXRGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:06:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57913 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbaDXRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:06:39 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-51-5359449d0d08
Message-id: <53594496.4010607@samsung.com>
Date: Thu, 24 Apr 2014 19:06:30 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Ben Dooks'" <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        j.anaszewski@samsung.com,
        =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>
Subject: Re: [PATCH] arm: dts: exynos4412-trats2: rename alias for i2c_ak8975
 label
References: <534D4143.3050801@samsung.com>
In-reply-to: <534D4143.3050801@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e/4Vd25LpHBBkt28lpsnLGe1WLSugNM
	FvOPnGO16H+zkNXi3KuVjBa9V58DiQVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxdLr
	F5ksJkxfy2LRuvcIu8W89pesDgIea+atYfRoae5h87jc18vk8XfVC2aPlcu/sHlsWtXJ5rF5
	Sb1H35ZVjB6fN8kFcEZx2aSk5mSWpRbp2yVwZay/+Jq9YAVnRe/vtywNjJfYuxg5OSQETCTW
	dz1kg7DFJC7cWw9kc3EICSxllHg+5QSU85lR4si6TaxdjBwcvAJaEruPRYE0sAioSryavIEZ
	xGYTUJP43PAIbBA/UMmapussILaoQITEvcbDrCA2r4CgxI/J98DiIgJpEnMP3wSzmQX2sUjs
	mwZ2kLBAqMTS/Z/BZgoBzfm3sgXM5hTQlpi2dhUTRL2ZxKOWdcwQtrzE5jVvmScwCs5CsmIW
	krJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJva87GJceszrEKMDBqMTDu8Io
	MliINbGsuDL3EKMEB7OSCO86W6AQb0piZVVqUX58UWlOavEhRiYOTqkGxpVfOasXJ7vt1Snx
	WeAuti1xwTPnBReqlrq0hhW2cSXrfdiwmYtXSPjqu1mPzkpbaD84rHd1/eX9k3UjT61bf2RC
	tvaNcxpr2ebpBcU2/w7Xmee6aL7Ufg1WjjLlpL/Md2PWmUzfKGZXOzPVbmZQW23Z8r/7VLtv
	XJwpHtK+4JZp3Y62X+v/vVViKc5INNRiLipOBAAHyGPcmwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 15.04.2014 16:25, Tomasz Stanislawski wrote:
> The i2c_ak8975 controler uses label i2c8.
> This alias is already used for I2C controller 8 defined
> in file arch/arm/boot/dts/exynos4.dtsi.
>
> This patch renames a label for i2c_ak8975 to i2c9.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>   arch/arm/boot/dts/exynos4412-trats2.dts |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index c16b315..5add765 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> @@ -20,7 +20,7 @@
>   	compatible = "samsung,trats2", "samsung,exynos4412", "samsung,exynos4";
>
>   	aliases {
> -		i2c8 = &i2c_ak8975;
> +		i2c9 = &i2c_ak8975;
>   	};
>
>   	memory {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Seems reasonable.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
