Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaFWLPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:15:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43407 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaFWLP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:15:28 -0400
Message-ID: <53A80C4B.1060807@ti.com>
Date: Mon, 23 Jun 2014 14:15:23 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 68328fb: remove check for CONFIG_FB_68328_INVERT
References: <1401214147.28714.12.camel@x220>
In-Reply-To: <1401214147.28714.12.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="gv6Ve43MFfn44l7lLK2R5PjIOVE0ujMgv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gv6Ve43MFfn44l7lLK2R5PjIOVE0ujMgv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 27/05/14 21:09, Paul Bolle wrote:
> Since v2.6.7 the 68328 frame buffer driver contains a check for
> CONFIG_FB_68328_INVERT. But the Kconfig symbol FB_68328_INVERT was neve=
r
> added to the tree. Remove this check and do some related cleaning up.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

That sounds like something which should be configured per board/panel in
any case, not something configured via kernel config.

Queued for 3.17.

 Tomi



--gv6Ve43MFfn44l7lLK2R5PjIOVE0ujMgv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqAxLAAoJEPo9qoy8lh719WUP/2xkhecfCqa4ytQZDihvXPOd
3MGbLEUQLv9fEuebdX7WAOcZ0T5YRKSzQomzt0fvOli2RoigAUrqeGIi9hLr0Brs
mqcbqN5yFw51fWHvXajRbDJ8FqEkT2tXPJIRbU/s0m6x6bFTOw/i1LWeYh3Dc7w7
HuTGnSnuUfUDyC+8HAn2NsIGg+GazwFlVlSLBR7JL/tgTc0YZwnUBZhxt3V79YAR
ROrNQvuHcK10q4y2g9gdEMBRv+JoH9xP7cAiBOdWwa7alCOejA3eXhiCgfyom8mc
WIOEVXx4LMNQtWsl27uBGk0sHeDC7BWOL1MFhpGxulLF9FGyHjR0830ha58/4DHh
gfSz29u5rAOP5+Fm35BNQJPCVzYWnlwduix4cY0m6vVC5gBgKkmftr1fSqh0ixnL
XBaL7ZPMse96//7xcboGH2ovuDP8CuUugF0b6S9SiGmCBFs1UCFKlcFy0vDritnH
S3pd6rYXInYkktnDO43VraCMI3cHH0GKgdmwBAEAWDAaRJLFDnR2UFC92oVIpgEp
5QqMIsYJT5TxQqjo3ghv2+xiHXD5g5R/bOMYpZLpZf0qq715g5JagJxYvEj0i+RK
IhaHlnhoyC5ZKn56D8Evw9bE6SKFQ3qIr3dPCnzwBRwdjei8CPl/KCz/XDZt9Q8v
cLFMA6aLaDZXlccNlEkh
=GEcn
-----END PGP SIGNATURE-----

--gv6Ve43MFfn44l7lLK2R5PjIOVE0ujMgv--
