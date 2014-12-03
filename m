Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaLCNk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:40:56 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54989 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaLCNky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:40:54 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: Side effect of pressing special keys
Date: Wed, 3 Dec 2014 14:40:50 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Pavel Machek <pavel@ucw.cz>,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201411231441.17592@pali> <201412031424.12142@pali> <2102451.ffMsF9xTEG@xps13>
In-Reply-To: <2102451.ffMsF9xTEG@xps13>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1825629.9G8UqXzRcs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412031440.50755@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1825629.9G8UqXzRcs
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 03 December 2014 14:38:15 Gabriele Mazzotta wrote:
> On Wednesday 03 December 2014 14:24:11 Pali Roh=C3=A1r wrote:
> > On Wednesday 03 December 2014 14:12:54 Henrique de Moraes
> >=20
> > Holschuh wrote:
> > > On Wed, 03 Dec 2014, Pali Roh=C3=A1r wrote:
> > > > Ok, and what about KEY_KBDILLUMTOGGLE when bios also
> > > > handle keyboard backlight level? Should be this key
> > > > filtered too?
> > >=20
> > > IME, heck yes.
> > >=20
> > > If you ever make the mistake of sending to userspace
> > > something the BIOS/kernel already reacted to, they will
> > > find a way to loop it back to you and cause all sort of
> > > issues.
> >=20
> > Ok, I think same. In KDE4 I see some loop/noop operation
> > when new dell keyboard backlight driver is used. Key
> > KEY_KBDILLUMTOGGLE cause that BIOS change brightness and
> > also KDE4 see it and change it too...
> >=20
> > Similar problem there is with KEY_WLAN and NetworkManager.
> >=20
> > Gabriele, can you create patch which disable both KEY_WLAN
> > and KEY_KBDILLUMTOGGLE in dell-wmi.c driver?
>=20
> KEY_KBDILLUMTOGGLE is actually disabled already, but KEY_WLAN
> (which I guess it should changed to KEY_RFKILL now that it
> exists) isn't, so I will submit a patch. The comment above it
> in dell-wmi.c makes me think that for all the systems the
> BIOS does everything and not only mine.
>=20
> Gabriele

KEY_KBDILLUMTOGGLE is not disabled for sure. I see it in log from=20
input-events program.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1825629.9G8UqXzRcs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR/EuIACgkQi/DJPQPkQ1JlDgCfW7liiziat19KiiUT63xBOmvC
lIQAoMeCTh/uNRuPIS9bFmM7aSFm3UKH
=KKET
-----END PGP SIGNATURE-----

--nextPart1825629.9G8UqXzRcs--
