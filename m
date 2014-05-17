Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaEQXBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 19:01:15 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53089 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaEQXBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 19:01:14 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: Dell Latitude E6440 & i8k
Date: Sun, 18 May 2014 01:01:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: Jean Delvare <jdelvare@suse.de>, linux-kernel@vger.kernel.org
References: <201405162037.41782@pali> <201405162123.02112@pali> <5377818A.3020104@roeck-us.net>
In-Reply-To: <5377818A.3020104@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1596174.2dAsavLYgY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405180101.09790@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1596174.2dAsavLYgY
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 17 May 2014 17:34:34 Guenter Roeck wrote:
> On 05/16/2014 12:23 PM, Pali Roh=C3=A1r wrote:
> > On Friday 16 May 2014 21:11:17 Jean Delvare wrote:
> >> Hi Pali,
> >>=20
> >> On Fri, 16 May 2014 20:37:41 +0200, Pali Roh=C3=A1r wrote:
> >>> Hello,
> >>>=20
> >>> on Dell Latitude E6440 driver i8k reporting total nonsense
> >>> values
> >>=20
> >> That's kind of excessive wording, the output isn't that
> >> bad.
> >=20
> > I mean fan RPM & temp4. Those are for sure incorrect.
> >=20
> >>> $ sensors
> >>> i8k-virtual-0
> >>> Adapter: Virtual device
> >>> Right Fan:   93450 RPM
> >>> CPU:          +57.0=C2=B0C
> >>> temp2:        +57.0=C2=B0C
> >>> temp3:        +40.0=C2=B0C
> >>> temp4:       +127.0=C2=B0C
> >>>=20
> >>> Right Fan and temp4 are for sure incorrect.
> >>=20
> >> Driver is reverse-engineered so this is best effort and
> >> some tweaking may be needed.
> >=20
> > Ok, if driver is developed without any documentation, then
> > it make sense that not working correctly on new machines...
> >=20
> > So is not there any documentation? I think that Dell
> > released some SMM/BIOS code... But I'm not sure about it.
>=20
> If you find it, please let us know.
>=20
> Guenter

Now I remembered... Dell has released info about their smbios
extensions with example programs at:

https://linux.dell.com/libsmbios/main/
https://linux.dell.com/cgi-bin/gitweb/gitweb.cgi?p=3Dlibsmbios.git;a=3Dsumm=
ary

But there is nothing about fan control or temperature.


Also I found smbios specification:

http://www.dmtf.org/standards/smbios

There is something written about fan and temp, but no idea if it
is usefull for something...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1596174.2dAsavLYgY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlN36jUACgkQi/DJPQPkQ1KBmQCfZoVo35XrffiKZutQMsJJpVbE
8CMAn1/z0sy/64jMPqbieCv6KiJ7fM3N
=7hnU
-----END PGP SIGNATURE-----

--nextPart1596174.2dAsavLYgY--
