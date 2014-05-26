Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaEZPBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:01:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43270 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaEZPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:01:12 -0400
Date: Mon, 26 May 2014 16:00:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org
Message-ID: <20140526150052.GP22111@sirena.org.uk>
References: <1401098197-647-1-git-send-email-j-keerthy@ti.com>
 <1401098197-647-6-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F+XLDYyeDCF2A2Dn"
Content-Disposition: inline
In-Reply-To: <1401098197-647-6-git-send-email-j-keerthy@ti.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] regulator: tps65917: Add Regulator driver for
 tps65917 PMIC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F+XLDYyeDCF2A2Dn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 03:26:37PM +0530, Keerthy wrote:
> This patch adds support for TPS65917 PMIC regulators.
>=20
> The regulators set consists of 5 SMPSs and 5 LDOs. The output
> voltages are configurable and are meant to supply power to the
> main processor and other components.

This appears to look *very* like the Palmas driver, should it not be
sharing code with that?  If it were just data tables it'd be less of a
concern but there's quite a bit of actual code here.

--F+XLDYyeDCF2A2Dn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg1cgAAoJELSic+t+oim9gJ8P/1eaPzxLm+nLLyS3uRty7y2X
VL9Wrdqi8s1PhwfrRB1CQ0SMe2CRnKxNBp1hbZmgN7grZA6vOK2QSFUoaEyGU0+K
0njx32XyAJndD6S/jEM0u5j55CqbFYDKwP1qeh3k39x1YBvVZR7ICsswxbYC1Iel
Q667celyq81GvQgatm+Pi1qvSp31J1o2fH6xbILmDZ3P+3eD//Ti92oC4qhQVBNI
7EhYC/NycsU1gxnnkxe1bpQkvBLaDDlO5njw7+nzO0R9jG36CI2g1CzsCRVUq5eC
6JopYH0LcC38xhsnJWcLXiOz67iWTCrB9QVuqWmQ61IgFWZ+O7bChmv3gQuV1njj
pbG/zp2dKK1F03GtxTk+aaYknokRLiCuX9GPogv1erztKcXPtHDUfTWCwYHoqd1F
f+sC99QCbZhmG2wpMNQ7zScBwXrOypHeLxptK5J0nr4kqi8V1CJykkzQA/wiCfB9
+sPfYeHHUi002LUau+uL8cimtRObvLKLslA/jpTlT0nn6TLDBtCqlTsFdHHnLSRJ
X1fVOlG17h/ZED0lV7d3rwXVJogywVBnWvJ6CFa0ke8Q+BB74gWlElYTvY2JRG1m
ZBHyr540LKfyztVP9DgLuuMA1f81GF55l/mx684j6BfIODQepgvPdPJzymn+/58N
8MOLYzced923r/HSEgw5
=lygs
-----END PGP SIGNATURE-----

--F+XLDYyeDCF2A2Dn--
