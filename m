Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936782Ab3DJONA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:13:00 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:58505 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763884Ab3DJOM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:12:57 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in twl4030_madc_conversion
Date: Wed, 10 Apr 2013 16:12:51 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Anton Vorontsov <cbou@mail.ru>, Keerthy <j-keerthy@ti.com>,
        Kyle Manna <kyle@kylemanna.com>, linux-omap@vger.kernel.org
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com> <201304041132.21158@pali> <20130408181524.GU10155@atomide.com>
In-Reply-To: <20130408181524.GU10155@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7010346.usi0f2nBaA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201304101612.51620@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7010346.usi0f2nBaA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 08 April 2013 20:15:24 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130404 02:37]:
> > On Sunday 24 March 2013 15:03:29 Pali Roh=C3=A1r wrote:
> > > On Saturday 02 March 2013 23:23:05 Pali Roh=C3=A1r wrote:
> > > > On Friday 15 February 2013 23:56:49 Pali Roh=C3=A1r wrote:
> > > > > Driver twl4030-madc has hardcoded channel types (10 -
> > > > > battery current, 1 - battery temperature) and also
> > > > > conversation data in variable twl4030_divider_ratios.
> > > > > These hardcoded channels are incorrect for Nokia RX-51
> > > > > board (where is channel 0 - battery temperature).
> > > > >=20
> > > > > For Nokia RX-51 there is rx51_battery power_supply
> > > > > driver which reporting battery information via
> > > > > twl4030_madc_conversion. But this driver needs raw
> > > > > values (not converted via some hardcoded functions).
> > > > > So this patch adding new parameter "raw" to struct
> > > > > twl4030_madc_request which tell twl4030-madc driver to
> > > > > not convert values, but rather return raw.
> > > > >=20
> > > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > > ---
> > > > >=20
> > > > >  drivers/mfd/twl4030-madc.c       |   14
> > > > >  ++++++++++---- include/linux/i2c/twl4030-madc.h |  =20
> > > > >  2 ++
> > > > >  2 files changed, 12 insertions(+), 4 deletions(-)
> > > >=20
> > > > Hello, can somebody review this twl4030-madc patch?
> > >=20
> > > Bump.
> > >=20
> > > Can some of mfd maintainers look at this patch and include
> > > it to mfd tree? It is needed for rx51_battery power
> > > supply driver.
> >=20
> > CCing Tony, can you look at this patch?
>=20
> Sorry for the delay in replying, I've been going through my
> inbox for the merge window and noticed this.
>=20
> I suggest resend with Peter Ujfalusi cc:d as he is the
> de-facto twl/tps maintainer and expert by now.
>=20
> Regards,
>=20
> Tony

Ok, both patches are now in mfd-next tree.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart7010346.usi0f2nBaA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFlc2MACgkQi/DJPQPkQ1JSUwCgt49V+IUbtYDHASF9N9d9hXEs
um8An2Err6LU1JWsztu/zF3WzlJbk+WR
=vkH3
-----END PGP SIGNATURE-----

--nextPart7010346.usi0f2nBaA--
