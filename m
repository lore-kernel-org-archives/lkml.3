Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaBAS3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 13:29:48 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:50817 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaBAS3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 13:29:46 -0500
Message-ID: <52ED3D28.7020709@cogentembedded.com>
Date: Sat, 01 Feb 2014 22:30:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, broonie@kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/5] ASoC: tda998x: add DT documentation of the tda998x
 CODEC
References: <cover.1391274627.git.moinejf@free.fr> <8e4231b7a55802f58a14dd07ac5cd8b0babb1dce.1391274628.git.moinejf@free.fr>
In-Reply-To: <8e4231b7a55802f58a14dd07ac5cd8b0babb1dce.1391274628.git.moinejf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-02-2014 20:48, Jean-Francois Moine wrote:

> This patch adds the DT documentation of the NXP TDA998x CODEC.

> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>   Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)

> diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> index d7df01c..aa0d81b 100644
> --- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
[...]
> @@ -24,4 +35,10 @@ Example:
>   		interrupts = <27 2>;		/* falling edge */
>   		pinctrl-0 = <&pmx_camera>;
>   		pinctrl-names = "default";
> +			hdmi_codec: codec {

    This line is indented too far to the right.

> +			compatible = "nxp,tda998x-codec";
> +			audio-ports = <0x03>, <0x04>;
> +			audio-port-names = "i2s", "spdif";
> +			#sound-dai-cells = <1>;
> +		};
>   	};

WBR, Sergei

