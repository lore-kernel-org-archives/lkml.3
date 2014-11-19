Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaKSTve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:51:34 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33759 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSTvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:51:33 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Wed, 19 Nov 2014 20:51:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com> <20141119183416.GA100640@vmdeb7> <20141119192336.GA942@srcf.ucam.org>
In-Reply-To: <20141119192336.GA942@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4529200.Z2EOdNf5Qh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411192051.28998@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4529200.Z2EOdNf5Qh
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 19 November 2014 20:23:36 Matthew Garrett wrote:
> On Wed, Nov 19, 2014 at 10:34:16AM -0800, Darren Hart wrote:
> > I'm somewhat concerned that this patch doubles the size of
> > this driver. When we're adding this much code, I have to
> > ask - does it make sense to grow this driver rather than
> > create a new one?
>=20
> There'd be a fair amount of code duplication in splitting it.
>=20

Yes. dell-laptop.ko implements functions for doing Dell SMBIOS=20
calls which are needed for keyboard backlight.

> > There is no ACPI backlight driver on these systems? We need
> > a platform driver?
>=20
> ACPI doesn't specify keyboard backlight control, so this ends
> up being very vendor specific.

dell-laptop.ko is not ACPI driver. It is using Dell SMBIOS calls.=20
And I do not know about Dell specific ACPI interface for keyboard=20
backlight. So Darren, ask this question someone from Dell.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4529200.Z2EOdNf5Qh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRs9MAACgkQi/DJPQPkQ1IT0QCgxeQ5KCnqgXVoXen/YA9LxL/D
gK4An1VU2uY2wgLTeV8Q+JANnOu8MMHJ
=LTjX
-----END PGP SIGNATURE-----

--nextPart4529200.Z2EOdNf5Qh--
