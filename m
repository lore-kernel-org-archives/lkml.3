Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaL3L3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 06:29:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55580 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaL3L3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 06:29:42 -0500
Date: Tue, 30 Dec 2014 11:29:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, lgirdwood@gmail.com, a_bouin@yahoo.fr,
        timur@tabi.org, Xiubo.Lee@gmail.com, festevam@gmail.com
Message-ID: <20141230112938.GN11764@sirena.org.uk>
References: <1419898431-11336-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D504LSv93hbJZH+j"
Content-Disposition: inline
In-Reply-To: <1419898431-11336-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_esai: Fix incorrect xDC field width of xCCR
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D504LSv93hbJZH+j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2014 at 04:13:51PM -0800, Nicolin Chen wrote:
> The xDC field should have 5 bit width according to Reference Manual.
> Thus this patch fixes it.

Applied, thanks - I also fixed the patch author up to be him.

--D504LSv93hbJZH+j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUooyhAAoJECTWi3JdVIfQsscH/2tn78KxlqXHvPwBr5UzDLk+
TQhZAiQNl57FMi65A/BbhqRNa8q+LBpwNnDHMi7rVOA8AMdsOQ4v9PxYaQZv3kb9
nb5D5borblQZ2PUssBm3VB+veix+vH6r7gzBZJ+haYJICyN71ER2/pYcN9BWw856
zqQQgEcEzC2g23vo/+c+1jpTHyHCfhfTiMi17dMJTsfmAXx9vG5vUY6bWye81naZ
rG2jbiFv/3JoHyoVt6NsETa2MVTsvDRuEcAV0YFA4QLk2MMpoaEuuWyLRpAASWTF
y0lwDMuD6i3uIRy2qWkjdGWfXUTvogldo3D+fDDt8jjzNRZhxNN7b8+doxhtcUQ=
=kztK
-----END PGP SIGNATURE-----

--D504LSv93hbJZH+j--
