Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaK0UjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:39:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61979 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750875AbaK0UjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:39:15 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Missing MODALIAS in /sys/devices/system/cpu/uevent
Date: Thu, 27 Nov 2014 22:00:32 +0100
Message-ID: <2091767.N6CqySqsKt@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9796230.2QoPTQHj6x@vostro.rjw.lan>
References: <201411272101.11811@pali> <1892529.CzZLJuFW6x@vostro.rjw.lan> <9796230.2QoPTQHj6x@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4383351.PXy3BS1Svt"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4383351.PXy3BS1Svt
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday, November 27, 2014 09:59:03 PM Rafael J. Wysocki wrote:
> On Thursday, November 27, 2014 09:56:56 PM Rafael J. Wysocki wrote:
> > On Thursday, November 27, 2014 09:24:30 PM Pali Roh=C3=A1r wrote:
> > > On Thursday 27 November 2014 21:39:42 Rafael J. Wysocki wrote:
> > > > On Thursday, November 27, 2014 09:01:11 PM Pali Roh=C3=A1r wrot=
e:
> > > > > --nextPart2712852.Yg3XtZvm05
> > > > > Content-Type: Text/Plain;
> > > > >=20
> > > > >   charset=3D"utf-8"
> > > > >=20
> > > > > Content-Transfer-Encoding: quoted-printable
> > > > >=20
> > > > > Hello,
> > > > >=20
> > > > > on 3.18-rc5 I have empty cpu uevent file, but modalias file
> > > > > is=3D20 populated. See:
> > > > >=20
> > > > > $ cat /sys/devices/system/cpu/uevent=3D20
> > > > > $ cat /sys/devices/system/cpu/modalias=3D20
> > > > > cpu:type:x86,ven0000fam0006mod003C:feature:,0000,0001,0002,0
> > > > > 003,0004,0005,0=3D
> > > > > 006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,0013,
> > > > > 0015,0016,0017,0=3D
> > > > > 018,0019,001A,001B,001C,001D,001F,002B,0034,003A,003B,003D,
> > > > > 0068,006B,006C,0=3D
> > > > > 06D,006F,0070,0072,0074,0075,0076,0078,007C,007D,0080,0081,
> > > > > 0082,0083,0084,0=3D
> > > > > 085,0086,0087,0088,0089,008B,008C,008D,008E,008F,0091,0093,
> > > > > 0094,0095,0096,0=3D
> > > > > 097,0098,0099,009A,009B,009C,009D,009E,00C0,00C5,00E0,00E1,
> > > > > 00E3,00E5,00E6,0=3D
> > > > > 0E7,0100,0101,0102,0103,0104,0120,0121,0123,0124,0125,0127,
> > > > > 0128,0129,012A,0=3D 12B,012D,0140
> > > > >=20
> > > > > =3D46or all other devices in /sys/devices/ which have
> > > > > modalias=3D20 content there is also MODALIAS=3D3D line in
> > > > > uevent file.
> > > >=20
> > > > /sys/devices/system/cpu/ is not a device.  It is a "collection
> > > > of all CPUs".
> > > >=20
> > >=20
> > > Ok. But why that inconsistency (missing MODALIAS line)?
> > >=20
> > > > > Is cpu device special? Or why it is only one device which
> > > > > has=3D20 modalias file but is missing MODALIAS=3D3D line in
> > > > > uevent file?
> > > >=20
> > > > Look into the uevent files under /sys/devices/system/cpu/cpu0/
> > > > etc.
> > > >=20
> > >=20
> > > $ cat /sys/devices/system/cpu/cpu0/modalias
> > > cat: /sys/devices/system/cpu/cpu0/modalias: No such file or=20
> > > directory
> > > $ cat /sys/devices/system/cpu/cpu0/uevent=20
> > > DRIVER=3Dprocessor
> > > MODALIAS=3Dcpu:type:x86,ven0000fam0006mod003C:feature:,0000,0001,=
0002,0003,0004,0005,0006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0=
011,0013,0015,0016,0017,0018,0019,001A,001B,001C,001D,001F,002B,0034,00=
3A,003B,003D,0068,006B,006C,006D,006F,0070,0072,0074,0075,0076,0078,007=
C,007D,0080,0081,0082,0083,0084,0085,0086,0087,0088,0089,008B,008C,008D=
,008E,008F,0091,0093,0094,0095,0096,0097,0098,0099,009A,009B,009C,009D,=
009E,00C0,00C5,00E0,00E1,00E3,00E5,00E6,00E7,0100,0101,0102,0103,0104,0=
120,0121,0123,0124,0125,0127,0128,0129,012A,012B,012D,0140
> > >=20
> > > So there is no modalias file, but uevent contains MODALIAS line.
> > >=20
> > > > > What userspace application should use for reading
> > > > > modalias=3D20 string? File modalias or file uevent?
> > > >=20
> > > > The cpu modalias is used to trigger loading of some
> > > > CPU-specific modules upfront IIRC.  So yes, it is special.
> > > >=20
> > > > My advice would be to follow udev here.
> > >=20
> > > Yes, I know. For some reasons coretemp.ko is not automatically=20=

> > > loaded. I do not know why and I started investigating it. And I=20=

> > > found above inconsistency in modalias and uevent...
> > >=20
> > > $ modinfo coretemp
> > > ...
> > > alias:          cpu:type:x86,ven0000fam*mod*:feature:*00E7*
> >=20
> > That may be a udev issue.  See
> >=20
> > http://lists.freedesktop.org/archives/systemd-devel/2013-July/01216=
5.html
>=20
> And it was fixed in udev quite some time ago.

By this commit:

http://cgit.freedesktop.org/systemd/systemd/commit/?id=3Dbf7f800f2b3e93=
ccd1229d4717166f3a4d3af72f

--nextPart4383351.PXy3BS1Svt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUd5DwAAoJEILEb/54YlRxFDgP/2bqJmb2yhwYkeXxdCj7wgIu
XX178H+iTX5wlRa3kwnIuscz+fe5Qry3I3R+y7lIru00zd5QlwsonL/FGU0ON/T5
ZzUPm7BH16qJau+2iLh4TmtJYE3Rp7usccmPBpuxoJ7Uxk0DQO0mk+s31J+9NKg1
L0xM1g0784DkHr/yRwwiVBxInQfGqHpX1KQXfJSS2b3l7rBOclGCkdXQCcLqH9r8
VzFWYoFA9Dfww0wtW0oNGQt7KM0dSzdDviJXEcruiqDEIiW6AtfMS1B4QSHvfZCA
wIAHU79qR4fRqv4irVuGhXyx4miwX/QOGrpE6h3dTtJjVAJv7owaZxl20kWWZac7
4QH4lHuipVXD/A/GbnZSDuGjTwTflQEp9P9P6hHK/qLx+jOOsh/a4gYLmsLYcMBD
3EwGrYPq4aA/PjFaKomhipG9MowJ5u5dOj3stly249JxE4QBTc8M9zLrIzOIFSoj
efJ4hKrRUZGpZamX1bs3Rlr0THCt0zwOKEz4kQtI9OxahGyPkJAw9Gq6XPtp4j/F
EFBJkz+NruAGGsli8O+tU9mkV9CIxiVWUJoL9n07jt8bJF4SkaV8KohQkf6sip3y
IQh/KR6vQwcLZ8TRlWCtwfujo9jbzPdwsAG2546DmIR0n28jU/5oyMdsIZyR+X1J
Ic0P7kHyta4nWX1mxmOD
=MnM0
-----END PGP SIGNATURE-----

--nextPart4383351.PXy3BS1Svt--

