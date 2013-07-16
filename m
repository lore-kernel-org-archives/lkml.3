Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab3GPNwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:52:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60896 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3GPNwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:52:16 -0400
Date: Tue, 16 Jul 2013 14:51:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, shawn.guo@linaro.org,
        fabio.estevam@freescale.com, wfp5p@virginia.edu,
        LW@KARO-electronics.de, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130716135149.GM22506@sirena.org.uk>
References: <CAPgLHd-cXmWwMq8DMhXbOhykZvnMzxb4HHZ-5ayNnkPU1fqfQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ToWwKEyhugL+MAz"
Content-Disposition: inline
In-Reply-To: <CAPgLHd-cXmWwMq8DMhXbOhykZvnMzxb4HHZ-5ayNnkPU1fqfQQ@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: imx-sgtl5000: fix error return code in
 imx_sgtl5000_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9ToWwKEyhugL+MAz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2013 at 08:05:07PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.

Applied, thanks.

--9ToWwKEyhugL+MAz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5U/yAAoJELSic+t+oim9YNYQAIh5smhf1bjLdc/sMFmic1jE
YWbNcOC9ypSY+HDmQqm/nz0h2Mk/zjzGrZyDNCI0ce6Llv0SuTI8fCVg7IZauCWv
y8+ect573u9Hs+lU5JtYi9RWEyl5KsS0cBEBeg6LiOR/eEBYB1ecvKnLS/ZTRWde
6Qf8xC+B/Nu+/kyPU6vdxEG3IRsmq59pfBJQzDuJGrhoeYK04ibX+sKB0ORjWq2k
rm7AX+uys9+/CUWmRWRTUoDtW7nyZUIbmil/GB3KmOEiJk0fe7aIOW7DHqETXOI+
cbA/Vk61yW8dDYx1yURaiJ3W/jUZrvolaYfN3pae4j7qIa6W2R3uof2S8CEA40u+
xykyMqIOq5THtdUSk6tnAtClYksECfWJws14xQ1iGGBjX+ZP6J1XGyNDTxJPoyzr
cXFyB4Mcd/68W7C5dJlzKtvUScrFy+pTxRha3WtTPF6MDxNdgPUtAJcVjMm+4J+q
jyKIzy6WXu8BY/gEXWcYfbaRtiPBCCZl7HCwp+dNQPhcMmYeA72nox+BArT2weXA
c5NlNuSVRo0nREocLka50p0kbkCuMsR5EbA6czcSs0Ct3GQBuvTmyAV9YypKMLdf
Dznesa7oVZ5hhb6iCICfZoir1Euvkdp/LGvX7tXrBJEH8bmiqIYPAqVpBkCg8pMO
+DULGmMk8MS+Hcp+6H4X
=JRGW
-----END PGP SIGNATURE-----

--9ToWwKEyhugL+MAz--
