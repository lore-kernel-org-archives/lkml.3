Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbbAMHu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:50:56 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56310 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbbAMHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:50:54 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 6/7] input: alps: Add sanity checks for non DualPoint devices
Date: Tue, 13 Jan 2015 08:50:51 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com> <1415993906-13307-7-git-send-email-pali.rohar@gmail.com> <20150112003100.GC31862@dtor-ws>
In-Reply-To: <20150112003100.GC31862@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart11022770.uSF2QhEGBV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501130850.51106@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart11022770.uSF2QhEGBV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 12 January 2015 01:31:00 Dmitry Torokhov wrote:
> On Fri, Nov 14, 2014 at 08:38:25PM +0100, Pali Roh=C3=A1r wrote:
> > This patch adds sanity checks and reject trackstick packets
> > from ALPS devices which do not have trackstick present
> > (those without ALPS_DUALPOINT flag).
> >=20
> > Make sure that driver does not process some bogus packets as
> > trackstick data when there is no trackstick packet. Patch
> > also write warning do dmesg so possible problems with
> > driver (e.g received invalid data) will be visible for
> > debugging.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Applied, thank you.
>=20

Hello Dmitry, can you comment and review also other patches?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart11022770.uSF2QhEGBV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlS0zlsACgkQi/DJPQPkQ1J/SgCgveEQL0qTwhf1bxBMIz65++vC
5z4Anj4Kh5xkfKZbBTlfcGas4mDYgdxD
=X+6b
-----END PGP SIGNATURE-----

--nextPart11022770.uSF2QhEGBV--
