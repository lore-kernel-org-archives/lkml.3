Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaB1Cav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:30:51 -0500
Received: from ozlabs.org ([203.10.76.45]:39413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaB1Cat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:30:49 -0500
Date: Fri, 28 Feb 2014 13:30:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: Re: [PATCH] cris: Make ETRAX_ARCH_V10 select TTY for use in
 debugport
Message-Id: <20140228133037.08fbdf972f54b1217629fdd4@canb.auug.org.au>
In-Reply-To: <20140228012732.GA9890@thin>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
	<20140226100234.GA23064@thin>
	<20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
	<20140226231916.GB17589@jtriplet-mobl1>
	<20140227104211.b2a4a5a1066fcf8ac2640ce3@canb.auug.org.au>
	<20140228012732.GA9890@thin>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Feb_2014_13_30_37_+1100_acJ+Yi8ET=R24LBm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Feb_2014_13_30_37_+1100_acJ+Yi8ET=R24LBm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Feb 2014 17:27:34 -0800 Josh Triplett <josh@joshtriplett.org> wr=
ote:
>
> arch/cris/arch-v10/kernel/debugport.c, compiled in unconditionally with
> ETRAX_ARCH_V10, requires TTY, so select TTY to avoid a build failure.
>=20
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__28_Feb_2014_13_30_37_+1100_acJ+Yi8ET=R24LBm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTD/TWAAoJEMDTa8Ir7ZwVyDgP/ArGnHthxve48iGofSQullUS
ZuvV8RIz18JE+OAhNOVoLGnWRxDLEkdi2+Qzeg6NuZGkgPHCrhQEnKxa/EXSC9hl
IFBeQJ0Cya6pLs+DWoBYbTEBynFFwDZZd62rFWxiWhrRhccrliAu8x1ykSvbsszP
+wY1YisiNNhqYvETyP+ijrgT3kAoLbqZYUfJOcAqlabF24GSdfH+7Lo309Rp6xex
1jQrHJcCgZyPOs6Dv7Bprd11p2GRAfsDCCG9pCPaD3PXDKS3ITMw8+PLlyQLq1iu
REYHnFSe8mCkh2aZv5h/TMPp8AEB72ivnD58YPk88khjOuEUXkfsrSdjto1qsJkz
bMNfTCpbacDtOnUyBIwaY4cNzIwockaKUO0yOzNYxrG0jnIPFS7QVAn0O6OPvb5J
w5wp3h625CMcOUlYpdZgQ7ZmCgMYCT78NdYFNJOO61Hln3u+No+Xs8VDBVXEb4JM
Ei07ja5Fc1/dL7IFXtdo+2DODHObQ1xc1Q4mODQVb7WIlBRGrtpKM6I4ePtusDYt
rLmbzasxm1nmjssv3MPbim/q2ZtpdAEy338cllbYAJbsmmEvtSqnONNrYvkNOmgm
uZ2jCpSTurUT9tyqcn4e/9OUPwYy1/Vkdti82UxPf5H1RKZFYhU4MOEpfoRepSVh
bRjLs4RMpE2MF0MNY35j
=D+Yw
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Feb_2014_13_30_37_+1100_acJ+Yi8ET=R24LBm--
