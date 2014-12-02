Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaLBIga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:36:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaLBIg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:36:29 -0500
Date: Tue, 2 Dec 2014 19:36:18 +1100
From: NeilBrown <neilb@suse.de>
To: zhangxiao <xiao.zhang@windriver.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com
Subject: Re: The DM_BUFIO_HASH_BITS is defined as 20, any plan to make it
 flexible?
Message-ID: <20141202193618.6d3adb22@notabene.brown>
In-Reply-To: <547D790E.3070803@windriver.com>
References: <547D790E.3070803@windriver.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/iqrv+YBv2YSq+gkIP4eRvf."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iqrv+YBv2YSq+gkIP4eRvf.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Dec 2014 16:32:14 +0800 zhangxiao <xiao.zhang@windriver.com> wrot=
e:

> Hi NeilBrown,
>=20
> See drivers/md/dm-bufio.c as below:
>    50 /*
>    51  * Buffer hash
>    52  */
>    53 #define DM_BUFIO_HASH_BITS      20
>    54 #define DM_BUFIO_HASH(block) \
>    55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
>    56          ((1 << DM_BUFIO_HASH_BITS) - 1))
> "drivers/md/dm-bufio.c" 1854L, 45375C=20
>=20
>=20
> DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
> use case with limited resources. Do we have any plan to make it more
> flexible? Like module parameter or something else?
>=20

Thanks, but this question should be address to:

DEVICE-MAPPER  (LVM)
M:	Alasdair Kergon <agk@redhat.com>
M:	Mike Snitzer <snitzer@redhat.com>
M:	dm-devel@redhat.com
L:	dm-devel@redhat.com
W:	http://sources.redhat.com/dm
Q:	http://patchwork.kernel.org/project/dm-devel/list/
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm=
.git
T:	quilt http://people.redhat.com/agk/patches/linux/editing/
S:	Maintained
F:	Documentation/device-mapper/
F:	drivers/md/dm*
F:	drivers/md/persistent-data/
F:	include/linux/device-mapper.h
F:	include/linux/dm-*.h
F:	include/uapi/linux/dm-*.h

NeilBrown

--Sig_/iqrv+YBv2YSq+gkIP4eRvf.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVH16Ajnsnt1WYoG5AQLYrQ/9GmB7gctdLEMnnmeWEW3xrG0zdylEqsXl
bETJLu3sS2NHwY5t0hiYBpTZBy6G1OlpNpVN5Xx47OTYYx76ALCXAgxwDjImEhKo
Gm6fJo0M35iMha4CwOttqzvdGVyNPDIC8V1sqICjuwT1UHgbH8vhuV5G8hGy2gRw
2ldHR5pyITyExkLyE/h6OVfjzzSvEx8VVE+q5pWrpVU3pVfj7FYVlvELSxbBEvlW
F5bRfYpoIgz7cgz/uL33EJDBlK4j6HnYzPPCJ18N01XYM/Y6c0S15ly+4P0mx3a/
OJQfCECn7uVP6KlFBV7VQnVS2/KbZdbuneDHUKLRBi9ol+8/7oErThAFsanDUZRP
3Y5Ywdsvv3/h109XeV3B3+UuTppzX91vS6ZKA7tIvSSWzuLVGiGEICgCkBdYeRIN
6lwqSn1tWUq/QYIUi72+0lgxqw/uJ/xUVkGfNaVexEho1wfvQ1YauHopyIR6C2St
k5CPhJWQTA3F4QxN5gbyLaplV4LdPszsHdq4BOn3ovJzloekquHMaQWaJako/+3X
5za5/7bFfSEDF0wQAvA3iS5UgQBAG6PE9o7J4XIZlgDe84GZ6XzzYrwD9G1cMOPm
g1piV8baixvsGUb1EJcYKzkiEhBH6aiyJWQSaYAsCGf+eqSPSujn1FzNjsWTM4wi
slvLd7ZEAnw=
=Mt2m
-----END PGP SIGNATURE-----

--Sig_/iqrv+YBv2YSq+gkIP4eRvf.--
