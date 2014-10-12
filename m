Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaJLQpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:45:14 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38886 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaJLQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:45:11 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH] dell-wmi: Fix access out of memory
Date: Sun, 12 Oct 2014 18:45:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <1411996251-13455-1-git-send-email-pali.rohar@gmail.com> <3073358.myrKz9QbdW@vostro.rjw.lan> <55C20A75-AB0A-4A4E-9E91-3428B5F868BB@infradead.org>
In-Reply-To: <55C20A75-AB0A-4A4E-9E91-3428B5F868BB@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4762213.PqHB0Xv0p9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410121845.07303@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4762213.PqHB0Xv0p9
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 30 September 2014 01:16:23 Darren Hart wrote:
> On September 29, 2014 4:26:03 PM PDT, "Rafael J. Wysocki"=20
<rjw@rjwysocki.net> wrote:
> >On Monday, September 29, 2014 02:30:29 PM Darren Hart wrote:
> >> On Mon, Sep 29, 2014 at 03:10:51PM +0200, Pali Roh=C3=A1r wrote:
> >> > Without this patch driver dell-wmi is trying to access
> >> > elements of
> >
> >dynamically
> >
> >> > allocated array without checking array size. This can
> >> > lead to
> >
> >memory corruption
> >
> >> > or kernel panic. This patch adds missing checks for array
> >> > size.
> >> >=20
> >> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >>=20
> >> Looks good to me. Rafael, any concerns?
> >
> >Not anything obvious.
>=20
> Queued, thanks.
>=20
> >> Cc: linux-acpi
> >
> >Thanks!
> >

Now I see that this patch is in linus tree. Can you sent it to=20
stable trees too?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4762213.PqHB0Xv0p9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQ6sBMACgkQi/DJPQPkQ1LYMACfVKJsRVG/XYXn/f6QoEy0SWiZ
5tgAoMfd7zUV6Uu7HfnFJkclQl9h/jWH
=iHgk
-----END PGP SIGNATURE-----

--nextPart4762213.PqHB0Xv0p9--
