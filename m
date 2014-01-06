Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaAFGWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:22:51 -0500
Received: from ozlabs.org ([203.10.76.45]:39187 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbaAFGWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:22:49 -0500
Date: Mon, 6 Jan 2014 17:22:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-Id: <20140106172243.8067c8e72c666511129a9701@canb.auug.org.au>
In-Reply-To: <CAA+hA=QU1TApbbohD1iNFiMMMHdQSamRfOsO0r3GpqmCbdiSgw@mail.gmail.com>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
	<20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
	<CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
	<20131217031600.GG6691@S2101-09.ap.freescale.net>
	<CAA+hA=QU1TApbbohD1iNFiMMMHdQSamRfOsO0r3GpqmCbdiSgw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_17_22_43_+1100_6BXjlNW5VRFzgZdl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_17_22_43_+1100_6BXjlNW5VRFzgZdl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 17 Dec 2013 16:06:19 +0800 Dong Aisheng <dongas86@gmail.com> wrote:
>
> I tested that Chris tree does not have problem.
> It's caused by IMX tree updates.
>=20
> Chris,
> Is the way Shawn suggested OK for you?

Can we have some resolution of this please?  This failed to build again
today so I have used the version of the mmc tree from next-20131212
again.  I tried the obvious fix (s/pinctrl_usdhc4_1/pinctrl_usdhc4/) but
that didn't work.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Jan_2014_17_22_43_+1100_6BXjlNW5VRFzgZdl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSyku3AAoJEMDTa8Ir7ZwV/HUP/3huL4YJCLNNqzKLVjkmxzkX
NdIwCdJEP9Jy9GWqYaYBp2vK2semlvne2N2dt4TWHn49xDgTakIpnC4D5h2pbtqt
uHhWG6WVwH89l5eA/MbYg3q/+SiUFoyrQsgTBtC3TZaX7Bza1UUY7r0oWCR56Tne
5ARvLwQesSjIjTP3iWWKOjge/dBoV03q3PoHIwSi8LGLqpArB0U2ktB1sUiMLthw
kUIqvhYs6m6wBWjbSAP0J/fC/S2/ibk/sy29xi/HmMM4Wl+7Z4S23lEp4aXjRkAr
5vWdOTIEymDhoOQg9Dgvfh8RBjjNNrafgOdn211YR3xhOfdG2vV17DtPdNoUI4kw
FTIXo9i8zbuCMNR2bxs3uQUyzuaQBDKHIVSOvNI1bFIggx/ZAL9xQIL6MYaaRsM4
gVZH7/lecM/oAZMOEIvRSoFTOX6bxivjCBHAqKsF+suHADBwokmVz+wD23SbRmFv
MK06nR2txLVRfHhtJX6byos/KFXdda8ju0jCfguzYyT5FAHO4JAL+WZ+MZOrGfpq
dlC+jofB14HnQYbEJGhDseLKnHSSamUgya2PQhk3RTewvCgZVJUNG0hOnqHDBHTS
jVUxkU9F5BsjxT6g4tPH6yp3b5UcglGMSDyOXSG9Uh7F6TvpYkRd93PZqcNvNWQ3
1U1F40ug4ezJg9V7thLB
=6Wk6
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_17_22_43_+1100_6BXjlNW5VRFzgZdl--
