Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaKFRqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:46:55 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35002 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKFRqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:46:52 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v3 0/4] Fixes for ALPS driver
Date: Thu, 6 Nov 2014 18:46:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <1414884310-19842-1-git-send-email-pali.rohar@gmail.com> <54563C5F.10702@redhat.com>
In-Reply-To: <54563C5F.10702@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2402195.MMvO1HV68e";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411061846.48626@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2402195.MMvO1HV68e
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 02 November 2014 15:14:55 Hans de Goede wrote:
> Hi,
>=20
> On 11/02/2014 12:25 AM, Pali Roh=C3=A1r wrote:
> > This patch series tries to fix problems with ALPS dualpoint
> > devices on Dell Latitude laptops which are probably caused
> > by bugs in Dell BIOS, Dell EC or in ALPS touchpad firmware
> > itself.
> >=20
> > Root of problems is yet unknown but at least this patch
> > series could eliminate reporting bogus data to userspace.
> >=20
> > Reported bugs:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1258837
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1320022
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1272624
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D1145954
> >=20
> > Pali Roh=C3=A1r (4):
> >   input: alps: Do not try to parse data as 3 bytes packet
> >   when driver
> >  =20
> >     is out of sync
> >  =20
> >   input: alps: Allow 2 invalid packets without resetting
> >   device input: alps: For protocol V3, do not process data
> >   when last packet's
> >  =20
> >     bit7 is set
> >  =20
> >   input: alps: Fix trackstick detection
> > =20
> >  drivers/input/mouse/alps.c |  113
> >  +++++++++++++++++++++++++++++++------------- 1 file
> >  changed, 80 insertions(+), 33 deletions(-)
>=20
> Thanks for working on this, patches 1-3 are:
>=20
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>=20
> Patch 4 is too much work to review on a Sunday :), so I'll
> leave reviewing it to Dmitry.
>=20
> Regards,
>=20
> Hans

Dmitry, can you review v3 patches?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2402195.MMvO1HV68e
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRbtAgACgkQi/DJPQPkQ1LWmACgiwlVUjp/Ppgk6TT6KH5nVX9W
H24An0HjaXDcWT/sGPPwZOPKdAv+mBzk
=b4DD
-----END PGP SIGNATURE-----

--nextPart2402195.MMvO1HV68e--
