Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3J3UhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:37:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45372 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3J3UhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:37:11 -0400
Date: Thu, 31 Oct 2013 07:37:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Salter <msalter@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        ccross@android.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next build failure
Message-Id: <20131031073700.f9642ce6c35674a45b3905bc@canb.auug.org.au>
In-Reply-To: <1383146865.11574.3.camel@deneb.redhat.com>
References: <1383146865.11574.3.camel@deneb.redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_07_37_00_+1100_O+I9JuAxaFYHRTJW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_07_37_00_+1100_O+I9JuAxaFYHRTJW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Jut add Andrew to the cc list]

On Wed, 30 Oct 2013 11:27:45 -0400 Mark Salter <msalter@redhat.com> wrote:
>
> This patch causes a build failure for no-MMU builds:
>=20
>   commit 41df2957cb010edfa2f9d394d3617da6beeeb660
>   Author: Colin Cross <ccross@android.com>
>   Date:   Wed Oct 30 11:45:39 2013 +1100
>=20
>       mm: add a field to store names for private anonymous memory
>    =20
> The problem is:
>=20
>   kernel/built-in.o: In function `sys_prctl':
>   (.text+0x19854): undefined reference to `madvise_set_anon_name'
>=20
> madvise doesn't make sense without an MMU.
>=20
> --Mark

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_Oct_2013_07_37_00_+1100_O+I9JuAxaFYHRTJW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScW3yAAoJEMDTa8Ir7ZwV7xEP/jbNCZtFOWZoRIYDhpwe5ciS
+P+cD/5N/TjbUvVJXQVhwn75cg1jIIujuxaJx98jtrwdHxqSmks63XeIMaT7Kr6o
havPP/q9cemVo8DFgDV+YcUoRpScI64wNtuPjgzuQVtXTBCnZQZlJDah5H7DjcXg
Ty6AmF5MvNTyIWdmfI/U3W/IUSISiSHGPjzI+lQ5lDKQ3stJ9pp6Q+S8KF8H4s6e
SewwnsEqzhe7j/PQgnw3xTOH7LOFLrcH4QU7n3/GeBVt9kkAMYcx+unYOrN7LY6D
E11aclOBmifcNR1kGUiJkhQ/C5V6SiJBSH10527X59XOzcKg1cg2U0dF6JcTCWAE
omXfKaTMzGeow/WChH3HyGEiuBOYZ7ycFNXvqQ9fcsHTLkJnwmTHppxdQj+8pTg5
KXWNJDP5O5yXECChgQtSy84oDD1ay41XShHrDhhEdmVrwCb1ZonelCladziKsOI+
Y+pscLbY10FF6NUoDE8xAieqwQfu1MBYqIiYmZXjaddwCGtedFFQgy7vP9eHbaio
qJ2Ak+jvJ+9+JLZ9P9VQu9Tg7qVgXt0LMJmVkR6X2b1GpMSe1uoHfWj/+ipLZkU6
1OogjBZIAomoq0C2P322l/Lw8SZFR3Oub7j7G1QBIdhqlvdrcRtYYlqGA+rmM6kg
y/XUkSFrv5Tf7TKi3/E5
=Auu9
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_07_37_00_+1100_O+I9JuAxaFYHRTJW--
