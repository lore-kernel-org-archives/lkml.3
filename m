Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbbANTUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:20:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57435 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbANTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:19:28 -0500
Date: Wed, 14 Jan 2015 19:19:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <zidan.wang@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Zidan Wang <b50113@freescale.com>
Message-ID: <20150114191911.GG3043@sirena.org.uk>
References: <1420615905-4078-1-git-send-email-zidan.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oOB74oR0WcNeq9Zb"
Content-Disposition: inline
In-Reply-To: <1420615905-4078-1-git-send-email-zidan.wang@freescale.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH v2 1/2] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oOB74oR0WcNeq9Zb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 03:31:44PM +0800, Zidan Wang wrote:
> From: Zidan Wang <b50113@freescale.com>
>=20
> When we want to use wm8960 codec, we should enable its MCLK in machine dr=
iver.
> It's reasonable for wm8960 codec driver to manage its own MCLK.

Applied, thanks.

--oOB74oR0WcNeq9Zb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtsEuAAoJECTWi3JdVIfQ/P0H/1+h4uWTLkQ2R4eGJLMzFKA2
d3R48lCthLcJMSU+zECQwZZNnCA0uafBOqSRBfgJcZXAaoLQ+Mg0oAJaM1UUuaxP
ZaBua7bS0AnZGhITAwMQIWGyiCMODudVyl7e2TyMC3ijiEVBc7TCNautYYtomX12
DL20QGvhdYS6bh3SqlMJVQvoNxnWr3+aXp9QHWe31AEMMPV0p3MfxgnkR/qY8V5T
AN1NgwR5UGg7gN4k+QjvPTCAwB5Q9V4AKm4ghB/piF+o5RTLQaqpBplT5TyF4uBZ
lsPkiKAYL4gzAR0AAC3Q2rj4Fg85+9HrgmLIUzpp0nVfbiMjx0XKVPt3Q/1Bet8=
=DLme
-----END PGP SIGNATURE-----

--oOB74oR0WcNeq9Zb--
