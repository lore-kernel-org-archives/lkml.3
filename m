Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066Ab3DIOXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:23:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33752 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934945Ab3DIOXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:23:19 -0400
Date: Wed, 10 Apr 2013 00:23:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 9
Message-Id: <20130410002311.8a0b0503bcbda151b9de9469@canb.auug.org.au>
In-Reply-To: <CA+icZUVk-iLtodZi_46qmk410Ei+tW6RR5kV2fx0N8v6neKTPQ@mail.gmail.com>
References: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
	<20130409235941.11eef57a42cb97efec72f037@canb.auug.org.au>
	<CA+icZUVk-iLtodZi_46qmk410Ei+tW6RR5kV2fx0N8v6neKTPQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_00_23_11_+1000_ChWrRazAFdl59UPm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_00_23_11_+1000_ChWrRazAFdl59UPm
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Tue, 9 Apr 2013 16:11:50 +0200 Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> [ CC Al Viro ]

You forgot to do that ...

> Is there a "magic" git-command to revert all commits coming from your
> latest vfs-merge (commit c1c04d3667608a630ae0821995b465a523e83fb1)?
>=20
> 2013-04-09 11:36 Stephen Rothwell   =E2=94=82 M=E2=94=80=E2=94=90 =E2=94=
=82 =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=82         =E2=94=82 201=
30405/vfs

You would normally do "git revert -m 1 c1c04d366760". However, that does
not revert cleanly in today's linux-next (due to more patches modifying
the files involved).

> After reverting all these commits I would like to pull-in latest
> vfs.git#for-next.

It would probably be easier to wait for tomorrow's linux-next.  Or just
test Al's tree in its own.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Apr_2013_00_23_11_+1000_ChWrRazAFdl59UPm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZCRPAAoJEECxmPOUX5FEZGQP/A27dgaV3NT7b9+QeMZ1eDAa
1FDLj9VfiKM0j1mt4hlINnIowWRxLJkJpLirDJVKOz+lyMOP6+d3uBRdA6T0tBc9
Pg0oY+RH5tRVVsqXp81wzA+pxgibW0TC502CbgPVsSvWlm/3YxPzcSFhom6Y3s7p
TmUWSFXh9ut6JaW01JnKGaEmrx6YV/zufFnqZ/Kt6/ET2BLAjNcixRgP59zc/OrZ
X/qU0DJ/d6ek9rLHGpp9hvl0wQFy47YTddXGocnLJXp3m3c95W215B9oXhVG3okK
Vl80jfU2uJ9nxKNOKLhu9K+nE7DDlwUJ+xXq8h1b0Q3EijDPiKC5veTN6gXBrd/D
LLc54oj79ashte4tKW3B8KyKNFIdf6+ggAFo2YUipgjZqM6SnWnVJDXObrTfROaG
C0yak0VVxEYhZeCzt3Ln4Yu+oofqiWQJyC1LeLo03GFyRWHw2WR3Q1Dc3KkCvs2u
2nkAxU5QLAZs29PAWAc6eq1sD4gfC4TRgw/uOTnmYs5/I2hJt8IriokUHgEiBBZZ
AfByGlLw5AR4rI4tfpb5IbDJL/QOw6QHCUMPLuqDxb6GR0k8G5PT9SA18GoOjNFO
UG2RN8wnCMpEK2VQaIFOShR10uAgMjr541fimiA7WPyln9A9ce/tVrkHNVTMIugl
2U7/GMHG+MLvIH3GKHYf
=9If+
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_00_23_11_+1000_ChWrRazAFdl59UPm--
