Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab3KZRaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:30:22 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:60518 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3KZRaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:30:19 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Date: Tue, 26 Nov 2013 18:30:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        freemangordon@abv.bg
References: <201311191151.17153@pali> <201311261810.22885@pali> <20131126171748.GA26429@earth.universe>
In-Reply-To: <20131126171748.GA26429@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3901587.ouW1Ddytvl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311261830.15806@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3901587.ouW1Ddytvl
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 26 November 2013 18:17:49 Sebastian Reichel wrote:
> On Tue, Nov 26, 2013 at 06:10:22PM +0100, Pali Roh=C3=A1r wrote:
> > On Tuesday 19 November 2013 11:51:12 Pali Roh=C3=A1r wrote:
> > > For a long time (since 3.5 or 3.8? - I do not remember)
> > > obex subdriver in g_nokia usb gadget module causing
> > > kernel panic after module is loaded on Nokia N900. I do
> > > not know where is problem and due to immediatelly kernel
> > > crash when loading driver I was not able to see any dmesg
> > > output. Now I was able to store something into mtd log
> > > and here is crash backtrace: [...]
> >=20
> > Hi! can you look at this problem?
>=20
> So it worked at some time?
> Have you tried to git bisect the problem?
>=20
> -- Sebastian

Yes, if I remember it worked with some older 3.x kernel. I do not=20
know if I still have old tree. But there is problem with=20
bisecting, because booting older kernel is hard on n900... At=20
lest on 2.6.28 kernel g_nokia.ko working fine.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3901587.ouW1Ddytvl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKU2qcACgkQi/DJPQPkQ1KIwwCgk4TExo5amEPSR/aHanPNqMka
SlkAoLtn45gM8xasN/nn1b/CVmecCc45
=s4O4
-----END PGP SIGNATURE-----

--nextPart3901587.ouW1Ddytvl--
