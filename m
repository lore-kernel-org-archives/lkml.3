Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbaDXOjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:39:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44332 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbaDXOjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:39:42 -0400
Date: Thu, 24 Apr 2014 09:39:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: Felipe Balbi <balbi@ti.com>, <chris@printf.net>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
Message-ID: <20140424143931.GE26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
 <53592037.8050106@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fWddYNRDgTk9wQGZ"
Content-Disposition: inline
In-Reply-To: <53592037.8050106@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fWddYNRDgTk9wQGZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 08:01:19PM +0530, Balaji T K wrote:
> On Thursday 27 March 2014 05:34 AM, Felipe Balbi wrote:
> >Hi,
> >
> >this series lets us access the newer registers introduced
> >back in OMAP4 which give us some valid information about
> >the OMAP HSMMC IP like max block size, support for ADMA,
> >support for Retention.
>=20
> "Support for Retention" looks interesting, can you shed more lights on
> it

HWINFO has a bit (bit 6) which tells you whether retention is supported,
it's in all TRMs since OMAP3630 or so.

"6	RERETMODE		Retention mode generic parameter
				This bit field indicates whether the
				retention mode is supported using the
				pin PIRFFRET.

				0x0: Retention mode disabled
				0x1: Retention mode enabled"

--=20
balbi

--fWddYNRDgTk9wQGZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSIjAAoJEIaOsuA1yqREYi0QAJ0isNNTkVzz0NmZhgRvFbqM
7vgsoY1+hOLXV8nuu3YOFGwTd1whldV5Qg17OgwH5cKUOEK4IfsP/P57b1M2GMIq
PgFhAss0FvzfHnY0vIxwkcO4OlYq3D2hn7cLIV9LxRhooPLcl+vllbB76Pgm/+ew
rh3mz1950fIiYOfzMDRj7y8uNcKc5qr7pJj2/baxIWFmBcME2VnVaJCLM7+u9SCf
p8ut75KKmZZTkWw17t8ts4qvtzFEBw3aLLxxs3kk79AwoSNcCqxfH0xOYNXLqAGa
Q0XIZ5q1AUNsDw7sWFrZbyl9V3s7Lu8Kp8F2tb20xaY24UHfNWX+DOb7bpcOaI07
eRJwXK4hilFsicTBjX/O1mRkIElXDWAxSahE0uJ8kXXyx1JDy7UasvlFp4Z7IUvZ
ufH1APYyofMusKHvPu7ENEu4C+SmP2mVA5F6iTSOcNyS75VHCEW6D6VchSpmV0Tw
kaDIulOz5UuwmtWudcyZoOE46E4fyK0uGD/XRojmRoK/GznJNEOypLxYzm7mOhKc
XzUgoVkqAxgp/9I/FJkZFa7pZG5jwuksuMNAr28Q5PXacCUvcUS9Iekhquyl8wpf
4kyn0v3Fba0B+rWgyb3E3rAQ2uevrg8Fk9bvg7xJ8Ug3mLQ6fnFZqAXhsUuTachE
nkYZ2YORRN1qxYzm+EMw
=LcfW
-----END PGP SIGNATURE-----

--fWddYNRDgTk9wQGZ--
