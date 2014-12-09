Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaLIUjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:39:36 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37908 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaLIUjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:39:33 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 1/3] i8k: cosmetic: distinguish between fan speed and fan rpm
Date: Tue, 9 Dec 2014 21:39:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1418155621-21644-2-git-send-email-pali.rohar@gmail.com> <20141209202304.GB22176@roeck-us.net>
In-Reply-To: <20141209202304.GB22176@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1656747.372KvTXkKk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412092139.29655@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1656747.372KvTXkKk
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 09 December 2014 21:23:04 Guenter Roeck wrote:
> On Tue, Dec 09, 2014 at 09:06:59PM +0100, Pali Roh=C3=A1r wrote:
> > Driver mix speed and rpm. Fan speed is value (0, 1, 2) which
> > is used for configuring fan. This patch change comments,
> > function names and other definitions so code should be
> > unambiguous now.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> > This patch is cosmetic and does not bring any change to
> > code.
>=20
> For me "speed" and "rpm" are synonyms. So you are not really
> clarifying anything. If anything, you make the code even more
> confusing.
>=20
> Guenter

Ok, what do you want to use instead "speed" and "rpm" to make it=20
clear? We have function which returns RPM and other functions=20
which get/set fan speed value (which is 0, 1 or 2). And new=20
function (from patch 2) returns nominal RPM for fan speed value.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1656747.372KvTXkKk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSHXgEACgkQi/DJPQPkQ1I5UwCghp4HxXvki9SiSLA/eDCN00sn
NzUAn3MHBsEmUn1lWXG0aaW4KY5OLVJo
=+/oj
-----END PGP SIGNATURE-----

--nextPart1656747.372KvTXkKk--
