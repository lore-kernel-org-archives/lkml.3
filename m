Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaELALY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 20:11:24 -0400
Received: from ozlabs.org ([103.22.144.67]:51963 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaELALW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 20:11:22 -0400
Date: Mon, 12 May 2014 10:11:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Chris Ball <chris@printf.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Micky Ching <micky_ching@realsil.com.cn>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: linux-next: manual merge of the mmc tree with Linus' tree
Message-ID: <20140512101115.3876b3f5@canb.auug.org.au>
In-Reply-To: <CAPDyKFq1O-bB1Vax0uRKaF2p2AJ1FXHC6LNoLsooGx5gBdsuLA@mail.gmail.com>
References: <20140509134455.07d7de4d@canb.auug.org.au>
 <20140509071423.GF5767@lee--X1>
 <CAPDyKFq1O-bB1Vax0uRKaF2p2AJ1FXHC6LNoLsooGx5gBdsuLA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BNg1iRPXGbdbBwPZG4NXfc9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BNg1iRPXGbdbBwPZG4NXfc9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ulf,

On Fri, 9 May 2014 09:41:39 +0200 Ulf Hansson <ulf.hansson@linaro.org> wrot=
e:
>
> Within this context; while Chris is being busy, I would be able to
> help out better as co-maintainer - if we would add my published mmc
> git tree, into your linux-next merge. Could you do that?
>=20
> My intent at this point, is to get patches tested in linux-next, but
> still get them merged via Chris' mmc tree. Does that make sense?
>=20
> Here is my git tree:
> git://git.linaro.org/people/ulf.hansson/mmc.git
>=20
> I have added a next branch, currently it points to the commit for
> "Linux 3.15-rc4", so it holds no patches yet.

Added from today. Chris, if this is a problem, give me a heads up.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/BNg1iRPXGbdbBwPZG4NXfc9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcBGoAAoJEMDTa8Ir7ZwV1TMP/RN6RAqgS3OxvqjMuPWL19j5
To6Eog67SCf2a0bSk24PHyRsBPRmpxHYB+ij6VzEqarqbpPg4CeNJNqAn9OUtXUe
ugoSZEkf9aOVXu87D8damIGv+1vpv4wf0JNwMqs267i/GsZ2t2V1FZjtzeS5HgCY
i/SMdONZsXo1eVNNZPYGqg05wwNJ7TPuOy440Te6DndmcBSKAGybSvGZn0LzQfh6
wC7/uTtWVAUcCgHsvEVn+cFpEaoXnJ2CSHWVG2f2fXWVovq3Rizvdqg1cLnThE/f
u1EpTHKrziPx1TxKYFpnNme++jEDX9+137pB3nxTy5W4w8jKmlgRTQEQzymO1nSe
QLuos1LyFDChZfcClQLdJUWQHOFHUAfQzEzz/GcfRuf+sGno8v/KjBVKAs+dCn8i
9Yv4xSAPQ9PS85gDbSP7Lv2JTbNQ38H5HpXg+mQmzUcqE/GaMyHXVgW+QfpLp9Ea
0fwACVJHjT+dyaGSkf7tV6T001Kjfd17F+GC/Z5dl1xw0edFV38naORZLIbiZSSD
zV7zrpAM+IiZGpTwQCyNcYFau14IMZjz9DfV4wKFtSWEog6p0OqVNcMTGqstzHxH
JTRCYQ8PTbVoFx2bbJiDaJU9rX1wlBxv0zWvNGDgrFzQzPi79K9/X6HehW/Zf6jh
7Wc4iss9e7gpRGhRRh/h
=/sfq
-----END PGP SIGNATURE-----

--Sig_/BNg1iRPXGbdbBwPZG4NXfc9--
