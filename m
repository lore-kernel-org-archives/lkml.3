Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3CXWpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 18:45:07 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37590 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3CXWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 18:45:06 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Date: Sun, 24 Mar 2013 23:44:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201302170046.26569@pali> <201303242227.32528@pali> <20130324221444.GD18316@opensource.wolfsonmicro.com>
In-Reply-To: <20130324221444.GD18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart28436688.2eiQrnqLYk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303242345.00176@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart28436688.2eiQrnqLYk
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 24 March 2013 23:14:46 Mark Brown wrote:
> On Sun, Mar 24, 2013 at 10:27:32PM +0100, Pali Roh=C3=A1r wrote:
> > On Sunday 24 March 2013 22:21:49 Mark Brown wrote:
> > > You need to look at the schematics rather than the code
> > > here - the code just needs to say what regulator supplies
> > > Vdd on the device.
> >=20
> > This is problem, there is no info about regulator supplies
> > for this device...
>=20
> Well, you should seek support from the board vendor then.=20

Not possible. Nokia is already using Windows Phones and life=20
cycle for Nokia N900 phone is at the end. And Nokia never=20
released any HW documentations to community...

> Or try things like continuity tests (the regulator will have
> external components, most likely there's at least a
> decoupling cap you can probe at the device end too).

Disassembling this mobile phone is not simple and I dubt that it=20
will help me...

Another question: what was reason for that commit=20
ec400c9fab99d16a491cea17d27d0c6a5780b97c
"lis3lv02d: make regulator API usage unconditional" ?

I think that for N900 support is reverting above commit needed, I=20
do not see other solution...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart28436688.2eiQrnqLYk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFPgewACgkQi/DJPQPkQ1L7+wCfaXhasZ+s6oh4tWUpZ9SuIar3
7JwAoLUvl+lgh4lOEY9h11vPuiaPOHOG
=Crgu
-----END PGP SIGNATURE-----

--nextPart28436688.2eiQrnqLYk--
