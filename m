Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3FGOhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:37:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58141 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3FGOhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:37:13 -0400
Date: Fri, 7 Jun 2013 15:36:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, balbi@ti.com,
        peter.ujfalusi@ti.com, t-kristo@ti.com, tony@atomide.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Message-ID: <20130607143649.GS31367@sirena.org.uk>
References: <1370602390-12306-1-git-send-email-oleksandr.kozaruk@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FU8v9NgvNgS/pFcX"
Content-Disposition: inline
In-Reply-To: <1370602390-12306-1-git-send-email-oleksandr.kozaruk@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC v1] MFD: Change TWL6025 references to TWL6032
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FU8v9NgvNgS/pFcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 01:53:10PM +0300, Oleksandr Kozaruk wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
>=20
> The TWL6025 was never released beyond sample form and was replaced by
> the PhoenixLite range of chips - TWL6032. Change the references to
> reference the TWL6032 class and name the registers to twl6032 in line with
> an actual released chip name to avoid confusion.
>=20
> Currently there is no users of TWL6025 in the code.=20

Given that the chip exists even if not widely distributed it seems as
well to keep the twl6025 references in there at least in the device ID
table - it won't do any harm to people using the twl6032 name and might
help someone who happens to pick up an old board for whatever reason.

--FU8v9NgvNgS/pFcX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRse/+AAoJELSic+t+oim93xoP/23IcxsY6qp7RLRyio73nOU8
ChOatNoEVZKxtlUIY1pdbmaOFDSflWh13mlvmDP/PMwc5athsyOaPx5unfyvDaOz
Vf8h/gnLaB8GFbF29OyRZtRLOjMqtdpnXOa5CaUTxjEgWpcIxuw6sl3JBwCD/fgg
bk7u4bjVd6wxog1YSwHVeK4uID/TDKsANacoMbT2wcLrU8ZeyE+ywoIlugJFnGnS
ArsrM27Dov9tFdXd6/5kGioGIHhBmH6bFqi0KAVAOc3E4uORroekeYMP2uAuAbvs
dFHvnaJ+5mh2x7y5KBpsYzFSgYUNiUwgM42LlerXJw/7aLv+94tWYlgTd01tLXDt
RetwrL+lYzACKRH71nI4fQpndv9vqNLaa0Z5rJ70esh0Qxtqat8Dd73KLEG++otD
hJgQMMWxwkKQyS9lL8v4rGQWO/4qtApaqMCdoCtpXLJM62e2DUENA9LKEARywBrO
mbweCDtSKhMAETUtEt5Z/sZ4t7+Sv7TjtbUn4EpEldx7NC1KMYeulv1ufyDoh3s5
7JoB9S5U95eh4pOm9hRn5hFX1pskNDvNeVNt2f4kK6UbKbpyRJ3JVcxc+p1CcPfX
6SuL5YxmLx5KRtJCHM38PvF3bejjSF6TLbZ8c2taQn38fdIw3Hi46f+oJU1tTQsu
1OiH2G39aJ7NqO39DHZ/
=vGWS
-----END PGP SIGNATURE-----

--FU8v9NgvNgS/pFcX--
