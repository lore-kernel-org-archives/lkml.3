Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458Ab3DBJiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:38:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52837 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761355Ab3DBJh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:37:28 -0400
Date: Tue, 2 Apr 2013 11:37:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: imx: Remove enabled field from struct imx_chip
Message-ID: <20130402093721.GC4416@avionic-0098.mockup.avionic-design.de>
References: <1364741987.3834.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <1364741987.3834.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4CnVb5hWapTVRUK5R0qtyPlHJdiQe93xqeCVUCIVmUf
 7P0jzVfWnoQxElzuFsaBNSpplGkxwgZIoSgvo3UzldtyO4I2FZ
 IxhdY+D90QmdH/1KgqSb0MU/dtOR8InloxXTjX8E0tx1vzz4Yz
 4/Mx6Wo5cih4HnGPJ2EiXR5xVUgeSCzE1lFaQqmqQiukiTgGhd
 A2ill0v3TVDnAriu52ab49Ib6Y1V4QSm6gaaBpqrevEtlhFi/i
 bpyfzTsMuJ6ZLnPmIsK10Rq0xdqelbUYstOo1gRuZwVp71H0p1
 8FSRl10HF+5Mubb+NB1i7BL8CyxzP607VZ9huBWO0No5WLBB0V
 +U8iLE6dIUpr3d2b+BrOKLSUnRmK8gm3xKP9157fwBY6xCJ/dp
 DMwMmWqxcyepfYxE5Nwq7dOprr6/O3Cbv+aNcLDWO9MTVtdCgg
 kgy4z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 31, 2013 at 10:59:47PM +0800, Axel Lin wrote:
> We can test PWMF_ENABLED bit to know if pwm is enabled or not.
> Thus remove enabled field from struct imx_chip.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-imx.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

All 3 patches applied, thanks.

Thierry

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRWqbRAAoJEN0jrNd/PrOhRUoQAJsNVDpMZUe3PApMZCtNjpvi
RfAw9GnPT038wIGhgUdHJScA1WJDxTubhKlECQwjtFdK/XMw1Ae/0j6zmE9CoVKB
YqDfbzwgZ2u/P97ZWWgS92SJsYZa+WlwiZNgLO2M1+U3hLk3kydlFIt6LYDr2adO
xSC1kgm1IuKoT/Aj/aNwFoypfDRdCI6ooCAfO5mzea3kM4BN1SKGcF+NjH6KMtPk
pTM+MBEJeldh2M+7BCRZ15II4tcVMTYm3UeZdHTC9nChvWzD99Hk51/axS4JhXBA
O5sus5plR9WgziCzwrDPQUNJRq3hRWyWTaRkhtcnDbm1zQQfx6bejgd2Ko8BLCrP
aHNoYPWlIUJa2LYM8OvH4hS7Ssr4PJgpdKfEB1adh15Kef3jB0T4A6knZumib68E
1DQCI82QAwPz2Ah48WbSu2mhaWvzecgPeVyOqKtzF7nz1jHtzWnI5TwRqBKMcokT
vjJXSGmmAjctUMmiBjFKT3kiSLERxd20vWBqx8EVx1GuW4bo5QhuN12fsQTt1DMg
beBv0aO71yjnkhCGP08WpSUTK73TTpu1/2AfU8lXxE2zQKa2+w7NRfidEAKz958h
QGHGgpyWFeOAN+nr65Ypp4d4RDfPEoWiTrM61Vi8Oldp7MgFFlQq/dHvQbg/QPfk
XK3ulOEXUfaStu7JqtdJ
=EvG/
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
