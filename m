Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaJ0Qk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:40:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44480 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbaJ0QkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:40:25 -0400
Date: Mon, 27 Oct 2014 11:39:18 -0500
From: Felipe Balbi <balbi@ti.com>
To: Romain Perier <romain.perier@gmail.com>
CC: <heiko@sntech.de>, <devicetree@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <johan@kernel.org>, <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <balbi@ti.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v1 02/10] dt-bindings: Document the standard property
 "system-power-controller"
Message-ID: <20141027163918.GB14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-2-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <1414427215-14380-2-git-send-email-romain.perier@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 04:26:47PM +0000, Romain Perier wrote:
> This simply renames the previous documentation to something more generic =
and adds
> updates according to last changes.
>=20
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  .../devicetree/bindings/power/power-controller.txt     | 18 ++++++++++++=
++++++
>  Documentation/devicetree/bindings/power/poweroff.txt   | 18 ------------=
------
>  2 files changed, 18 insertions(+), 18 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power/power-control=
ler.txt
>  delete mode 100644 Documentation/devicetree/bindings/power/poweroff.txt
>=20
> diff --git a/Documentation/devicetree/bindings/power/power-controller.txt=
 b/Documentation/devicetree/bindings/power/power-controller.txt
> new file mode 100644
> index 0000000..e0a1abe
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/power-controller.txt
> @@ -0,0 +1,18 @@
> +* Generic system power control capability
> +
> +Power-management integrated circuits or miscellaneous harware components=
 are
> +sometimes able to control the system power. The device driver associated=
 to these
> +components might needs to define this capability, which tells to the ker=
nel
> +how to switch off the system. The corresponding driver must have the sta=
ndard
> +property "system-power-controller" in its device node. This property mar=
ks the device as
> +able to controller the system-power. In order to test if this property i=
s found
> +programmatically, use the helper function "of_is_system_power_controller=
" from
> +of.h .
> +
> +Example:
> +
> +act8846: act8846@5 {
> +	 compatible =3D "active-semi,act8846";
> +	 status =3D "okay";
> +	 system-power-controller;
> +}

there is no mention here that system-power-controller superseeds
poweroff-source and deprecates that.

--=20
balbi

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnU2AAoJEIaOsuA1yqRE1bEP/3w1qaKnt/soJsWLxUog+aCM
uMgzJRmOz2ZIAD+6B2chsi6JbdovBszPaErdf2leX5+0VpX+XjnTntcgjN6Rufyj
WGvhHrzvSGFL3xQn+cyxMgngO+jFuq5j8pS868tymYeyj/2MGOWe6qhK/+hyX/kc
tKEazbyPyw4QGauQ1LK+709OXWG7507QGpqgUIkHQ1u9A1ELMwHm+k1EoNiLem7O
RXkb0N7I9XoEUibnMhqOnSrcp0+3qV25LitW8kGTanb67EtHH8W9ja0O36pa+cP4
tmrj8/U0qAIrdFKSKHyB1uCwbi0RQ9EBfbHX6KBSxgIcq79jgcGS7n1ZD02qoDP8
HdB/mtDJIbOf8UxJL5FUP9izcEY5+DHc+1mj1eC7S8o/t4Fr/DRTmAlERDZKKQeJ
+yVEk8bXtl3snkfjKXR67RUZyZiJm3N1O+IcFNyS+HircXoT8eB9erjUtfiDcPcj
OuK0VIDvrDoMcYJtqokTKnrkHNO9Kaqkb1RhqSi2zZXijzmbEwt9I3g57+Ac5ugj
HgqpZiFEtR0HZJmWgZEg2E551sXPt3rGn1dDdTGoIBJJQbkChvCDb6lFOLrXrclQ
FkKD3YySoyUG8Tx1CaklsV/+K5IzDJSW71l/QNMCOLW3nun3QuGIE5/MGIqbfQ8+
/B4T5X+D0spTMHoBCZXf
=K/db
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
