Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaHDGZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:25:59 -0400
Received: from ozlabs.org ([103.22.144.67]:54527 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaHDGZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:25:58 -0400
Date: Mon, 4 Aug 2014 16:25:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: linux-next: build warning after merge of the security tree
Message-ID: <20140804162549.28c9889d@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HbtxpO+evLniD+aWqn_4kmv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HbtxpO+evLniD+aWqn_4kmv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security tree, today's linux-next build (powerpc ppc64_de=
fconfig)
produced this warning:

In file included from include/net/cipso_ipv4.h:41:0,
                 from net/ipv4/sysctl_net_ipv4.c:24:
include/net/netlabel.h:527:12: warning: 'netlbl_catmap_setlong' defined but=
 not used [-Wunused-function]
 static int netlbl_catmap_setlong(struct netlbl_lsm_catmap **catmap,
            ^

Introduced by commit 4b8feff251da ("netlabel: fix the horribly broken
catmap functions").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/HbtxpO+evLniD+aWqn_4kmv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT3ydzAAoJEMDTa8Ir7ZwVRmkP/1uwVTFvoRtYR0njV9wnqg6M
dVZEW6Btgu1FHhPTbqgHP3+xPAoF9oQ7s0ml90l7aentIdd0UIELrrpO58m8mIdu
DLGnQk4sBg4cse9M2rPa2wvibMfzZpGc1F3nsGIog1LEZmjZ9kmlZjuXNdG5D+ky
fl7DGts7Q2ONXd7gZsRvi533eIc0IzcQLI2MJ/K0daWpMv1V/0xbjCXwqIHckBqJ
3uZswHQfMNe07O74lXXVx+WT69NRuDBZ39Wd6bDEKS5W09gGLADjrebyi4zmDNV8
/1fDZ+QauTXz5Ls0vu6kySuCBcoOaSs92WsUokSFMkMgxzGDkJZOfg1xHKulYhbe
YXPewL5bmS0M8PfD7fBRJI8ckPks2hDv+PlHBv/Ui0nOh4fA4KoHij+6JP2+t3P4
jlZZlNV39T32Fv1AMk2XGyNtlxfaKBDU4vl3nZmBTyEf5M/vzM30kHFZHNDGOG4W
yT3/q8m5zaQIxKXdvfpPdXmuW2HRERHFDQA8Zq/MIupP5qo4+YI3rBfJTQ/Diy+E
iPzRDwI8Q6XNiIivfjVD4aFFVq50LOZ8hXpWcY9ajnt/1fEXD+CnVd+RLfx6TYlm
O5xDcuYAOzOG9hW2eGao3ae3/okHlbV4xfgP0n6Ul75QHLWG01cfAp1f1RlPeZu8
8C6vLURMqEkvlw0Rs28W
=Acn5
-----END PGP SIGNATURE-----

--Sig_/HbtxpO+evLniD+aWqn_4kmv--
