Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3DRLHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:07:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54606 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab3DRLHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:07:42 -0400
Date: Thu, 18 Apr 2013 12:07:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] spi: omap2-mcspi: fix error return code in
 omap2_mcspi_probe()
Message-ID: <20130418110740.GC13687@opensource.wolfsonmicro.com>
References: <CAPgLHd8qt3o285vskc-JzNOh0Yorehgxy+SEUoJ_kccy3cjcMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZQ93ZA/51YEIDw4/"
Content-Disposition: inline
In-Reply-To: <CAPgLHd8qt3o285vskc-JzNOh0Yorehgxy+SEUoJ_kccy3cjcMQ@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZQ93ZA/51YEIDw4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2013 at 11:14:59AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.

Applied, thanks.

--ZQ93ZA/51YEIDw4/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRb9O4AAoJELSic+t+oim9ZIoP/jlWNK2J3IybzIohiYYiauMa
n2wFFG7n0aL1kP2ZoUFV23MUSHHL8toca77E+BOXSuSQ9O/louh7G4I3KiVJ4OSR
PkB2sSXwo2Zaqtwv1HaHzxcKD8KSxqwtFaVq1Xg5PRcjEQfSxj+jnzay4/LhJwQH
pkZIji5fMmt4Q2DtarHloGAyHIzriXTTEh68tsIkUZ4GC2+s2KWbnzRwKxIkDW30
dnDqpJ3BTteTZhu8rLXQ+Io7MF0Q3Y+NT8ciSG4hZI6Ln6tJOTwswiHNVokCFmas
fKOaSr5E+3YBS5EV4r08e59TjszJtoRVte/JWPsi2WiMV2fmCfDtqJ/fAnW4H96Y
7eoDzSFIL3ROM4dZw12psiubbwT9w/s8S7WAKYYj6Byhryu0xTW8z9UzlxLnEiYV
ujofQ4jl343BUQgNMI6PR8QIo3FOz9rCJ2u/M9hBzlQnUBTZU4ugZ4MCwYuXl8n4
cVp8b65DlmdLY1qTv5SpxYLV8IKwjtXiJETAwDfKOlyGo6KK+XuVbYDXbfYSGQek
eDvX+mzbiOtSWmRBABjb4ndbUc/15gJNzcDm+of3XcTQrUwig/0opd0U36KcuxIe
35qABPXwjSe5XkmcWwZd1cmE9ZS0R5yzOA59hpF4fYrFMokS42C87mwp9A6eRZhG
Mb+1jjLNK6Vx0SgF8Tvn
=1Bvx
-----END PGP SIGNATURE-----

--ZQ93ZA/51YEIDw4/--
