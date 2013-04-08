Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936757Ab3DHKng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:43:36 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47389 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383Ab3DHKnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:43:35 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in twl4030_madc_conversion
Date: Mon, 8 Apr 2013 12:43:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.2; x86_64; ; )
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Kyle Manna <kyle@kylemanna.com>
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com> <201303022323.06091@pali> <20130404093847.GC17363@zurbaran>
In-Reply-To: <20130404093847.GC17363@zurbaran>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4811600.5PO2hgevyD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201304081243.31940@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4811600.5PO2hgevyD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 04 April 2013 11:38:47 Samuel Ortiz wrote:
> Hi Pali,
>=20
> On Sat, Mar 02, 2013 at 11:23:05PM +0100, Pali Roh=C3=A1r wrote:
> > On Friday 15 February 2013 23:56:49 Pali Roh=C3=A1r wrote:
> > > Driver twl4030-madc has hardcoded channel types (10 -
> > > battery current, 1 - battery temperature) and also
> > > conversation data in variable twl4030_divider_ratios.
> > > These hardcoded channels are incorrect for Nokia RX-51
> > > board (where is channel 0 - battery temperature).
> > >=20
> > > For Nokia RX-51 there is rx51_battery power_supply driver
> > > which reporting battery information via
> > > twl4030_madc_conversion. But this driver needs raw values
> > > (not converted via some hardcoded functions). So this
> > > patch adding new parameter "raw" to struct
> > > twl4030_madc_request which tell twl4030-madc driver to
> > > not convert values, but rather return raw.
> > >=20
> > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > ---
> > >=20
> > >  drivers/mfd/twl4030-madc.c       |   14 ++++++++++----
> > >  include/linux/i2c/twl4030-madc.h |    2 ++
> > >  2 files changed, 12 insertions(+), 4 deletions(-)
> >=20
> > Hello, can somebody review this twl4030-madc patch?
>=20
> I'll look at all my pending MFD patches starting from
> tomorrow.
>=20
> Cheers,
> Samuel.

Hi Samuel, did you look at this patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4811600.5PO2hgevyD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFin1MACgkQi/DJPQPkQ1K4NQCgg7O7UL7ABKV0wFXq9rPyHfg/
ZaIAn1i8EVTLB4b3+ttp6pkg9FIwuJci
=R78Q
-----END PGP SIGNATURE-----

--nextPart4811600.5PO2hgevyD--
