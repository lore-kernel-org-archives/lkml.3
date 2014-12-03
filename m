Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaLCNYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:24:17 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58160 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaLCNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:24:15 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: Side effect of pressing special keys
Date: Wed, 3 Dec 2014 14:24:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201411231441.17592@pali> <201412031346.13297@pali> <20141203131254.GB20212@khazad-dum.debian.net>
In-Reply-To: <20141203131254.GB20212@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2151401.pXY5CEKPAf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412031424.12142@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2151401.pXY5CEKPAf
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 03 December 2014 14:12:54 Henrique de Moraes=20
Holschuh wrote:
> On Wed, 03 Dec 2014, Pali Roh=C3=A1r wrote:
> > Ok, and what about KEY_KBDILLUMTOGGLE when bios also handle
> > keyboard backlight level? Should be this key filtered too?
>=20
> IME, heck yes.
>=20
> If you ever make the mistake of sending to userspace something
> the BIOS/kernel already reacted to, they will find a way to
> loop it back to you and cause all sort of issues.

Ok, I think same. In KDE4 I see some loop/noop operation when new=20
dell keyboard backlight driver is used. Key KEY_KBDILLUMTOGGLE=20
cause that BIOS change brightness and also KDE4 see it and change=20
it too...

Similar problem there is with KEY_WLAN and NetworkManager.

Gabriele, can you create patch which disable both KEY_WLAN and=20
KEY_KBDILLUMTOGGLE in dell-wmi.c driver?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2151401.pXY5CEKPAf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR/DvwACgkQi/DJPQPkQ1InxACfS/kFb4SLvA6uhv0vL5gK2teL
59sAn18jezaHxSUWkzF3M8f4/u8cSd9x
=W8Ht
-----END PGP SIGNATURE-----

--nextPart2151401.pXY5CEKPAf--
