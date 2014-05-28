Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaE1SvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:51:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45861 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbaE1SvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:51:07 -0400
Date: Wed, 28 May 2014 19:50:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140528185051.GB22488@sirena.org.uk>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: I'm having an emotional outburst!!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] regulator: axp20x: Update the bindings to use a
 local parent regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 28, 2014 at 07:11:07PM +0200, Maxime Ripard wrote:

>  		axp_vcore_reg: dcdc2 {
> +			vin-supply = <&axp_ipsout_reg>;

>  		axp_ddr_reg: dcdc3 {
> +			vin-supply = <&axp_ipsout_reg>;

>  		axp_rtc_reg: ldo1 {
> +			vin-supply = <&axp_ipsout_reg>;

>  		axp_analog_reg: ldo2 {
> +			vin-supply = <&axp_ipsout_reg>;

>  		axp_pll_reg: ldo3 {
> +			vin-supply = <&axp_ipsout_reg>;

>  		axp_hdmi_reg: ldo4 {
> +			vin-supply = <&axp_ipsout_reg>;

>  		axp_mic_reg: ldo5 {
> +			vin-supply = <&axp_ipsout_reg>;

This is saying that every single regulator on the device is powered by a
(presumably) single input called "vin".  This would certainly be an
unusual package design...  As ever the name of the supply should follow
the name of the pin on the device.

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThjAIAAoJELSic+t+oim90SgP/3Ci9DJGAzupCvPpELYOY5Pi
tporQczFwME3uxq/YHrDNuFQ01Gj1/1/Vw1AiFrKWVDYbIvc1Jh8XZDTQvJiDBOH
wXyuE2KsuL/mqfp8hRew9wjTyrqQRLDv+KG/yrxsnj1Xf7vXBb3UrgVe3TJcfNAz
AGMmJZUoNw8S9h15m5pZSVat0tYppprP8RXz0PvBXOjaPmxcXwpO5Swpm6XObNCz
5GwFhN/47viFFZaYZZjoCwxT5+UqdAmx1BcN+xGAgOB62zpClcDHyFXZ8nyDARum
XsvVCr3Q77cDZmpLXJiTOM9Hqu3cmRNopBwCGu0m7r0WLS9mfR/EYf+2vj05uvYQ
sWn9SIkwhlq11icxnQ6FFuwNwgKWttqXN1Rnl2egGLR2JqeFjkwjLBAExtOY6JFQ
ni65t/EOInGrr4i3y+y0pSAcflHZHPhQkMGXYDAwQl5vSs1Jy1MiGY1hbrX4xtj0
ZbT98EHW3udSv4LpTauwrcuogv3MkRNZ30DS5NLYUn53+iJS8wsUaPjIJFTKkIkD
cyRnblrc+1I2bsQrg0aGlRz0F6Pcc8HXlTl87tXJv2WiLGVM8rXZ9k9xPMQazvJO
E8I57R4A0AfMoZQoPlkF8q74gmc6hXW1ZI3Yhx8RHj8CXlrOLQiy6gv8dgxPKCTh
3Vawei3lEKRYj2IEUhP1
=EKbD
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
