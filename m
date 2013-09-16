Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3IPXsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:48:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41241 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3IPXsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:48:08 -0400
Date: Tue, 17 Sep 2013 00:47:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com,
        uclinux-dist-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130916234734.GH21013@sirena.org.uk>
References: <1379114437-25090-1-git-send-email-valentin.ilie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5bfZ/T2xnjpUIbw"
Content-Disposition: inline
In-Reply-To: <1379114437-25090-1-git-send-email-valentin.ilie@gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: blackfin: Add missing break statement to bf6xx
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e5bfZ/T2xnjpUIbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 14, 2013 at 02:20:37AM +0300, Valentin Ilie wrote:
> SNDRV_PCM_FORMAT_S8 isn't supposed to fall through to SNDRV_PCM_FORMAT_S1=
6_LE
>=20
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>

Applied, thanks.

--e5bfZ/T2xnjpUIbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSN5iTAAoJELSic+t+oim9gq0P/A9HFPvZ1GO5zbtwGu7jzPb6
nxihZp9QKf2Kblo2a/AC+Cfec6id3059WEvvfzFoJ9r1rGeeCnLf+E84zBvQSiwG
AFJVOk4GwspVOucan2hBlRR/51SmOMxRqlzt1hi2UcEH2ve5P4rC5yIiY9BrkgJ8
7gfSs4ZiY5SUIE4h91BBkeewVFSq6Ubxc0tANX0WrzXF/aDy789Kfi0dscj8oxcg
pFysM7CQxDU62nrWYvhYyA4cllMfcFNQeRi22poPk+7vECt1DgXB3gPAi2VZxRT1
YcN0JFWbarJl9X46aWT+/l0YhLScLrIBqJ36eH9MVN+j1gk6a+W9lklFYKn6scS2
NdEVha6QydcAlNN1l1supp8ZnISkEztxIHvobsaY9a48dp+8XzSLlp8zILITFFZO
DTxWG/Rjxc5h96PxxDBCWx9LiXaj3yx2boCwAliBKLqkBYAIxZuOEHHK/7hfpBju
mbEyehtbyCvjNHaCgEBydG6gXGN0bLSns4UUSJWhLMu0bkwwL1yZrzKhUI176fZ7
l9yObaHIFxPHMbuUzgP3pfmORb4MGxamR5uw8D7t40DCwTdmBgNI1T1Xx5vm6Or1
Gy6g19bezt1HyX0B7s0zGH6tdSaSSgxwCNIEqYGoLQn7XwHCOS8L8QcYCw3NQCBK
Uz+b85D+nfrfmqo3dRm6
=o5oB
-----END PGP SIGNATURE-----

--e5bfZ/T2xnjpUIbw--
