Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161150Ab3DFVK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 17:10:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58803 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab3DFVKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 17:10:54 -0400
Date: Sat, 6 Apr 2013 23:10:42 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Prisk <linux@prisktech.co.nz>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: PWM backlight build warning
Message-ID: <20130406211041.GA15987@avionic-0098.mockup.avionic-design.de>
References: <51606A7F.3050803@prisktech.co.nz>
 <20130406200251.GO6597@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20130406200251.GO6597@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fDPJ5qR9yhXc79GTYjWQc5pSA7A/9cV3i+tp4sm13Og
 GluF5U58QEwKqZQ4XkJmhGqy/OtqC3shpVRcruIuZJFpWz10OP
 Dets66KUjzoZ05+3m6R0yQtANogBtYa0zQZ0wI2+cX5vDJ6MKX
 U2y/2zqcVY2uRiHaR0H87hlHpsZ9lLNS9KVOQ2YgDSQjJm6rf2
 cBsOVNPKUdKS5aNmXYSX2aU3bera0W48OcTOiiaQJnf5ItnJIY
 f2WSfHGoGG86ZrqAEBdsRm6hOHUSnT706Fct0R1HjbsM67XLYM
 qXPktMcLIemtj+dU2CNNb08FCZc6OFgdtgbOYLGo2hRCqS8zzu
 JbmQFjr/d8MkXk6AyumGsKyOLvjci5QfGrmPiv8CzoBWiZULtJ
 8AbwLvxBogC3X1Js/jhl0QRH+d0EJwFMis=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 06, 2013 at 09:02:51PM +0100, Mark Brown wrote:
> On Sun, Apr 07, 2013 at 06:33:35AM +1200, Tony Prisk wrote:
>=20
> > The problem occurs because when CONFIG_PM=3Dy but CONFIG_PM_SLEEP=3Dn:
>=20
> > I guess this would be a problem on every driver that has been
> > converted to SIMPLE_DEV_PM_OPS.
> > I don't know enough about the PM code to offer a fix, or whethermy
> > chosen config is just 'invalid'.
>=20
> You just need to put the system suspend functions inside an ifdef
> CONFIG_PM_SLEEP instead of CONFIG_PM.

I carry a fix for that in my for-next branch.

Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRYI9RAAoJEN0jrNd/PrOhY2kP/iV0O0N13vOO6vki9go78x7y
kyZNHy+AqyxZYJ6RX3nHBIcHH44NeKJopzLkaTOnPQW4mxCgSxUqLUcNZ+ad2BlS
xgtOUYTEt3m2EgdhAte/bcSmBU9uF+1mTKL+mqrk3QGuC/uoMCHMGnm8dMxOplWW
b3VcBELbEZxxiKU9x8tMvU7ndWHKqSh/SOg9xe56YGR3ZuFN5+9VJc149b3i16hp
t5mPE6MaGhEJgNpP7EWNhnWSJfZcpC5w5yfRYXYbS8cG/qvoAVrm4Utkuam8YbRv
NpCPDNAxcmspQdT+oTZX41FD/oLT3+ISzWqYH4y9zZ/A5P+jIsLSw5upnGBtiwAL
tZ+vRtjpM0nQ61TheoAXjOaKCfXBJsL23S/MZ3plZt6BAOtdTpuPkUKpsTNgKsJy
letM78zXtqo4nzxC1mMcf8fFz4/HnkQl0WUtqv3O0bQFdKslzt0jsOmK38vNOwEH
iSxbxJB1PELPE3+bqoDWcrD8yhwxFikvBXTfwa+dnuKFHm5Ey8V2JgaLWR/Yguqb
dgjsv5D6FbWWHhOQXd341gL8KFZdCoVObEXb7sE0Mbr8G3lEs1je2PAHryOalnNc
oWyfRBCJNJYF/CrPJ4sApkHK5wcCmBjDfGveREoWVc7v67Qjyf/7c6WwYJrlTkmy
qM32am8MDF/0WiFNka2I
=d2ul
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
