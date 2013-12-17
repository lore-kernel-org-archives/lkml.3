Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3LQC2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:28:47 -0500
Received: from ozlabs.org ([203.10.76.45]:47500 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab3LQC2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:28:45 -0500
Date: Tue, 17 Dec 2013 13:28:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dong Aisheng <b29396@freescale.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-Id: <20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
In-Reply-To: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Dec_2013_13_28_38_+1100_4_imMTusJeo.Q8Qw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Dec_2013_13_28_38_+1100_4_imMTusJeo.Q8Qw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

ping?

On Fri, 13 Dec 2013 12:57:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the mmc tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> ERROR (phandle_references): Reference to non-existent node or label "pinc=
trl_usdhc4_1"
>=20
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[2]: *** [arch/arm/boot/dts/imx6dl-sabresd.dtb] Error 2
> ERROR (phandle_references): Reference to non-existent node or label "pinc=
trl_usdhc4_1"
>=20
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[2]: *** [arch/arm/boot/dts/imx6q-sabresd.dtb] Error 2
>=20
> Caused by commit fc4fafac9656 ("ARM: dts: sabresd: add usdhc4 support").
>=20
> I have used the mmc tree from next-20131212 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Dec_2013_13_28_38_+1100_4_imMTusJeo.Q8Qw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSr7baAAoJEMDTa8Ir7ZwVqEMP/AseTyBC5UxhbSbXbGZ1UU7O
BmWZiMFMZ6/bfLwyzzGaD8ahyhtkoBpOBGjzDZkX/GVDx6InPTNe2+4cki2MAQyD
P429RqPmu7a/SJ66ex9I4vcaXZ5FoQOWhVcOyyZ+IDL3fKlZb9UDyRxjlr9nUhkP
yA72xjhRXfGTtf8fd2lCt2T+dxjYr707lZFZ9vci/iDBKW9farBgEQXdc37s2zOP
jn5aSuOMrmjpJmj4XhjpOajhizEK/RBIYLpt3VoEjxhtBkR17PnWUZXtHYgE25iJ
IdsQ2yzzgZge8hscssEQVhQD7YgkmO9IWSGZCakOFDdZA2Hcmdh+nkX5PMrt5TQF
QWdk9c7VBKh3FdqNbT7c3BYh2DTCqfEQd5na+rNnsfiuKLRv9jKPQ2f7mDXviGeR
xrCy3U5qKU+wyWET0ComidW8q8F0Xcbt/F1IL6fHx5xXoCgWjD5ALoPqXoHYb5l0
pDzHs1E2QxJPTGE313U/mvoRoJOTwdmbLNzfdJjYMpKkKzQC9wg+kghGhNAF95Kb
Ah7j79EPXjk43/4ZE262YL8B7CTTRUkEqLqIC5w8JiI4f5rw+tJzIxK+LrD2qSke
w7hw1RHKrg7CcOK5mipwpvY5sSkktP+HUEzoJyIO/mTff4/cDwPaU34KH0O6z+ni
CvV93EpYTSSdJNaQ5yfP
=PS1r
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Dec_2013_13_28_38_+1100_4_imMTusJeo.Q8Qw--
