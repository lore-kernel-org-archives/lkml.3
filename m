Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaGWMFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:05:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:38490 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaGWMFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:05:30 -0400
Date: Wed, 23 Jul 2014 14:05:24 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Gregory Fong <gregory.0xf0@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Matt Porter <mporter@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v9] power: reset: Add reboot driver for brcmstb
Message-ID: <20140723120523.GB18172@earth.universe>
References: <1406072883-16035-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1406072883-16035-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Brian,

On Tue, Jul 22, 2014 at 04:48:03PM -0700, Brian Norris wrote:
> Add support for reboot functionality on boards with ARM-based
> Broadcom STB chipsets. Make it built-in by default for ARCH_BRCMSTB,
> but allow it to be configurable under COMPILE_TEST.
>=20
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> ---
> Hi Sebastian, can you merge this, or else defer this to Matt?
>=20
> This driver is mostly unchanged for a while, but it hasn't gotten an Ack =
=66rom
> any PM guys. It is now separated from the rest of its accompanying series:
>=20
>   https://lkml.org/lkml/2014/7/21/647
>   https://lkml.org/lkml/2014/7/21/801
>=20
> The DT bindings have gotten review somewhere in the course of 8
> versions.

applied to battery-2.6.git:

http://git.infradead.org/battery-2.6.git/commit/030494e75064cb4fcbeb609d845=
ae0c9ceade2b9

-- Sebastian

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTz6UDAAoJENju1/PIO/qakrEP+wUvvGywbUbPZfz5CBEiXSoR
Ph/6ZwjSP7NMdbiML91Sg46N1y/0JbXaiSn3z7jsUZQOjqOxTDBy765nOCupp9Kt
dZs5e7ZvY0dyav+XhwParkbxTOdalAqLD9T0ze/xXnoO2MBww5uu+mDuFOUgoVaP
ZM5URRHXFpdzVjwDAQNh1YdwIsBie8xZct2uLoY1lAuXlGwKXL2cTBCjzrDiN3Bc
zw25Wnjrl2hHyWf1Wc11keS8vu32p2fJYTy2st4lfcDuA8ySEmWOz38COoAbAsJ2
t2JlotqqZbceRbdzpLkh5SKu1yUNwmovhV8JL/LoMrnrBFl4E3U3xZJkwCrqTs3o
SCYTLhy+ZdScXIlEG3Kzq74Sng7QRkI40sWGHW63bTHnuTxQWi7sj3dsNouxTaKa
y3bnyJChRu7aEH676PZF3YP4n2opDo+RfUJjMYRzrCKIsWWe23IeIVjUnGDJwvQo
L73zb7JKYQl8GmkR8PDcwVEDl0cfNQmTGubXyntbkos3J6oFUqLhyu7UvoWRNVeI
IG7a+bw4z0aaBMG5SlUC0n7HWmR8M9aeYlhjmh8UOTh/p6g9T+Q0pOStgLoqBAuK
WR4Y4/wbtsBzJ67ByUYqF7nxdxT15W9QBpvzMk6LL7+skNQgr4Ymd7HaeGARHVYW
G3BssnFFKkZDLPRvr18Z
=S3rf
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
