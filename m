Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaILKBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:01:55 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47388 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbaILKBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:01:54 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jianqun <jay.xu@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH 1/2] ASoC: rockchip-max98090: add documentation for rockchip-max98090 driver
Date: Fri, 12 Sep 2014 12:04 +0200
Message-ID: <3774516.jOvxH1lgyQ@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1410513055-17775-1-git-send-email-jay.xu@rock-chips.com>
References: <1410507036-15442-1-git-send-email-jay.xu@rock-chips.com> <1410513055-17775-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianqun,

Am Freitag, 12. September 2014, 17:10:55 schrieb Jianqun:
> Add documentation for rockchip-max98090 driver, which is need by rockchip
> board using a max98090.
> 
> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
> ---
> changes since v1:

please make sure to also include the version in the patch subject, so that
people can always see which is which. This one should've been

[PATCH v2 1/2] ASoC: rockchip-max98090: add documentation for rockchip-max98090 driver

Because without this identification, people can only try to guess which one is the
newest version.


Heiko

> - modify error text from "Tegra" to "rockchip"
> 
>  .../sound/rockchip,rockchip-audio-max98090.txt     | 23
> ++++++++++++++++++++++ 1 file changed, 23 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.tx
> t
> 
> diff --git
> a/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.
> txt
> b/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.
> txt new file mode 100644
> index 0000000..e12d1a0
> --- /dev/null
> +++
> b/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.
> txt @@ -0,0 +1,23 @@
> +ROCKCHIP audio complex, with MAX98090 CODEC
> +
> +Required properties:
> +- compatible : must be "rockchip,rockchip-audio-max98090"
> +- rockchip,model : the user-visible name of this sound complex
> +- rockchip,i2s-controller : The phandle of the rockchip I2S controller
> +  that's connected to the CODEC.
> +- rockchip,audio-codec : The phandle of the MAX98090 audio codec.
> +
> +Optional properties:
> +- rockchip,hp-det-gpios : The GPIO that detect headphones are plugged in
> +- rockchip,mic-det-gpios : The GPIO that detect micphones are plugged in
> +
> +Example:
> +
> +sound {
> +	compatible = "rockchip,rockchip-audio-max98090";
> +	rockchip,model = "ROCKCHIP-I2S";
> +	rockchip,i2s-controller = <&i2s>;
> +	rockchip,audio-codec = <&max98090>;
> +	rockchip,hp-det-gpios = <&gpio6 5 GPIO_ACTIVE_HIGH>;
> +	rockchip,mic-det-gpios = <&gpio6 11 GPIO_ACTIVE_HIGH>;
> +};

