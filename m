Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab3GCOUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:20:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32962 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3GCOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:20:42 -0400
Date: Wed, 3 Jul 2013 17:19:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Subject: Re: [PATCH v3 8/8] wlcore/wl12xx: check if we got correct clock data
 from DT
Message-ID: <20130703141948.GS15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
 <1372860209-3504-9-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u+FGODhbLwgAeSOU"
Content-Disposition: inline
In-Reply-To: <1372860209-3504-9-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u+FGODhbLwgAeSOU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2013 at 05:03:29PM +0300, Luciano Coelho wrote:
> The fref and the tcxo clocks settings are optional in some platforms.
> WiLink8 doesn't need either, so we don't check the values.  WiLink 6
> only needs the fref clock, so we check that it is valid or return with
> an error.  WiLink7 needs both clocks, if either is not available we
> return with an error.
>=20
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--u+FGODhbLwgAeSOU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1DMEAAoJEIaOsuA1yqREugcP/3uTpWP5GRAs6LFNea2T0c5G
SFiWgOQuvQXE/zidY0v1cNW8bH1ka9WYN2ib3hQaFFsuuegYp64JWRda/1jrjkE2
F2h3+FqPNTenxUe9cRIY3rlQSfh4FzMUzNbNki5PlZcs2u6ruWvW2vbANoFtMvxr
M14LadV7hVzj19+fTKWjjW+ef84+lxl53VTlK4aGBWOUeLeZV4HKI9Zr6Fj78Gdn
WL2AJd5HYsZc0pg4BEMFku2Ds9qGckI0ZDmeU6vWVxHSL5jwdeiQZjW+TLPIEdd2
PkjYJT41pLrQQ0J2FNHNs881LdXIP1EQ7Zdo+d8WNsujoWjS10xjs1EnrN/tXPoo
swNM2j+1pIPKVROcyMlVBbc8bXoWFGixSYikY+X8rbhNBQpPbGWNlAvN8UY8RIMe
hA7q7jIHwf2ZygmeZbKiHUOW93R7xzc9wOoWx12+PNNt8td5eRn3hR33odLDfXqv
psVXQ6yHa5sX1Xp3zo2aHfbpgCYzh81RP8Ls+iYf268U2VKdl0FnYpwAbSTeSQRG
OKt5XkeUBRBnnXRgq0TC6jIaj33Cdaf8+ZRDu95r7I/j0mxb5Vb0JxoSE9ItMwgI
v9Z6ecFgj3CGNUYOMLFER6VkhL57ImupeDDfvRi3o9i5XX5hyuIzN0TjimJKkc8h
AirDbR8RSKCVPcNR4K50
=E2O1
-----END PGP SIGNATURE-----

--u+FGODhbLwgAeSOU--
