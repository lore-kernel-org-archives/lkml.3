Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3GKA13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:27:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47078 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3GKA12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:27:28 -0400
Date: Thu, 11 Jul 2013 10:27:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: rebase of the jdelvare-hwmon quilt series
Message-Id: <20130711102724.51608a4ace419b6d42591257@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Jul_2013_10_27_24_+1000_TwZHgtj6iqXnoxWL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jul_2013_10_27_24_+1000_TwZHgtj6iqXnoxWL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Why have you just rebased the jdelvare-hwmon series
(http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/)?  You have
just invalidated your testing and made it likely that Linus will blast
you if you ask him to pull your patches.  Your whole series was already
based after v3.10 (i.e. released or rebased after the merge window
opened), so why move it again?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Jul_2013_10_27_24_+1000_TwZHgtj6iqXnoxWL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3fvsAAoJEECxmPOUX5FEfGsP/izmdQB+nwSrqrKrdKQtZ2eS
L7p+/737iLei/JZPEYhSgwR44xEjuMAB5HI4wv0sFHUF7tXj6eFMsy4oiXwpKz8f
eKgejlELPpvKhr+KEBZCdGUIaEKR9GXlMDKOOLMJGLCn42SlkyI7mPNbosDvpGgc
Fxj36C521xIH5J8taVfdr3kOYb8THic+oS3G67RrQF6MuQDlBuIDdDHTgkLL/8Zx
kh+nVIpA3qFxx+PByESguVhBkcUF6s7IV9dnXuKLLjSo73eFsWvvSd89JR7vmQQ6
QuOMVoxlBANZT3wiUXFp5meCC//+1hUMnsTWbTF6m0oIMGgsOq5+jK6k/nD1xd0g
AG6T5rzb+9Uy7694uzDOSD8omF63AGN0exI+mFsabOTp99Gh/q6tk5B9fLWBYjiB
9Io7vWU98W7CEAuSLRHrrLTqv4BoB2X1p4NT0VhUyLvBKeo2ccfR8Dodu63RIRlQ
AOhnf+43LeXSmQ2Z50m8/ABQoNsgLk58s3bzEaJ/hjl+TSVyiFBOgHZ5dDqjZ7aV
KN81gFK+lTElZxaWR+kb/rMvpZ3WWxgJ1QeAcrCJAaCyrOdJJwdm/5rjrSZkmXK4
T8AUZHHE/680E6PtXL8a0DOUDoHpfR6xikVT7T3ha+bDOe/ouGBoBHx1nGkBNU5E
mKZYNen3cbod0ZVpAwB1
=Xz0S
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jul_2013_10_27_24_+1000_TwZHgtj6iqXnoxWL--
