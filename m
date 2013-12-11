Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3LKHcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:32:25 -0500
Received: from smtp01.online.nl ([194.134.41.31]:37895 "EHLO smtp01.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab3LKHcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:32:21 -0500
Message-ID: <52A814D7.1060805@meshcoding.com>
Date: Wed, 11 Dec 2013 08:31:35 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Alexander Viro <viro@zeniv.linux.org.uk>
CC: Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: Re: [B.A.T.M.A.N.] [PATCH -next 2/3] batman-adv: Use seq_overflow
References: <cover.1386738050.git.joe@perches.com> <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com> <52A813C1.8070404@meshcoding.com>
In-Reply-To: <52A813C1.8070404@meshcoding.com>
X-Enigmail-Version: 1.6
OpenPGP: id=43FD7307
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bbG9snU5osjWRKo4NB4AAansjRPstJHRd"
X-Online-Scanned: by Cloudmark authority (on smtp01.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bbG9snU5osjWRKo4NB4AAansjRPstJHRd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Joe,

we have other places in the batman-adv code where we use seq_printf, but
at the moment we don't check the return value and we always return 0 at
the end of the function.

I think we could use seq_overflow here as well?


Thanks,


--=20
Antonio Quartulli


--bbG9snU5osjWRKo4NB4AAansjRPstJHRd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSqBTbAAoJEEKTMo6mOh1VQRAQAJ5F+K+L3WKBmDNEm5hDwEqH
QEkP/hoUahL+awpng34XuxE90ci9GksBZfm6kXADZhtqRH1SeXh89D99sX/BKL0N
4POYhXv9Z5NVSfEl0FqEcaidSIKfoHuLXl0vHFNLT+UKnZZ1Hx/RIHF74hcSbCTj
niKhmWEt1OUKmUiQcLz5FKWF6VG1AJL2kT2MISgHHahNEBZDwuOIgjY+unL0MsAS
ClAuSgym5MDoPRcPzARDq7znt1Ql4aOgjo8n5lCymDW/zJ922UHJSU31N4IRkU6R
c4Fsx2AWorasM6PMgma+sUPAZTRdsekDHI1hNPNK3cHuaBLBPBOHD1Bljdc69ILy
rtKcUoW6E8I4P2EzV+p37Eahn+xoNI/mQUV0fIAsRk2fFICKul9urswD33WRBiqs
CaB7twGviBUCpou+Q4AdxQH+Yz50aXRosz1aEjcWSGniVmI1Vll6m+Z4lxLneHzs
LDm0WwLZFxZt1tvb/xnLs/VsIFsS22XEr1VsBb5oEDKSaWcTzEwSCZg8MH/3cy1f
6bE0tGQ8mDiagr/cVizLU6VCSTCt3W9iiOacL8xv8vLI3oR8y/8aWOv/m63EwSbL
KV0Wg+U4mpXo8E/Cc6v+8/W9+V4h2dAUHmXf9/8q675ZXu99hrJl3HaOSSuxaRPx
Or7pQuy6CQNhXL9jaNij
=s7fm
-----END PGP SIGNATURE-----

--bbG9snU5osjWRKo4NB4AAansjRPstJHRd--
