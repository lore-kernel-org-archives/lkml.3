Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3GBPe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:34:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44775 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab3GBPez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:34:55 -0400
Date: Tue, 2 Jul 2013 18:34:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 7/9] wlcore: sdio: add wilink clock providers
Message-ID: <20130702153423.GH7013@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <1372776948-24840-8-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGu/vTNewDGZ7tmp"
Content-Disposition: inline
In-Reply-To: <1372776948-24840-8-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MGu/vTNewDGZ7tmp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 05:55:46PM +0300, Luciano Coelho wrote:
> Add refclock and tcxoclock as clock providers in WiLink.  These clocks
> are not accesible outside the WiLink module, but they are registered
> in the clock framework anyway.  Only the WiLink chip consumes these
> clocks.
>=20
> In theory, the WiLink chip could be connected to external clocks
> instead of using these internal clocks, so make the clock consumer
> code generic enough.  If external clocks are used, then the internal
> clock device tree nodes are not necessary, but the external ones must
> be specified.
>=20
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--MGu/vTNewDGZ7tmp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0vL/AAoJEIaOsuA1yqREkvwQAJfiXafEIH4mCuZvpu31R3/s
vPkTdZ3gDPGJwSgy/hXs1kQQnHhF68FRlJC9+U984T6dChzMnctIUZlPRfvoJqN1
OGuCbrfYT9pOB3K8PtzDQ8jbQvv4Yqb1hAQzS03lsgBTYXQqplWMANygdNaNgiuh
r/hS0b6piVwAddL6c5WzlNFj9VDfRZ6XJNAd3NEp+UEVCYFnsizpRCPoDe1jEeMm
eqifKk77AvKxguYHgIEgNDtq/eektsHGeQ/5RGCO+O25H8jS9l7y0zmPtn8Aps3T
OG7d57ZBEpdLgEpETTQz2u1sN13PQDIwoVqVhGAuIL17WOAmgqZ9fwqgcgS9LBv5
oxf3mpV/14cJWzWayn9v3meOIafGJilgMNwNG7dEeBIqEckkQIB+ezVUSpvlptvI
/SvJ3+bKOsBGrhGpZ6agUFfRqsp066jDasksTUb289DcYNdpWBfgVMk5ib0pEv2G
VMYz1ll6z2KwRGe+J7F2Hxw8KTwPrT+8ncue2nXwtQR3up0shgp2WHVdZzzCNUyq
duQAK5k8367Uzpv2FlAYBJ0n1IBTILzIzAlTwb182TcQ1moB+mMzJmOIayCthxi1
1L5dmqtOLwRFmxNop9A8gXJWQa9NqlG75QykMChnmOMaigou8ldeL5aR8P9IetGY
GWOSPzJk8P8HFOAPIXZc
=1iXh
-----END PGP SIGNATURE-----

--MGu/vTNewDGZ7tmp--
