Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaFRPIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:08:35 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:54738 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaFRPIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:08:32 -0400
MIME-Version: 1.0
In-Reply-To: <1403103172-19856-7-git-send-email-lee.jones@linaro.org>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
	<1403103172-19856-7-git-send-email-lee.jones@linaro.org>
Date: Wed, 18 Jun 2014 17:08:31 +0200
Message-ID: <CAG374jBJpmgv+X_ZT-Q6kj89p8BvVLb3sUsBHmD7GHF=jLQ=Ew@mail.gmail.com>
Subject: Re: [PATCH 7/7] pwm: st: Supply Device Tree binding documentation for
 ST's PWM IP
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pwm@vger.kernel.org, "kernel@stlinux.com" <kernel@stlinux.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, ajitpal.singh@st.com,
        thierry.reding@gmail.com, Maxime Coquelin <maxime.coquelin@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,
minor remark below..

On 18 June 2014 16:52, Lee Jones <lee.jones@linaro.org> wrote:
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/pwm/pwm-st.txt | 41 ++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-st.txt
>
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-st.txt b/Documentation/devicetree/bindings/pwm/pwm-st.txt
> new file mode 100644
> index 0000000..ea88c5c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-st.txt
> @@ -0,0 +1,41 @@
> +STMicroelectronics PWM driver bindings
> +--------------------------------------

> +Example:
> +
> +pwm1: pwm@fe510000 {
> +       compatible = "st,pwm";
> +       reg = <0xfe510000 0x68>;
> +       #pwm-cells = <2>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pinctrl_pwm1_chan0_default
> +                    &pinctrl_pwm1_chan1_default
> +                    &pinctrl_pwm1_chan2_default
> +                    &pinctrl_pwm1_chan3_default>;
> +       clocks = <&CLK_SYSIN>;
clock name in lower case

> +       clock-names = "pwm";
> +       st,pwm-num-chan = <4>;
> +};
> --
> 1.8.3.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
