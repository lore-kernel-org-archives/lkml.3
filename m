Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbaCTKS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:18:59 -0400
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:40132 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755228AbaCTKS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:18:58 -0400
X-Greylist: delayed 1806 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 06:18:57 EDT
MIME-Version: 1.0
In-Reply-To: <1395173924-3648-10-git-send-email-b.brezillon.dev@gmail.com>
References: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
	<1395173924-3648-10-git-send-email-b.brezillon.dev@gmail.com>
Date: Thu, 20 Mar 2014 10:24:35 +0100
Message-ID: <CACh+v5OF52ZuDBpkqpev1Jxv0DJ1ckRR+DjcX500i3o0o4HE9A@mail.gmail.com>
Subject: Re: [PATCH 09/11] ARM: at91/dt: define main xtal frequency of the
 at91sam9261ek board
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Boris BREZILLON <brezillonboris@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 12958263503268436109
X-Ovh-Remote: 209.85.160.47 (mail-pb0-f47.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-18 21:18 GMT+01:00 Boris BREZILLON <brezillonboris@gmail.com>:
>
> Define at91sam9261ek main crystal frequency.
>
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
>  arch/arm/boot/dts/at91sam9261ek.dts |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
> index 2ce527e..7175986 100644
> --- a/arch/arm/boot/dts/at91sam9261ek.dts
> +++ b/arch/arm/boot/dts/at91sam9261ek.dts
> @@ -29,6 +29,10 @@
>                         compatible = "atmel,osc", "fixed-clock";
>                         clock-frequency = <18432000>;
>                 };
> +
> +               main_xtal: main_xtal {
> +                       clock-frequency = <18432000>;
> +               };
>         };
>
>         ahb {
> --
> 1.7.9.5
>
You forgot to remove the old fixed-clock definition for the main_clock: clock@0

Otherwise:
Acked-by: Jean-Jacques HIBLOT <jjhiblot@traphandler.com>
