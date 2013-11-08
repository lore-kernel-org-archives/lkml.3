Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3KHHPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:15:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59157 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3KHHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:15:42 -0500
Date: Fri, 8 Nov 2013 18:15:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus <torvalds@linux-foundation.org>
Subject: late commits (Was: linux-next: manual merge of the userns tree with
 the vfs tree)
Message-Id: <20131108181531.4fbdf925307f8fe9ed304372@canb.auug.org.au>
In-Reply-To: <20131108175055.4c050e6770e0047aec42dae3@canb.auug.org.au>
References: <20131108175055.4c050e6770e0047aec42dae3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_18_15_31_+1100_j6mXh5plb9uieVvv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_18_15_31_+1100_j6mXh5plb9uieVvv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Fri, 8 Nov 2013 17:50:55 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Al, I do have to wonder why a commit whose whole commit message is:
>=20
> "RCU'd vfsmounts
>    =20
> _very_ preliminary, barely tested."
>=20
> is in linux-next as is not being kept over for v3.14 at this point.

Oh, I see, it was discussed back at the beginning of October.  Pity it
didn't turn up in linux-next then so my volunteer temporary replacements
could have dealt with it :-)

However, it really, really needs a (better) commit message.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_18_15_31_+1100_j6mXh5plb9uieVvv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfI+XAAoJEMDTa8Ir7ZwVAw8P/3BkwQDM9MlkItlu6Ia+EUGY
8FDOgMktno2ET2wVRX3za1DbVLevo9Rl8g28qps6nYj6RgKOYCRC4DI6sl/xyKfk
PD1GkvVV3UsYVgVMoBX3wGXujN/g8KwHWFYnrNJJTZmxZ1vvMUmQGNS98/WexVfm
EDtWbndYJrVjcsjWSOpn0K+C46nhj0ZA9GW0yNB9Paq7mRh7KGumkOivmBaqGnsp
gwslw2Rt25SA5SVjopt+5X4QJiAGWOv1d7NhTDkoZi5bY4fg5V09cRYpSGUYsivJ
vCEcbBywOruPLdDAl3dGFcTrp+Z7PFrvoNJE2hvbhqKXytnMZjZQEu00QpFIr1KY
TJhNYhCu4fh4hzk+xOdBPxQZuLhyIGB+jn8uN/BVj5Oc4ZLG0wQMpCTCOuC/gG4i
TA5NOZSwJ5DjOI/n8rKei/pfWNZ/dcINUm9MCCLnvqxHuK4d+/ig59eGQID8A7Yi
dPGtFKh0IXc+VHj9C2+LGMpJI16lLhFAFDWDjn7shsFew+iRYt5tkyZlfQvdvDx3
/ZxMDfUeyipsU1HZG9zJFqliQ/mdxCgHCRljmMu/gzeefh53Rxo4uEcvNGBqqgOJ
6PErZNHWiPpc0Qw4mzhHUuGNMHWtDhukH1kzOhmZXXqFtRoE8WRXLm5GdsD2Tckm
Ci7qLZDcvcPdbXSOlgOH
=Thdk
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_18_15_31_+1100_j6mXh5plb9uieVvv--
