Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaL2MW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:22:59 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52175 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaL2MW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:22:56 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Mon, 29 Dec 2014 13:22:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412281707.44124@pali> <1566138.nEi3x1Fh8B@xps13>
In-Reply-To: <1566138.nEi3x1Fh8B@xps13>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart36411072.NsFtpjCUmA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412291322.52203@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart36411072.NsFtpjCUmA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 28 December 2014 17:17:14 Gabriele Mazzotta wrote:
> OK, I wanted to double check in case I had something missing.
>=20
> Patches tested on my XPS13: the correct values for fan_mult
> and fan_man are automatically selected.

Great. Are there any other problems? Now probe time when loading=20
module should be lower and could not freeze system, right?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart36411072.NsFtpjCUmA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlShR5wACgkQi/DJPQPkQ1InewCeMKeoOYn9YBMy2fKAO3NZYWFb
XMoAniRzrir9KiUEH4/fqJzlKVD8dZY/
=0TJU
-----END PGP SIGNATURE-----

--nextPart36411072.NsFtpjCUmA--
