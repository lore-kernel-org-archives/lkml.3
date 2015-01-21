Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbbAUQXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:23:40 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41655 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAUQXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:23:32 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-c0-54bfd1f04334
Message-id: <54BFD279.7080604@samsung.com>
Date: Wed, 21 Jan 2015 17:23:21 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Inha Song <ideal.song@samsung.com>
Cc: alsa-devel@alsa-project.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 3/3] ARM: dts: Add sound nodes for
 exynos4412-trats2
References: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
 <1421660902-29679-4-git-send-email-ideal.song@samsung.com>
In-reply-to: <1421660902-29679-4-git-send-email-ideal.song@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t/xy7ofLu4PMZi1z8jiysVDTBZTHz5h
	s5h/5ByrRf+bhawWB/7sYLTY9fc+o8W5VysZLfofv2a2+Halg8li0+NrrBaXd81hs5hxfh+T
	xe3LvBZLr19kspgwfS2LReeuflaL1r1H2C0urvjCZPFy8xsmB2GPDZ+b2DzWzFvD6NHS3MPm
	cbmvl8lj56y77B4rl39h89i0qpPN4861PWwem5fUe+x7u4zNo2/LKkaPzaerPT5vkgvgjeKy
	SUnNySxLLdK3S+DK6Jz9mLGgma3i1LLTLA2Mz1m6GDk4JARMJD5/4Oli5AQyxSQu3FvP1sXI
	xSEksJRRYtq8n+wQzidGiUn/J7KBVPEKaEm8uDmRFcRmEVCV6Pu7CsxmEzCU6D3axwhiiwpE
	SJy8u4cdol5Q4sfkeywgtoiAmsSMO71MIEOZBQ4ySzxqOQjWICwQJXHo7Emobc2MEmc2XWIH
	OY9TwF3i7Sl7EJNZQE/i/kUtkHJmAXmJzWveMk9gFJiFZMUshKpZSKoWMDKvYhRNLU0uKE5K
	zzXUK07MLS7NS9dLzs/dxAiJ0i87GBcfszrEKMDBqMTDWxG6P0SINbGsuDL3EKMEB7OSCK/f
	QaAQb0piZVVqUX58UWlOavEhRiYOTqkGxqQfn2c1TBCX6Qm0PLUk/HFXQvQNuaePmG/6Nu+4
	dPwq2z9Xkx8pKy+9NSk6/+COZmxYXe7E32Z8uo0TDwUq7Xt+7Pc3s3v/H4vOZLjd6WPtt4n9
	najSIY6tKcLnnZZ++aBUK+Oy9DZ3/N7l3hFPN+2a6rP2le2Mb+FbRJQ+yH6Yu2W6/tyjrzqV
	WIozEg21mIuKEwE5fdKnsAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 19/01/15 10:48, Inha Song wrote:
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts

> +	sound {
> +		compatible = "samsung,trats2-audio";

> +		assigned-clocks = <&pmu_system_controller 0>;
> +		assigned-clock-parents =  <&clock CLK_XUSBXTI>;

How about putting these properties in the pmu_system_controller
node?  After all the mux clock being configured here belongs to
the PMU subsystem. Wouldn't it work that way ?

> +		samsung,i2s-controller = <&i2s0>;
> +		samsung,model = "Trats2";
> +		samsung,audio-codec = <&wm1811>;
> +		samsung,audio-routing =
> +			"SPK", "SPKOUTLN",
> +			"SPK", "SPKOUTLP",
> +			"SPK", "SPKOUTRN",
> +			"SPK", "SPKOUTRP";
> +	};

-- 
Regards,
Sylwester
