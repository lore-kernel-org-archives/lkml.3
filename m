Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaGHGEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:04:33 -0400
Received: from ozlabs.org ([103.22.144.67]:49179 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaGHGEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:04:31 -0400
Date: Tue, 8 Jul 2014 16:04:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: benh@kernel.crashing.org, mahesh@linux.vnet.ibm.com, agraf@suse.de,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au, paulus@samba.org,
        anton@samba.org, linuxppc-dev@lists.ozlabs.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: powerpc allyesconfig fix
Message-ID: <20140708160417.47fb4d7c@canb.auug.org.au>
In-Reply-To: <1404795849-25609-1-git-send-email-xerofoify@gmail.com>
References: <1404795849-25609-1-git-send-email-xerofoify@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/O=XqCrweHOp8en2jl/Reuu1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O=XqCrweHOp8en2jl/Reuu1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

On Tue,  8 Jul 2014 01:04:09 -0400 Nicholas Krause <xerofoify@gmail.com> wr=
ote:
>
> powerpc:allmodconfig has been failing for some time with the following
> error.

This patch has already bee submitted directly by Guenter, however for
future reference:  when you submit someone else's patch, you should
include a From line as the first line of the email body containing their
email address and you should include a Signed-off-by line from yourself.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/O=XqCrweHOp8en2jl/Reuu1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTu4nmAAoJEMDTa8Ir7ZwV4mIQAI1fivBNbbXD5/n/4Q+zTrsW
ZXJ/pBalXPut/JpnaXEacvfwKI0QFVhtxED5hPYj/OjxMfwsHdk7FFfcgujYnPkB
uPl2yQNiEeJWKHDtjF6aNNO69ZuqTpLeYjWj8nrGtZWkdEtVdsiQCPZKI8Yi5JyV
GMVSW8rwWAqdwSrArUHR8wmm/dgW9img1/wk5uhIgABvMjs0UnDhIp4M4iHPuNYK
VIjzIHYO0BF2rteFiilfsIxGIE0Xy7q4n7XseKuZMt8me1IEItPHsyVAm9F9F/W4
QjOkxSE3jnDVDH/TSprc0X8qILgiPtsu3GZFmRbVVnWHWWnWBqgjTnDp7+ozuZi9
BmjqFkNi6GWGSAivTaKUpozKNwQg2xVTD/ykrXZmJHY6T47DuqQTQoASJ7vvUUQ2
McUU0LR8iX/OsqyrHhZOfn4eTGjUn9hisi5ncOkYPRKZdU9cLfEKSx5tf26JCTfu
QyP3n8Njynu3ZUSlKFNY7A//ktjOk6clzOkbr9dOWriWBGAoY3HgOyHcohTjXzc7
odUC0jslztiY5zbo49NHA1rBCZDxx3IP00/ALIVHUGSrWANWA+pYP9PO0CTj7TUN
qVc4j9YdaO24CxU8qmkdkSqaFdgAD1rSjXY/PO8iAdiAW1bJD3qZQ0Cbd0PjH9rE
Y598N/14XgOAFLd8TC/C
=z/pS
-----END PGP SIGNATURE-----

--Sig_/O=XqCrweHOp8en2jl/Reuu1--
