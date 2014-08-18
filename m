Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaHRRzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:55:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54645 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbaHRRzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:55:05 -0400
Date: Mon, 18 Aug 2014 19:52:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dt: sunxi: Remove i2c controller clock-frequency
 that matches default
Message-ID: <20140818175253.GF15297@lukather>
References: <1408383945-27940-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDyw1yV8HuEtd7LH"
Content-Disposition: inline
In-Reply-To: <1408383945-27940-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eDyw1yV8HuEtd7LH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 01:45:45AM +0800, Chen-Yu Tsai wrote:
> The clock-frequency values of the i2c controller nodes match the
> defaults of the driver. Remove the properties to use the defaults,
> and be consistent with sun8i.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Merged, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--eDyw1yV8HuEtd7LH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT8j11AAoJEBx+YmzsjxAgEJcP/jKeqRHa/F5NuLK9r6xjSj5e
KEcHrh/oUeo1F1pbBH82ePVlNzVfq7Nrjyq1MceYj+SApgYdibllalF29dg6exMy
2XhsbIvz4mMoZpkI7ygMUgYO8hpP+jkHBcavO9uuh9OgZ7ZPS2jLi8iIwtHkFbi2
ylZDKT7nqvL8hVEPVNNBQW/ZDiwywlt/7Jr5Vf5Q4FlpXsMpxijAgXlNBeCCZdgc
Le6EmyPlPKSL8GfmvdryyGhZljZ7l17wQb27uubJR+80kbzVd6dKHt6Jhn5H8mWR
FSfdLia25179HPUmzC1oOtMfFqqnILzz/B0dgZcFO1weuXKeCCXWvFPqkcAEc0zs
9SZR/4HezVEKy4QA1x6GKDY3du0E+CUDL+gTpwmYMTmHvkR3LCvsnyUjeBTB6LJx
AOrbHyQt9zvm5kleMngHa6XmSVFe074ReRDYxlWB0mnFjenC/8PDGhCN3BGjdbm2
mK2wxDtlDTelNgphQctm8k/ff1MZeo5F3KLljEI0J63zlhwoci/Mp+4gFIMHHd+B
a4vvF7CV5LH/HK0VuACWVvUv1uscYaEBOA7rml04UAw0+x5AE960dTDY0jV/OyBx
POmgwKjIBnbcOYXmsHBpaXDDlfe5s4wNytLMpHBWFtGUDR7FICMDAM1dsG0nSeCL
qzYo4TJnEU0VfGB7xgrs
=2SV1
-----END PGP SIGNATURE-----

--eDyw1yV8HuEtd7LH--
