Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaIXT2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:28:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42312 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbaIXT2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:28:17 -0400
Date: Wed, 24 Sep 2014 14:28:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <Peter.Chen@freescale.com>, <stern@rowland.harvard.edu>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <balbi@ti.com>,
        <linux-tegra@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <yoshihiro.shimoda.uh@renesas.com>,
        <linux-kernel@vger.kernel.org>, <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v6 1/2] usb: rename phy to usb_phy in HCD
Message-ID: <20140924192806.GO17997@saruman>
Reply-To: <balbi@ti.com>
References: <37148636.BU5lT4M4eC@wasted.cogentembedded.com>
 <2300651.HNvMzB0aUB@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H83aLI5Lttn3Hg7B"
Content-Disposition: inline
In-Reply-To: <2300651.HNvMzB0aUB@wasted.cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--H83aLI5Lttn3Hg7B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 11:05:50PM +0400, Sergei Shtylyov wrote:
> From: Antoine Tenart <antoine.tenart@free-electrons.com>
>=20
> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> modifications are done in all drivers accessing it.
> This is in preparation to adding the generic PHY support.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> [Sergei: added missing 'drivers/usb/misc/lvstest.c' file, resolved reject=
s,
> updated changelog.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--H83aLI5Lttn3Hg7B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIxtGAAoJEIaOsuA1yqRE3k0QAJm0kzZBA3turOgqXHaVRLwm
VgpTmkv1S4cVxdnJ3BW2PvJ2TwogYn+wjTn+68TFFrMzZbATUvHx6Mkkeih9nFWS
98EkzNorTJsJq9zn7G0Quw4Tsr8jEZPlYinoIxFN2E/yvtn+Z5s9D0IV3AMzpnqA
2AW/3KKOevVbnE1gGU5AIZCworl8FfuIczwVw7jwaeLkAnpc6Dohn4IWDk/j9ceK
1vXEuijlw/cRh4nA2BgTggFxeWPyUW6PQWDe2ZQ1aBJxbDK3mLkqMkKtMQ9O7P+b
mJXqxQKPK8x/8tSEmS1CMKjEbUScllxzsjtt8+M/XwAyzkW5dqwRBoCc6fg+J9bJ
f/k1hEkT/ZdQ+IdEV6PuwchgknLKE5Ry77ajV1MnkH5RgVBpTkNR2JgrRMH/YZWg
U8bEVoy/0+jO39zznCmqls0krr0TV1/zMiYhA+WdPO3JsT5nQpPf/B6w8nuOiH5p
JC5PVEi44yizJIC+BCL3dn3g3TazNMigXlY8KSFDPhr76yVdg9Xbrv5rRZ70EL+u
0UvGsVlzqt7mA7a3zqP/92y2BtIiACTJ+UeDBmeBWXqepl5XkmUshlU45P1v0Oom
NpxQHpEV/cXe8w8yv51VvaaGi4jnLJQ40/c/TXTz5oMX6B6V2EQ/Clm8KwaCwRn2
ONCHIuCusgjX1LUfmin3
=YfsG
-----END PGP SIGNATURE-----

--H83aLI5Lttn3Hg7B--
