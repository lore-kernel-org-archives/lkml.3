Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaJHTEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:04:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57371 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbaJHTEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:04:34 -0400
Date: Wed, 8 Oct 2014 14:04:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Dmitry Osipenko <digetx@gmail.com>, <swarren@wwwdotorg.org>,
        <josephl@nvidia.com>, <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: Re-add removed SoC id macro to tegra_resume()
Message-ID: <20141008190432.GN22688@saruman>
Reply-To: <balbi@ti.com>
References: <1412794450-9060-1-git-send-email-digetx@gmail.com>
 <20141008190147.GM22688@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rFUhhEVnhEf/dYhU"
Content-Disposition: inline
In-Reply-To: <20141008190147.GM22688@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rFUhhEVnhEf/dYhU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 02:01:47PM -0500, Felipe Balbi wrote:
> Hi,
>=20
> On Wed, Oct 08, 2014 at 10:54:10PM +0400, Dmitry Osipenko wrote:
> > Commit d127e9c5c5bc1ee22a7b1fe804397cddd132f756 ("ARM: tegra: make tegr=
a_resume
> > can work with current and later chips") removed tegra_get_soc_id macro =
leaving
> > used cpu register unassigned and as result causing execution of uninten=
ded code
> > on tegra20. Fix it by re-adding macro.
>=20
> you should add:
>=20
> Fixes: d127e9c (ARM: tegra: make tegra_resume can work with current and l=
ater chips)
> Cc: <stable@vger.kernel.org> # v3.13+
>=20
> here. With that:
>=20
> Reviewed-by: Felipe Balbi <balbi@ti.com>

oh, and you should probably Cc lakml.

--=20
balbi

--rFUhhEVnhEf/dYhU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNYrAAAoJEIaOsuA1yqRE7yQP/jNlli0FpeW2bQ5TT6bbLpBE
97rW/Vy446PnVjQDokp1P3VTjFrcQcc8/toHSLbmyXHItVVrrUFLK+bpSWHu+21X
27Bll0VnxH+MY476PnfMxNx3fQXWOGX9cdpojrpsFyqUp0B92ilj8f8M0iGUWP2w
+67twlYP4viMfliQwNu2n7E0WI/i+vGyQEaWf+4ZX6qrMOhq8V0b/FCO+bOmllAZ
1w4kfh53Ful06UPfHPGvkLzy860GwznZQrBzSmETDlG82tELomTlWf7agoCsOX5U
rhQYCbZlRNj7XmDYf4t0Kvrs0isu83Y7cakOVK3fCctM03dQGNjlKgGW4kjhFW8M
olFiNHtBY8TvuMTkY5Sdh93rCs1NaoRWD6gUNtKdXFeCrKy6J7VPrwa6NAqhEhXW
99MdJOThpmD8srYa1dngJpwX6xmjPG83jYxwam8ahUFD7/k1V81j9sid8ImjAcNF
81IUbrk60fCaz/KMVIlleK3mDuJ9L9pqz3c33CpQzhpvqCY0BWwDy6fWEl9taQs4
jkh2+Q5ymtgeN/3xunYjX3rWBOPvYaHz8mmkFnF9gO+3OiMMDcslk9JKu6Z490Pm
ucpxp+Wn1JoHm+lnDgHKF15YNKSrWgl02EaPUz43/AXAz5PlHnRQOipeRKx7l4c2
fwWd4wTBe8yA/vitXrHT
=AUyT
-----END PGP SIGNATURE-----

--rFUhhEVnhEf/dYhU--
