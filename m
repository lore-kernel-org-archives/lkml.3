Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaANV0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:26:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54350 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaANV0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:26:10 -0500
Date: Tue, 14 Jan 2014 21:25:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140114212559.GA15567@sirena.org.uk>
References: <1389674132-14928-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HwY7O+GdaLKMYOv"
Content-Disposition: inline
In-Reply-To: <1389674132-14928-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH resend] ASoC: simple-card: fix one bug to writing to the
 platform data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HwY7O+GdaLKMYOv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 12:35:32PM +0800, Xiubo Li wrote:
> It's a bug that writing to the platform data directly, for it should
> be constant. So just copy it before writing.

Applied, thanks.

--+HwY7O+GdaLKMYOv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1atkAAoJELSic+t+oim9v4kP/1CKThpq8yWxL5LUK5o4jfEn
j5hMRHxgPJt57l+60MmAVRsxgRErRMNcIZ4mm9/mne9eNuYp9F3jjbBupkz2CCCn
a2GtBB3p2i2NvuUL2geV5XnVkCKsawrKWZI1yyCmbQMppcPMfB0+IaMDJ7AqY3h8
Sz/UywLnXsyNwEc9k08W6wwwrsg7u71okhdDQvYvd5k1nHC+ewlGpk+R7WmPZ5VT
JF/fNhPc0TutQ1xuplybLAUvhLp8ZIICxoKVwdWz+bmfqCqtxc2q33W86+NbtRRU
Zszq8bTy1pYHncK3QMGE8j79861nrscCA9x++e1sADZ47DFarXocw5Tow1jPcTGN
qvgHo1YAB0g4r1tflxUZ6LG/ynX4pR+aNJaVaiqOFA0bK9LXpgd67zc+vx69j3C5
lb2GPNrLG+ceN9sjVI6krvvQIxreStip1AsVq7x9daWtlK/oDnmZrUBmdQfKa+S3
05scdU/3P1KBUoGNcY8tIvXrHQ5hJjlGukOeHiMJEn1tfSCFlldsU6vZltFpNPEi
HFf1Bl25kzIiXb7HU98+Qi4yMWQYH8ff12sIpQQXehxXPamPcXzfkoj16hWCfraV
/zNko921EBzXuzkFTcnywoRZaANhSEAM2H6AYTyzVkoxdSmjsjFtnVnRbWnsIL4+
O20j8iMeKUTIm0BdILaf
=xQEr
-----END PGP SIGNATURE-----

--+HwY7O+GdaLKMYOv--
