Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3CXV1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 17:27:37 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46058 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab3CXV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 17:27:36 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Date: Sun, 24 Mar 2013 22:27:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201302170046.26569@pali> <201303241550.42801@pali> <20130324212149.GC18316@opensource.wolfsonmicro.com>
In-Reply-To: <20130324212149.GC18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2486778.TgbO5AKPaI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303242227.32528@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2486778.TgbO5AKPaI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 24 March 2013 22:21:49 Mark Brown wrote:
> On Sun, Mar 24, 2013 at 03:50:42PM +0100, Pali Roh=C3=A1r wrote:
> > There is no regulator 'Vdd' supply in board rx51 files. Can
> > you look at code how it can be fixed?
>=20
> You need to look at the schematics rather than the code here -
> the code just needs to say what regulator supplies Vdd on the
> device.

This is problem, there is no info about regulator supplies for=20
this device...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2486778.TgbO5AKPaI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFPb8QACgkQi/DJPQPkQ1J/jwCgi+dLFutJIH1Lo/0oAIC9toNR
nFEAnji7awyFRp9onXuxFavUwwGViKnG
=h3+D
-----END PGP SIGNATURE-----

--nextPart2486778.TgbO5AKPaI--
