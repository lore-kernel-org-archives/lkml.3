Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3JKWHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:07:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53230 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755505Ab3JKWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:07:23 -0400
Date: Fri, 11 Oct 2013 21:15:27 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: wim@iguana.be
Cc: linux-arm-kernel@lists.infradead.org, carlo.caione@gmail.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wdt: sunxi: Fix section mismatch
Message-ID: <20131011191527.GO3041@lukather>
References: <1380982817-10234-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zipuvUKAEymKn2g"
Content-Disposition: inline
In-Reply-To: <1380982817-10234-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zipuvUKAEymKn2g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

On Sat, Oct 05, 2013 at 04:20:17PM +0200, Maxime Ripard wrote:
> This driver has a section mismatch, for probe and remove functions,
> leading to the following warning during the compilation.
>=20
> WARNING: drivers/watchdog/built-in.o(.data+0x24): Section mismatch in
> reference from the variable sunxi_wdt_driver to the function
> .init.text:sunxi_wdt_probe()
> The variable sunxi_wdt_driver references
> the function __init sunxi_wdt_probe()
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

It would be great if it could go in 3.12.

Do you want to take it, or can I merge it through my tree, with your
Acked-by?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6zipuvUKAEymKn2g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSWE5OAAoJEBx+YmzsjxAg070P/34Lh0wcnhpQopBznTdf88RS
52Sv7801syi3mEm3MSlrGcYECWGpwam2xgd13gRICCHDSiDqXsKvjWXTy0rluHXV
JMTdIgG9Jcvv3QbtrIKxlRwwOf5G1gLLONSOEbHIrDauXukopzPFN+SkWGoGRaRw
gezJg1DFS3LZzJj4NjFR+JBeY7dJsnJrlmiT83qC+4oVeVTODl8RazzfQ2phEmm2
6vit3OidzcHM0F8Dadz1aM36Cs+cUZRLTpVh99WKRRSe+r36sFqx0SRb/zGeTcRH
ZDmkLrRZ+FVgdtFtZUn1tNbbkDIQABmJ5DfVNSn3VDL06pNH5HymNc8g4akDYpQU
KfEnML/WReE7LKRVOMdVMgILxfWx6PqUZWZOLzsAnUFqsEuecdXddlvCAdqLNDSq
Od8ktf71kFegubxku1OFEVsX1JmtZQTA+3+AR6FbAKmfpnjUbRHak9DO01AnVeOQ
ZysApcDnOgqRXHfJ5izKCtM46+fQqJtgNaAgO1va8Jwe2nwPM2G4L5ZEWs2GPYOs
EMyM69BiAYWEfIE1XlhIVR+IOMEACxobr8fLDS/On5ss6AulBPvgUL5JqrwRcP2m
/3NyIlJ/zt+3mwKe/RQgWq0KegOH4r+bI7izdWRPsJUyW5aEbLYKMnVl3UUfNjXI
Q6mR6dSlzZ09H4ItgjYh
=vFcC
-----END PGP SIGNATURE-----

--6zipuvUKAEymKn2g--
