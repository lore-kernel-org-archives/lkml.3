Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaKXUzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:55:53 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33067 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKXUzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:55:52 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/3] platform: x86: dell-rbtn: Dell Airplane Mode Switch driver
Date: Mon, 24 Nov 2014 21:55:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com> <1416755361-17357-2-git-send-email-pali.rohar@gmail.com> <20141124200905.GB3459@srcf.ucam.org>
In-Reply-To: <20141124200905.GB3459@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6385597.ULYujmgbmj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411242155.48087@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6385597.ULYujmgbmj
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 24 November 2014 21:09:05 Matthew Garrett wrote:
> On Sun, Nov 23, 2014 at 04:09:19PM +0100, Pali Roh=C3=A1r wrote:
> > +	/* NOTE: rbtn controls all radio devices, not only WLAN
> > +	         but rfkill interface does not support "ANY" type
> > +	         so "WLAN" type is used
> > +	 */
>=20
> If it controls multiple radio types then you should register
> multiple rfkill devices.

This is complicated. HW switch controls all radio devices and you=20
do not know which are present in specified running machine. Also=20
list of devices which HW switch controls can be edited in BIOS=20
(on some machines). So what to do? We only know that it controls=20
some devices...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6385597.ULYujmgbmj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRzm1MACgkQi/DJPQPkQ1IOwwCeNx9P36I6wXEzJe0N3BTfEvlm
fkoAoMx/SEFrVR9NSCo1AWydVwaVWu0h
=rsm7
-----END PGP SIGNATURE-----

--nextPart6385597.ULYujmgbmj--
