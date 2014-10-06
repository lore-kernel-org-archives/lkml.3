Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaJFKyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:54:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48733 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaJFKyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:54:38 -0400
Date: Mon, 6 Oct 2014 12:54:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 06/11] drm: add DT bindings documentation for
 atmel-hlcdc-dc driver
Message-ID: <20141006105433.GG25202@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-7-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BzCohdixPhurzSK4"
Content-Disposition: inline
In-Reply-To: <1412175188-28278-7-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BzCohdixPhurzSK4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 04:53:03PM +0200, Boris Brezillon wrote:
> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
>=20
> The Atmel HLCDC (HLCD Controller) IP available on some Atmel SoCs (i.e.
> at91sam9n12, at91sam9x5 family or sama5d3 family) provides a display
> controller device.
>=20
> The HLCDC block provides a single RGB output port, and only supports LCD
> panels connection to LCD panels for now.
>=20
> The atmel,panel property link the HLCDC RGB output with the LCD panel
> connected on this port (note that the HLCDC RGB connector implementation
> makes use of the DRM panel framework).
>=20
> Connection to other external devices (DRM bridges) might be added later by
> mean of a new atmel,xxx (atmel,bridge) property.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  .../devicetree/bindings/drm/atmel-hlcdc-dc.txt     | 53 ++++++++++++++++=
++++++
>  1 file changed, 53 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.=
txt
>=20
> diff --git a/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt b/D=
ocumentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> new file mode 100644
> index 0000000..ebc1a91
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> @@ -0,0 +1,53 @@
> +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) DRM driver
> +
> +The Atmel HLCDC Display Controller is subdevice of the HLCDC MFD device.
> +See ../mfd/atmel-hlcdc.txt for more details.
> +
> +Required properties:
> + - compatible: value should be "atmel,hlcdc-display-controller"
> + - pinctrl-names: the pin control state names. Should contain "default".
> + - pinctrl-0: should contain the default pinctrl states.
> + - #address-cells: should be set to 1.
> + - #size-cells: should be set to 0.
> +
> +Required children nodes:
> + Children nodes are encoding available output ports and their connections
> + to external devices using the OF graph reprensentation (see ../graph.tx=
t).
> + At least one port node is required.

Are the connections configurable at runtime? Does the SoC have IP blocks
for HDMI or other types of outputs or does it provide only RGB output to
external blocks?

When you say "at least one port", how are multiple ports going to work
if you have only a single display controller?

Thierry

--BzCohdixPhurzSK4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMnTpAAoJEN0jrNd/PrOhUn0P/A2lojPJ+gPloP7KlZqjKsUs
kbB5o0sCvIThRWB5lCw+md/C1tvir+dCVrqBE69r6kB8NiInOUdfHRZON+PZiyDc
KBDAffKPzXNz4wl9LJwdpdm0AWqivZpxvL/n3abvfsZsUt6Sw0svt9yWW6NeStzJ
AWNLghyx8pVNnZggiYgoA502Xhcd2nwtYab72PS54LRXZoOBIVHifJgaVBgScvvf
Y9bxJYQ/Clyf2AOm3Rb4CoUsmJTACOIoDDwIDdsZK+tIf3MlUub27O76+/fiZ2uv
2LbYuT+rB9Jg0e7haF5RcsQhyoNg5/KO6gIsEp/YyYu0lesFwR2A8g2XIHLU9OzA
MyZhMX3byve4+myNYWqwvWrBfUHjxYtB3U4M6vkPiR11OpzxRJteglCAw7EDtX/V
tiMpITZk6DcwIzjU4WF5pXkrJn732AhgrOaQrdGc/nY/WGCB1obOYHZusNrJQWFj
SEWSKtFhPp54cUGu/DHOhr1v6CqPZ1jHXPSz+4stmjdrgZ0oG30SWWrYTVKzWG9b
t8ECQAT+POBBp2VyArUHTwEIlH9+r8RuZ9kEqWLbxvhnqLQmCbKO8AN8bhW/jeUR
KznMESMh0uZWjzTNxas+ruG2gt789C7lBaFTh04xwS1nrWT0AsL6FmOPaNHn7Tbr
FrrKOJswUV94UJJOihQz
=LgoW
-----END PGP SIGNATURE-----

--BzCohdixPhurzSK4--
