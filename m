Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3KYLRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:17:55 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61979 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3KYLRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:17:51 -0500
Date: Mon, 25 Nov 2013 12:17:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Subject: Re: [PATCH 1/5] Documentation: dt: Add kona-pwm binding
Message-ID: <20131125111709.GJ22043@ulmo.nvidia.com>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
 <1384800901-21711-2-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I/5syFLg1Ed7r+1G"
Content-Disposition: inline
In-Reply-To: <1384800901-21711-2-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I/5syFLg1Ed7r+1G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2013 at 10:54:57AM -0800, Tim Kryger wrote:
> Add the binding description for the kona-pwm block found on Broadcom's
> mobile SoCs.
>=20
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  .../devicetree/bindings/pwm/bcm-kona-pwm.txt       | 24 ++++++++++++++++=
++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt b/Doc=
umentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
> new file mode 100644
> index 0000000..5c3ea1b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
> @@ -0,0 +1,24 @@
> +Broadcom's PWM Controller Device Tree bindings

This sounds somewhat strange, like Broadcom owns the bindings... perhaps
just:

	Broadcom PWM controller device tree bindings

Or for consistency:

	Broadcom Kona PWM controller device tree bindings

since apparently there exist other Broadcom PWM controllers.

> +Broadcom's Kona PWM Controller has 6 channels

"controller" and end the sentence with a full stop.

> +
> +Required Properties :
> +- compatible: should be "brcm,kona-pwm"
> +- reg: physical base address and length of the controller's registers
> +- clocks: clock specifier for the kona pwm external clock

Please use the correct spelling "PWM" in prose here and elsewhere. Also
you should pick one of "kona", "Kona" or "KONA" and stick with it
consistently. Might also be useful to mention what Kona is. Doesn't
necessarily have to be in the document, but if for nothing else, then
just for my curiosity.

> +- #pwm-cells: should be 2.  The first cell specifies the per-chip index
> +  of the PWM to use and the second cell is the period in nanoseconds.
> +
> +Refer to pwm/pwm.txt for generic pwm controller node properties.
> +
> +Refer to clocks/clock-bindings.txt for generic clock consumer
> +properties

This sentence should also end with a full stop.

Thierry

--I/5syFLg1Ed7r+1G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSkzG1AAoJEN0jrNd/PrOhFwsP/iF+BvZaHOAS/+kK80G8wCQW
tb0Wkdion8CN0ddWxB8kXvC0YFi5ihEDVRfTA9M/v6Grw631SRCP4RI+v87gENuq
BHu+dhzzDqCVYUWg0bY6945MlMLXg/CuRt9uXNk09tny91kvwjzAd4BhhHgogPs7
uDKMrFG5BbO/p8FFS9qe3qWjTcX1lYCloJzHI0QaJI9LnV8qmgYMIgmBigiz24Qx
N4QWeLwVoUUiAGuyTunm96CLhWqkrXkJIfUMADTNozTDPWnV8NpPxpBlsKueSJSB
Akij2Ta5DPEyXqAns8hGW94bmpFHDP86Ym0GxtbXBnW1xX2JcwXHJwIMWgNAc5wh
qnkL7Kfx5j0uR7Zy0unjAB9ONmYRlKWkTs7E2R/dmVzo/UptOPKM/KsUyK4veJmX
F1E9ktA3Q/Ywv88anjuYyIlnl3dvVipX4am0kbG8ma36ttmbdgPXIPbalweecuYI
gx5koFcMfZi0oVFHSd8kzyJDUp7mGzq9Y1OYzjK8gMhnt9tJXiLeRptcmL7A/3qw
IsNX9sPa0qBpNB/4T4rn1KtrdElbk1TnvS/et36vYst0gDSD5ydccFWSUU3veU53
y1zF3mrLAGzjFHNjkzkOlqRoYwgeq7d9W0TJ7vRdBdikD/ym6fE6oDsPukGQrWIE
yBpnC981/KEeKQTaL6/E
=Vy4a
-----END PGP SIGNATURE-----

--I/5syFLg1Ed7r+1G--
