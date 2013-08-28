Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3H1GfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:35:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41781 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3H1GfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:35:10 -0400
Date: Wed, 28 Aug 2013 16:34:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: status of the memblock tree
Message-Id: <20130828163459.3eb7fc0d7ae531494f605831@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Aug_2013_16_34_59_+1000_WSUp2pZMpy9X/j3a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Aug_2013_16_34_59_+1000_WSUp2pZMpy9X/j3a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

I was wondering if the memblock tree needs to exist any more.  The last
commit to it was in December 2011 and was merged into Linus' tree during
the v3.3 merge window.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Aug_2013_16_34_59_+1000_WSUp2pZMpy9X/j3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHZoXAAoJEECxmPOUX5FEyPwP/RA/r1faAPJ4Siaq0C6r9ep8
4uJILjNsiMpAKnDlv8wjkgb5a06U2DqGzyp6XCq/YrO9xoHmAfXocLBXttHgIGU5
/HT0X5El9aq34q29Uut6BdkRq+Z/TF3FznbMqxnmYWI0mxa2AxtdOyRN59YCRGHt
N3ls3g7zPQDuLXh468AO+XhEGsCOnreRxNVX9LQ197/k11wdGQ4aX9tdwzQHrr2o
s205EQ/eCOmLNBjicbwIIlnNFE59lYIYiBBvAe4ihcVqvwW1bMoQjl/MpCMkV1nz
mhp9bbJ2zuFU2ZKT1U0dk1poZATg/gZjHPEYTJJvQmYWDeht1hX7mOAcgxSPschH
g0MZbuAcbV6GDTp64Is+dh9HYkjInHCfOkFbFo6sSdIRUQfvrrwyfePcgFXACA4/
nlUAmztm9HmY2vXjXYQKsRcm1nTX6eOrEFQa5A9RNB+1/2n8dv6IsOEZdBMrBdQc
EICnxdMn1TRIYbTj0tEu7+anKORi2xgUgvIyuwwZ8WMTFCHANF4avS1ql0x8ACls
aPbBvgfXXTHDFlvUiaNjFtlPezet/6TXYF4nByGyueKtpTWz8E+uvw0zlVhYLrXj
KQBxyxxxo/X6qk4GwatHwcMlN5kc9v9XkpFwif4E9L2iuNndYowraZMkiGwz0VI6
Ohsk9gjm3SS/PcPRp7vY
=y8gf
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Aug_2013_16_34_59_+1000_WSUp2pZMpy9X/j3a--
