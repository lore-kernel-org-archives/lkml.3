Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaKXW1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:27:17 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45235 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaKXW1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:27:16 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Mon, 24 Nov 2014 23:27:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Mark Rutland <mark.rutland@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201409051552.05447@pali> <CAOMZO5BtUaYbQUhidgyPBFdARsFY=uYySYqXXmFEfPL8qTBbfQ@mail.gmail.com>
In-Reply-To: <CAOMZO5BtUaYbQUhidgyPBFdARsFY=uYySYqXXmFEfPL8qTBbfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4822613.WUXRyPshlM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411242327.13398@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4822613.WUXRyPshlM
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 05 September 2014 15:58:34 Fabio Estevam wrote:
> On Fri, Sep 5, 2014 at 10:52 AM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > So what is your suggestion for identifing board (name/type)
> > which will work with any kernel (and will not be broken
> > again by kernel later)?
>=20
> $ cat /sys/bus/soc/devices/soc0/machine
> Freescale i.MX6 Quad SABRE Smart Device Board

This output is on Nokia N900 useless:

$ cat /sys/bus/soc/devices/soc0/machine
OMAP3430/3530

It does not specify that this is Nokia N900 (RX-51) device but=20
only some generic omap board.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4822613.WUXRyPshlM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRzsMEACgkQi/DJPQPkQ1IvKQCgkqt9BKN1GMLWlUkOJCGDxk3C
XHEAn0ylnFRFNhoYcSZr1CXZHeiK2gLp
=46me
-----END PGP SIGNATURE-----

--nextPart4822613.WUXRyPshlM--
