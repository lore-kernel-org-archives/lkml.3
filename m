Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345Ab3EFXmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:42:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42320 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322Ab3EFXmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:42:23 -0400
Date: Tue, 7 May 2013 09:42:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <blogic@openwrt.org>
Subject: Re: linux-next: the mips tree is screwed up again
Message-Id: <20130507094214.744bc0d2c32ba1357a269853@canb.auug.org.au>
In-Reply-To: <20130506102914.54b5d59b086e19223d5ba1e1@canb.auug.org.au>
References: <20130506102914.54b5d59b086e19223d5ba1e1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_May_2013_09_42_14_+1000_BUcBSwtilXkW+NwL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_May_2013_09_42_14_+1000_BUcBSwtilXkW+NwL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Mon, 6 May 2013 10:29:14 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> It looks like John Crispin has cherry-picked or rebased part of Linus'
> tree into his branch that you have now merged.
>=20
> Guys, don't rebase your trees - especially this late and especially after
> they have been merged into a published tree.
>=20
> I will use the mips tree from Friday.

Still wrong :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__7_May_2013_09_42_14_+1000_BUcBSwtilXkW+NwL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiD/WAAoJEECxmPOUX5FELf8P/10kXzyWgnX7YTrhQMDy474g
IxQrqsyrNVaXh7LC5H+DYmhDhGkXUSDnrjsk6cvoXVDpyEV2mH9Ji0voPRCbuEk+
7bIRS15LszHW0YWei7fCqySBIRa0DF/2iDz1xbWFpiaZbsxF9MIVtImd+zrU+EOF
IfkbN5LKlyv0WfOsjw8qt7C0nqP5H7V20ELY7ULilhY6DvsjRd5Zy4h06Kpxu19H
dswRHEZcEspATeCzsQdFe65TwPApgDMJ6ZlK+5JdQ9HlsQzMMrFe8Jy8T3HRdj0R
I6lu8p0XWacU09sXDnP1Un1WlSoAjfkmbZhO+LOgxYv1MSOQGHxDRi4LaNl8XFad
cWKslC148K7pB4fGHp3SAbjYxx/qvlpSLWdKD/SWRLnAapJm390Qgl2xXf+s0EpW
Et8MJCTjASdn+ZFgkUPA5M4rThHoYSf6o67wy63NPLRlavE4HJta3nh70uP4WZex
jfpzI8Oq4sz0G4nocwDPqo2kcHkhcHU1EUR+Z1sGBTQauAG1KSqwFTe9R5NKwu5Z
Ok+UMNSZ2qbcBA2InHmOSj7z5tTRqF0ugdQlZF5D1j0uHDoAhvpVu8YRQj2mpFZA
uccbxQM5nDnCxgwAEVxgVM3nw0ad/uBCC2IYKj+Az9878vzXdxfiKDQ/qTpLKgbQ
HI+OfrgR56Ij0WtmQyJy
=7KK+
-----END PGP SIGNATURE-----

--Signature=_Tue__7_May_2013_09_42_14_+1000_BUcBSwtilXkW+NwL--
