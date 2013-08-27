Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3H0KR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:17:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52800 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3H0KR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:17:28 -0400
Date: Tue, 27 Aug 2013 20:17:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the cgroup tree
Message-Id: <20130827201716.528af63c96b66bb2446fc4b7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_20_17_16_+1000_UekfnnaPGZXSR4Aw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_20_17_16_+1000_UekfnnaPGZXSR4Aw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the cgroup tree, today's linux-next build (i386 defconfig)
produced this warning:

kernel/cgroup.c: In function 'css_from_id':
kernel/cgroup.c:5723:3: warning: passing argument 2 of 'cgroup_css' makes p=
ointer from integer without a cast [enabled by default]
kernel/cgroup.c:237:36: note: expected 'struct cgroup_subsys *' but argumen=
t is of type 'int'

Introduced by commit ca8bdcaff0d7 ("cgroup: make cgroup_css() take
cgroup_subsys * instead and allow NULL subsys").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Aug_2013_20_17_16_+1000_UekfnnaPGZXSR4Aw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHHywAAoJEECxmPOUX5FE3FkQAKXwiIkYSNqui8B+5Enj7rAD
Y3p9reaCL+Ug8ppDdThjdPcthVoSAw3FPgqH1bgDqqI34SfY3IEjF8bwEUnPqCr4
jkqMvtFKCgvWTOfO7TASGmVr4/8X1oz8BbzVZY5tzCccxLgthbjdhU+2Sleb7KW0
6x1LRVMGJPbiqU8wvvUZsEfuYuQlK9IKlJieKW8FjDenzWnRhWNePSGD/Yw/9uYC
PxpQJgm5DVrgV3FK8wVWLSxCXpEOSDokeCtmEuhbbUe6jBAfiWDzLdcmZE3nVxiE
X2MssBX9eQ1f4kBGGm12H8IuZrrevsX1c817rzYvGCM1vB2cQLq5wLgOdHcv2A3S
CImdlEheoa3J3ukpndra4exaxygqgXeJQpxptVYYZVlqg3SrQLr4+5160dFTaStd
eZU6TtM/QJmHDghjL19W6Hkx4/4OyK1fRlqr5OBdo+YCfU4ctZg+i14/8akAJuW6
z9RzjXWK/se80QDVsj9JVn+kjexC8ZVsEFs98HbobuH7AbBcKEramZikZUB+U9Bb
YPo/ROP8JHhCiYa4V0KN3ZYekauth5U+2sf3Ld6uOa5Rv5bZILMSiK0FdIS/AhuH
H9O7WFx0NEaRLN+e5RKeCAc8v/y3ORlQXhAsKk+uW4EfWAQNtsveXlwp03e5r2VT
/stjoZEN9tJVVlMe1wVc
=LDOS
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_20_17_16_+1000_UekfnnaPGZXSR4Aw--
