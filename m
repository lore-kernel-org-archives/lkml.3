Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaLXTfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 14:35:55 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47432 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaLXTfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 14:35:54 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: CONFIG_UDF_FS description
Date: Wed, 24 Dec 2014 20:35:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-031900rc1-generic; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3720621.JMF6vmeOQY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412242035.49929@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3720621.JMF6vmeOQY
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello, can you update menuconfig description about UDF filesystem=20
in file fs/udf/Kconfig? There is information only about CD/DVD=20
discs and packet mode. But UDF FS can be used also on hard disks=20
or removable usb disks (as multiplatform alternative to FAT32).=20
It means that CONFIG_UDF_FS can be useful also on machines=20
without optical mechanic.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3720621.JMF6vmeOQY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSbFZUACgkQi/DJPQPkQ1JZ5QCfe+OUaO8+inD8K1ZeuIpLeMy6
G8IAn3YNr9TPXF3wb3iPRP9RXLD3/OV+
=fSN4
-----END PGP SIGNATURE-----

--nextPart3720621.JMF6vmeOQY--
