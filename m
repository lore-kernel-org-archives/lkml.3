Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763466Ab3IEIFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:05:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36347 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757216Ab3IEIFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:05:30 -0400
Date: Thu, 5 Sep 2013 10:05:27 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: oliver+list@schinagl.nl
Cc: arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        linux-sunxi@googlegroups.com, Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCHv7 2/2] ARM: sunxi: dt: Add sunxi-sid to dts for sun4i,
 sun5i and sun7i
Message-ID: <20130905080527.GB6180@lukather>
References: <1378204408-1415-1-git-send-email-oliver+list@schinagl.nl>
 <1378204408-1415-3-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <1378204408-1415-3-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Tue, Sep 03, 2013 at 12:33:28PM +0200, oliver+list@schinagl.nl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>=20
> This patch shall add support for the sunxi-sid driver to the device
> tree for A10, A10s, A13 and A20.
>=20
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>

Merged in my sunxi/dt-for-3.13 branch.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSKDtHAAoJEBx+YmzsjxAgz+gP/RHDB/Lwv5kkFynj21AaJL7X
EW5X+NSi6OuL6NpOF3JAzTyFFNDOF0i0G5RDeyn51AoCI2kIYAMVBXwd0mjFG3MR
iIc2XKB9Zak7qIStFmn45zQSq2Vmsb88blcP6Z+uffIZmGk95c6nQaRPBwia/Gyu
sRZulap46wLenzhFZeeOD8oho3US9FYN9LI4JecTe4xvUvvWCTPPhZndEKGtIxq9
q/Og2SI67ceIRfOjZI0/gBi4ehrYFZ6wdYOGassj+eWUSMPxpyOd0yvFloCXfErM
oVjrJorU/WG/9KaoSADCl8F5JhIaTuqr+AwB5NnNkrfnzkYCDIzPMTOQuFJnqio2
lIKbONTSZH3CK5YJvwm54SjHbDpcwNoxNbAYXdNMjj4/8ff6oD9su5GB4S9fb+UL
g7arDGADXWJuWBxMNG9aRk5UcKAhViIMeTYDw7ts+w6situnhulnShI3RrvGce1l
4O5SY8sUAhHm80eTCN/0E/Rda/pgvrijGIKi492yoTplMlr4Rjz8shPHKbCmbczi
ZhrgiT1Nh6/H2SEPNiIYljitdKIc3ORzWw3yoz3Eh/OQpjRiPX1JMkepycju3dPb
PffQFcdtXa3GqQ0KtQwLfz0VDiMFxgOA/jRGKqa78uHoIYMicWU/I2kNJcwWiTY8
rOdvsZ961a4SnsBIaGvt
=I9Lu
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
