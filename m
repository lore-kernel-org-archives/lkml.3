Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3DYK6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:58:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59447 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778Ab3DYK6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:58:19 -0400
Date: Thu, 25 Apr 2013 11:58:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: grant.likely@linaro.org, yongjun_wei@trendmicro.com.cn,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi-topcliff-pch: missing platform_driver_unregister()
 on error in pch_spi_init()
Message-ID: <20130425105817.GP5019@opensource.wolfsonmicro.com>
References: <CAPgLHd-QZXdb39icvhUKWm+hCT4O2dnF5kPAmPeaxXPsU8MMNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6kpOI20Kt7FNSDww"
Content-Disposition: inline
In-Reply-To: <CAPgLHd-QZXdb39icvhUKWm+hCT4O2dnF5kPAmPeaxXPsU8MMNA@mail.gmail.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6kpOI20Kt7FNSDww
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2013 at 03:18:02PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Add the missing platform_driver_unregister() before return
> from pch_spi_init() in the error handling case.

Applied, thanks.

--6kpOI20Kt7FNSDww
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJReQwlAAoJELSic+t+oim9pHgP/R3m/Krdj/jiI+c5/46aTZou
gQoAoy0Wh0QkdTxiAHJgGtjAol386oB6VGN17am0Bz9bXm+l/RxRlIwwP7gP9GAi
yk9+sx/K6ucSXeU5rJ/zGCoFG9RrIIBbZsp0sbVzNUpegf7kzSHc5j+1qbaYQI72
+FIPnP9pqjorzNtBnXAny4XVBSpCcYzhLhNcJWmyXlV0slF0aBi8r7+iBSUipyqS
6r+ni4lYzfuRXL+fsVXaM49nDdMzAPf0ZMVdqXnSF1MJVU23eowMDzpdFVrETnWH
xGSQ1s7syzmwnbs13uBDZZyNr4s+nyG9f/PIcxPVb1QzSfchTQ1CsSXOfi4jAppZ
MRQmwVMsE2Lb5cjc/SBdsp2Pa4bhAsq4FGzwTP3GfkWeSromJC/AzIeuAfU0mUzn
ILKP8dYcLC0XzMTYYLBPJ0iD3OV1kwNld9UATpCfuJLGLIiMzyzq5+SXAMr/kIEL
yyOmZFuIciEM7aQJ7no8yV/wJbhc08cNuKlqQnKkMLfrVk/42yGAGGgXouLThLqt
gJWPXNBm66yhRMxk2SyclEM/5NfuI37KNiMJoh73O+OSF1iqwnarJawDWmM+SriG
jSAMZ9mzHgBxKSwoYs4jihHfZ6ICnKNhM9eUWf0qZONuZrJu8vs8fBbIjZaiyEAL
N0TqeyyMF36nJ85sSY4r
=gA7X
-----END PGP SIGNATURE-----

--6kpOI20Kt7FNSDww--
