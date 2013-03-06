Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3CFOLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:11:19 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:53927 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3CFOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:11:14 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: Re: [PATCH] tidspbridge: Fix compilation
Date: Wed, 6 Mar 2013 15:11:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-26-generic; KDE/4.10.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Joni Lapilainen <joni.lapilainen@gmail.com>
References: <1362073866-8462-1-git-send-email-pali.rohar@gmail.com> <CAJ6Av5O9n99t01-+dprqOkC7Nyp8vpBQANWbgZqWiemUy8Q0tQ@mail.gmail.com>
In-Reply-To: <CAJ6Av5O9n99t01-+dprqOkC7Nyp8vpBQANWbgZqWiemUy8Q0tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1538494.DLqxx7UVVA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303061511.09943@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1538494.DLqxx7UVVA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 04 March 2013 10:14:31 Omar Ramirez Luna wrote:
> Hi,
>=20
> On Thu, Feb 28, 2013 at 11:51 AM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > Fix includes and use
> > clk_prepare_enable/clk_disable_unprepare
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
> > ---
> >=20
> >  drivers/staging/tidspbridge/core/dsp-clock.c  |   16
> >  ++++++++--------
> >  drivers/staging/tidspbridge/core/tiomap3430.c |    2 ++
> >  drivers/staging/tidspbridge/core/tiomap_io.c  |    2 ++
> >  drivers/staging/tidspbridge/core/wdt.c        |    8
> >  ++++---- 4 files changed, 16 insertions(+), 12
> >  deletions(-)
>=20
> AFAIK, this has been taken care in the past by:
>=20
> e16a922a staging: tidspbridge: use prepare/unprepare on dsp
> clocks fe025085 staging: tidspbridge: Fix build breakage due
> to splitting CM functions
>=20
> Would you mind pointing the target for your patches? Perhaps
> stable?
>=20
> Cheers,
>=20
> Omar

I was not able to compile tidspbridge on 3.8-rc3. But now with=20
3.8 it is fixed. So drop this patch.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1538494.DLqxx7UVVA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlE3Tn0ACgkQi/DJPQPkQ1LTOQCfefR+b2EFD3uCjKMKKU2NVBCx
h8kAoKk92lQqaF2vR5EOKQedaYC03v7D
=gKms
-----END PGP SIGNATURE-----

--nextPart1538494.DLqxx7UVVA--
