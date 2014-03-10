Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaCJV5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:57:17 -0400
Received: from mail-ie0-f186.google.com ([209.85.223.186]:33799 "EHLO
	mail-ie0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbaCJV5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:57:15 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2014 17:57:14 EDT
X-Google-Doc-Id: 31f387b2b466a9d2
X-Google-Web-Client: true
Date: Mon, 10 Mar 2014 14:49:15 -0700 (PDT)
From: mr.nuke.me@gmail.com
To: linux-sunxi@googlegroups.com
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org, david.lanzendoerfer@o2s.ch
Message-Id: <ac47de94-92ef-4b53-9983-34dd2f9924ea@googlegroups.com>
In-Reply-To: <20140211193423.4568.34947.stgit@dizzy-6.o2s.ch>
References: <20140211190543.4568.83517.stgit@dizzy-6.o2s.ch>
 <20140211193423.4568.34947.stgit@dizzy-6.o2s.ch>
Subject: Re: [PATCH v5 6/8] ARM: dts: sun4i: Add support for mmc
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1391_21223103.1394488155494"
X-Google-Token: ENvm-JgF3MGkCgmf80Y0
X-Google-IP: 50.97.94.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_1391_21223103.1394488155494
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tuesday, February 11, 2014 1:34:25 PM UTC-6, David Lanzend=C3=B6rfer wro=
te:
> diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> index b139ee6..20b976a 100644
> --- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> +++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> @@ -33,6 +33,14 @@
>  =09=09=09};
>  =09=09
>  =09=09};
> +=09=09mmc0: mmc@01c0f000 {
> +=09=09=09pinctrl-names =3D "default", "default";
> +=09=09=09pinctrl-0 =3D <&mmc0_pins_a>;
> +=09=09=09pinctrl-1 =3D <&mmc0_cd_pin_reference_design>;
> +=09=09=09cd-gpios =3D <&pio 7 1 0>; /* PH1 */
> +=09=09=09status =3D "okay";
> +=09=09};
> +
>  =09=09pinctrl@01c20800 {
>  =09=09
>  =09=09=09led_pins_cubieboard: led_pins@0 {
>  =09=09=09
>  =09=09=09=09allwinner,pins =3D "PH20", "PH21";
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi
> b/arch/arm/boot/dts/sun4i-a10.dtsi
> index 9044c53..d040d37 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -330,6 +330,46 @@
>  =09=09=09#size-cells =3D <0>;
>  =09=09
>  =09=09};
> +=09=09mmc0: mmc@01c0f000 {
> +=09=09=09compatible =3D "allwinner,sun5i-a13-mmc";

Should be "allwinner,sun4i-a10-mmc", or we will hang the MMC driver on A10.

> +=09=09mmc1: mmc@01c10000 {
> +=09=09=09compatible =3D "allwinner,sun5i-a13-mmc";
ditto

> +=09=09mmc2: mmc@01c11000 {
> +=09=09=09compatible =3D "allwinner,sun5i-a13-mmc";
ditto

> +=09=09mmc3: mmc@01c12000 {
> +=09=09=09compatible =3D "allwinner,sun5i-a13-mmc";
ditto
------=_Part_1391_21223103.1394488155494--
