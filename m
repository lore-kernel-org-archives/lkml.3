Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaHXMqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 08:46:53 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53254 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaHXMqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 08:46:52 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Jan Kara <jack@suse.cz>
Subject: Linux UDF support
Date: Sun, 24 Aug 2014 14:46:46 +0200
User-Agent: KMail/1.13.7 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3750701.zjykjTNZe1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201408241446.47042@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3750701.zjykjTNZe1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I would like to know what is state of linux UDF driver. It is=20
experimental or is now suitable for storing data?

According to wikipedia [1] UDF has open specification format and=20
can be used also for HDDs (not only optical discs).

In OS support table is written that all major and other minor OSs=20
support UDF FS (without needs for additional programs).

So it looks like UDF is good candidate for multi OS filesystem.=20
Are there any disadvantages for using UDF on e.g USB flash disk?=20
(when I want read/write support on Linux, Windows 7 and Mac OS X)

Because lot of manuals say that FAT32 (or NTFS) is only one=20
solution for using USB flash disk on more OS.

On wikipedia there is one note about linux: Write support is only=20
up to UDF version 2.01. Is this restriction still valid?

What will happen if I try to mount FS with UDF version 2.60 in=20
R/W mode on linux? It will fallback to R/O mode? Or newly written=20
files will be in previous (2.01) versions?

And last question: Is there some fsck tool for UDF? Or at least=20
tool which print if FS is in inconsistent state?

[1] - http://en.wikipedia.org/wiki/Universal_Disk_Format

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3750701.zjykjTNZe1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlP53rYACgkQi/DJPQPkQ1KZ+gCdF846p+74tWq0M3J88CT5y4bS
rTgAoMuaF2YJeD0Aqh8GfiwrKknEAh+m
=cbtf
-----END PGP SIGNATURE-----

--nextPart3750701.zjykjTNZe1--
