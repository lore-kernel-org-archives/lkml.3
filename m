Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaK0UBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:01:16 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63388 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaK0UBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:01:15 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Missing MODALIAS in /sys/devices/system/cpu/uevent
Date: Thu, 27 Nov 2014 21:01:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2712852.Yg3XtZvm05";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411272101.11811@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2712852.Yg3XtZvm05
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

on 3.18-rc5 I have empty cpu uevent file, but modalias file is=20
populated. See:

$ cat /sys/devices/system/cpu/uevent=20
$ cat /sys/devices/system/cpu/modalias=20
cpu:type:x86,ven0000fam0006mod003C:feature:,0000,0001,0002,0003,0004,0005,0=
006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,0013,0015,0016,0017,0=
018,0019,001A,001B,001C,001D,001F,002B,0034,003A,003B,003D,0068,006B,006C,0=
06D,006F,0070,0072,0074,0075,0076,0078,007C,007D,0080,0081,0082,0083,0084,0=
085,0086,0087,0088,0089,008B,008C,008D,008E,008F,0091,0093,0094,0095,0096,0=
097,0098,0099,009A,009B,009C,009D,009E,00C0,00C5,00E0,00E1,00E3,00E5,00E6,0=
0E7,0100,0101,0102,0103,0104,0120,0121,0123,0124,0125,0127,0128,0129,012A,0=
12B,012D,0140

=46or all other devices in /sys/devices/ which have modalias=20
content there is also MODALIAS=3D line in uevent file.

Is cpu device special? Or why it is only one device which has=20
modalias file but is missing MODALIAS=3D line in uevent file?

What userspace application should use for reading modalias=20
string? File modalias or file uevent?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2712852.Yg3XtZvm05
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR3gwcACgkQi/DJPQPkQ1KfUQCffXtrteNro/ZhSM6pHM7aLqmW
gbAAn3Kqb6MC+wIhD83UNC6AgY8zHSkp
=NwAr
-----END PGP SIGNATURE-----

--nextPart2712852.Yg3XtZvm05--
