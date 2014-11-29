Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaK2QJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:09:40 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50601 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaK2QJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:09:39 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sat, 29 Nov 2014 17:09:35 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2344174.o11q53hl0F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411291709.35406@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2344174.o11q53hl0F
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 29 November 2014 17:04:07 Pali Roh=C3=A1r wrote:
> This patch adds labels for temperature sensors if SMM function
> with EAX register 0x11a3 reports it. These informations was
> taken from DOS binary NBSVC.MDM.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  drivers/char/i8k.c |  110
> +++++++++++++++++++++++++++++++++++++++++----------- 1 file
> changed, 88 insertions(+), 22 deletions(-)

I tested patch on Latitude E6440 and i8k CPU & GPU temps match=20
intel coretemp & amd radeion temps.

But I would like if somebody with other Dell laptop can test if=20
temperature labels are correct...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2344174.o11q53hl0F
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR5778ACgkQi/DJPQPkQ1LcdQCgu1Q4QuMsYN4pOZAoa+qI5TQR
XJgAn2Bdim/GAlYHUHoJGfBjHjoVDSK1
=HxgA
-----END PGP SIGNATURE-----

--nextPart2344174.o11q53hl0F--
