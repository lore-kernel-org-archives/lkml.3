Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaFRPQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:16:30 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:43322 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaFRPQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:16:28 -0400
Date: Wed, 18 Jun 2014 16:16:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pwm@vger.kernel.org, "kernel@stlinux.com" <kernel@stlinux.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, ajitpal.singh@st.com,
        thierry.reding@gmail.com, Maxime Coquelin <maxime.coquelin@st.com>
Subject: Re: [PATCH 7/7] pwm: st: Supply Device Tree binding documentation
 for ST's PWM IP
Message-ID: <20140618151621.GB15956@lee--X1>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-7-git-send-email-lee.jones@linaro.org>
 <CAG374jBJpmgv+X_ZT-Q6kj89p8BvVLb3sUsBHmD7GHF=jLQ=Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG374jBJpmgv+X_ZT-Q6kj89p8BvVLb3sUsBHmD7GHF=jLQ=Ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Gabriel Fernandez wrote:

> Hi Lee,
> minor remark below..
> 
> On 18 June 2014 16:52, Lee Jones <lee.jones@linaro.org> wrote:
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/pwm/pwm-st.txt | 41 ++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-st.txt
> >
> > diff --git a/Documentation/devicetree/bindings/pwm/pwm-st.txt b/Documentation/devicetree/bindings/pwm/pwm-st.txt
> > new file mode 100644
> > index 0000000..ea88c5c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/pwm-st.txt
> > @@ -0,0 +1,41 @@
> > +STMicroelectronics PWM driver bindings
> > +--------------------------------------
> 
> > +Example:
> > +
> > +pwm1: pwm@fe510000 {
> > +       compatible = "st,pwm";
> > +       reg = <0xfe510000 0x68>;
> > +       #pwm-cells = <2>;
> > +       pinctrl-names = "default";
> > +       pinctrl-0 = <&pinctrl_pwm1_chan0_default
> > +                    &pinctrl_pwm1_chan1_default
> > +                    &pinctrl_pwm1_chan2_default
> > +                    &pinctrl_pwm1_chan3_default>;
> > +       clocks = <&CLK_SYSIN>;
> clock name in lower case

Good catch.  Will fix.

> > +       clock-names = "pwm";
> > +       st,pwm-num-chan = <4>;
> > +};
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
