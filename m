Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3DDJc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:32:26 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42899 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594Ab3DDJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:32:25 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in twl4030_madc_conversion
Date: Thu, 4 Apr 2013 11:32:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>, Anton Vorontsov <cbou@mail.ru>,
        Keerthy <j-keerthy@ti.com>, Kyle Manna <kyle@kylemanna.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com> <201303022323.06091@pali> <201303241503.29912@pali>
In-Reply-To: <201303241503.29912@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4204324.nyTu21UEpb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201304041132.21158@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4204324.nyTu21UEpb
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 24 March 2013 15:03:29 Pali Roh=C3=A1r wrote:
> On Saturday 02 March 2013 23:23:05 Pali Roh=C3=A1r wrote:
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
> Bump.
>=20
> Can some of mfd maintainers look at this patch and include it
> to mfd tree? It is needed for rx51_battery power supply
> driver.

CCing Tony, can you look at this patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4204324.nyTu21UEpb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFdSKUACgkQi/DJPQPkQ1J3FwCgsdsQMZ9ABbG+1TJ9cLK8pSCm
XgoAn03qdIow1/rBhSL214sDBT7RJZZW
=kBoX
-----END PGP SIGNATURE-----

--nextPart4204324.nyTu21UEpb--
