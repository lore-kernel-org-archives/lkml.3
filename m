Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3HAPlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:41:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54088 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3HAPk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:40:58 -0400
Date: Thu, 1 Aug 2013 18:40:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: <akpm@linux-foundation.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>, <swarren@nvidia.com>,
        <pawel.moll@arm.com>, <Mark.Rutland@arm.com>,
        <ian.campbell@citrix.com>, <broonie@kernel.org>
Subject: Re: [PATCH V3] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
Message-ID: <20130801154020.GD11286@radagast>
Reply-To: <balbi@ti.com>
References: <1375370931-2194-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Content-Disposition: inline
In-Reply-To: <1375370931-2194-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2013 at 08:58:51PM +0530, Laxman Dewangan wrote:
> Palmas series device like TPS65913, TPS80036 supports the backup battery
> for powering the RTC when no other energy source is available.
>=20
> The backup battery is optional, connected to the VBACKUP pin, and can be
> nonrechargeable or rechargeable. The rechargeable battery can be charged
> from the system supply using the backup battery charger.
>=20
> Add support for enabling charging of this backup battery.  Also add the DT
> binding document and the new properties to have this support.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+oFkAAoJEIaOsuA1yqREe40P/jgvgPeOPU6EksuQBoylj2Oi
tDeb43CAiN9OMP1R8V0yv48Lm0T8Y20hdaSrGtqIGU76VfEl7puGmRBkpszoMfr2
+gZL/KtmWVbUEzy2/jLrQ1KQhC1YPEgPp8Zck5T5nPU7/vbj85FgGqFSgpbKZBB6
UD1Pt77l26qL/7dRr1ec6yauk0q0ZfTeKopuG8HKW8FQOhRAX7XZzzgh1cNQtBFT
9GTk54DfAFS3+jqCA5DyRRJKCmZPlKCSOXrHAyj0tylQJ3O1OCLv+gu6OgR5DqsV
JgnCXFflr8yuMvVf5ZFfhZu4GSnw+TScjUJP1TmgHKhC/IJShvDQOAvIzPB1SFD1
8C+VIDjdR4Dvf8a1qEy3vvUmipZbmvEqp1DoBJNa7JQXsqOa9CK/3ZyoO559MBqQ
UgNwexcEROILIpy8sFgM1Z07GjzLqofR2FfbWjp39HqcsL+dyKmRQVg89ODv+4zx
FbhqpuJ1mns1zkQt27P3kTRvktSKefqL+sL58ola/2J8nIW38TieF90BnMj833JT
WkA4D6XgedPVmXae43Jg96ZgbYTnE0LosU+PICEU3VffTUscf23ZKadYg/oFWgUW
gZGVcLwEPvWMSQj33Pw0Gf2bPhxB2inJQC6ZFp12/2rhNK+RjU7k/xUFnd59zwaU
14TAkTOmkYF9+n3Ua5iG
=LHc1
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
