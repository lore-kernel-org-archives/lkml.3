Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3KNMCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:02:41 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46644 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3KNMCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:02:38 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: input question: ambient light sensor button
Date: Thu, 14 Nov 2013 13:02:31 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-13-generic; KDE/4.11.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
References: <201309151553.34000@pali> <alpine.LNX.2.00.1311131146410.22940@pobox.suse.cz> <20131113162840.GB11657@core.coreip.homeip.net>
In-Reply-To: <20131113162840.GB11657@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1917016.QdsGLqR9mN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311141302.33384@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1917016.QdsGLqR9mN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 13 November 2013 17:28:40 Dmitry Torokhov wrote:
> On Wed, Nov 13, 2013 at 11:47:18AM +0100, Jiri Kosina wrote:
> > On Sun, 15 Sep 2013, Pali Roh=C3=A1r wrote:
> > > I do not know where to ask this question, but I think that
> > > kernel developers could help me.
> > >=20
> > > I have notebook with one special button on keyboard which
> > > is designed for turning ambient light sensor on and off.
> > > By default pressing button do nothing (I can turn ambient
> > > light sensor on/off via sysfs platform wmi module).
> > > Button press is reported by kernel input device AT
> > > Translated Set 2 keyboard and reports it as button
> > > "touchpad off".
> > >=20
> > > Of course "touchpad off" is incorrect and I'd like to ask
> > > which kernel key or button from
> > > /usr/include/linux/input.h should be mapped for my
> > > ambient light sensor button? Is there already some? And
> > > what is strategy for allocating KEY_* and BTN_* numbers?
> >=20
> > This is maintained by Dmitry, so he's the one to answer
> > this. I am adding him to CC.
>=20
> I guess we need patch adding
>=20
> 	#define KEY_ALS_TOGGLE	0x230
>=20
> Thanks.

So there is no good key for als yet?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1917016.QdsGLqR9mN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKEu9kACgkQi/DJPQPkQ1KjOwCgl+ZCq5uJPmE4nzDC0DDHYnPV
NuIAn2FNCmKfQVxLSERM7ropiuwuCNVj
=3B3H
-----END PGP SIGNATURE-----

--nextPart1917016.QdsGLqR9mN--
