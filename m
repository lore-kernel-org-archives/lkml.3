Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaLDWs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:48:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48576 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaLDWs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:48:28 -0500
Date: Thu, 4 Dec 2014 22:48:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Jiada Wang <jiada_wang@mentor.com>
Cc: timur@tabi.org, festevam@gmail.com, lars@metafoo.de, arnd@arndb.de,
        mpa@pengutronix.de, alsa-devel@alsa-project.org,
        Li.Xiubo@freescale.com, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, nicoleotsuka@gmail.com, tiwai@suse.de,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <20141204224810.GI11764@sirena.org.uk>
References: <1417499707-3125-1-git-send-email-jiada_wang@mentor.com>
 <1417499707-3125-2-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y96v7rNg6HAoELs5"
Content-Disposition: inline
In-Reply-To: <1417499707-3125-2-git-send-email-jiada_wang@mentor.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: fsl_ssi: fix error path in probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y96v7rNg6HAoELs5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 02, 2014 at 02:55:06PM +0900, Jiada Wang wrote:
> SSI component isn't unregistered if fsl_ssi_debugfs_create() fails
> in probe phase.

applied, thanks.

--y96v7rNg6HAoELs5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgOSqAAoJECTWi3JdVIfQmD0H/2cab5BQ49PiKU7DBqR4h0b/
3ieozrSYda0JOR2zNNCKB2LSzHI2heenBcd7cvCCM8rMIhHAsaGdBx/Df/CGMmmF
BQLuEzpzpbMVXrBO4fhdT6gJhZ80/eBwmCIVQQwvN+6mbr8yNm6nW/9j3wZaxDiX
iJSKtcqwjMXxTtBvZWKAFNXIPoIOu3loJpXkKyaz09eGm4tunpwzLzUysAZWViLE
0Uel8ypnGkGrvk54k2csKDrOOrEpveWDtmP+vEX9KOQ+8zgRb5rBJWXC+UTSDrUD
LMQ/RmMrfCl3Epzuor14zl1uf2iMlxmP0TmhsNW8v+crzkTOioa20NKELmrqZjs=
=iPDz
-----END PGP SIGNATURE-----

--y96v7rNg6HAoELs5--
