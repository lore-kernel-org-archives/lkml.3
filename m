Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbbAULqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:46:39 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39026 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbbAULqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:46:30 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] bluetooth: Add hci_h4p driver
Date: Wed, 21 Jan 2015 12:46:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>, Sebastian Reichel <sre@debian.org>,
        Sebastian Reichel <sre@ring0.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "linux-omap" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
References: <20141223130219.GA5731@amd> <7522CAC7-AFD9-470F-B4F8-3C39942DBC04@holtmann.org> <20150121110131.GA19792@amd>
In-Reply-To: <20150121110131.GA19792@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2668218.qebEoV65DQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501211246.27449@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2668218.qebEoV65DQ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 21 January 2015 12:01:31 Pavel Machek wrote:
> > > Strange, where do you see DOS style line breaks?
> > > Checkpatch here does not warn about that, and they really
> > > should not be there.
> >=20
> > If that would be the only pieces, then I would have fixed it
> > already. That is not the big deal. The rest of checkpatch
> > is what I am not going to fix for you.
>=20
> I can fix the checkpatch, but I'd like to understand how ^Ms
> got there, because otherwise it will happen again.
>=20

IIRC lines in email according to RFC2822 specification must be=20
delimited by CRLF. Maybe this is reason?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2668218.qebEoV65DQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlS/kZMACgkQi/DJPQPkQ1KHNwCgirb0YAu/ipLdvsiz3UwuHR+y
PYIAmweevr4kH+u6tyK2tvaHab42Ewdw
=/x02
-----END PGP SIGNATURE-----

--nextPart2668218.qebEoV65DQ--
