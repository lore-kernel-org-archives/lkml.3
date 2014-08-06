Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaHFGbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 02:31:55 -0400
Received: from ozlabs.org ([103.22.144.67]:35300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaHFGby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 02:31:54 -0400
Date: Wed, 6 Aug 2014 16:31:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: linux-next: build failure after merge of the powerpc tree
Message-ID: <20140806163144.17b87b0f@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wxRMqA0QueYHEwUOUDB2LvG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wxRMqA0QueYHEwUOUDB2LvG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the powerpc tree, today's linux-next build (powerpc
allyesconfig) failed like this:

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backw=
ards
arch/powerpc/kernel/exceptions-64s.S:866: Error: attempt to move .org backw=
ards
arch/powerpc/kernel/exceptions-64s.S:890: Error: attempt to move .org backw=
ards

Its back again and I have left it broken.

Maybe caused by commit 0869b6fd209b ("powerpc/book3s: Add basic
infrastructure to handle HMI in Linux").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/wxRMqA0QueYHEwUOUDB2LvG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4cvVAAoJEMDTa8Ir7ZwVIkkP/1Xv1XQgMw5mv4a+xw59a0lI
lixyth2h2i5HHF4GRfAt3QR/B5Kni9M7B3a0TAoipsl1xtRyIz68DweEU2mR9r9q
kw7vnHkX50ANnVsNFrBnK4dOzeRfsVSJp+z9Xyal2hyIwP5ETSdw/dKR4JwLvnhx
RL8SfJ/L9w4e0+gvIPA/Ip1W2NDTg8OjOuljIGd1D4Mn58JcxY+XVapxZgGE4HTf
qc1J0WX62WzfD+cnbKT7zl9bO2SrJf2qc9BXis01g6Q6hlQEJ6mUywNCSeMLGHFo
Byz2FKqs9c1ITKe3+jL+ldA5VMNelaAhHxwAPRtcxwmW4jL3Ib20ITH86GJS87RY
sRhxNrdwE8aKlEGoDoz4lKhumooT7Rk55z9oQtyaDkpArOpaT3fnCOA/W7GFvNA8
u53RIQMDQkQrc3Ym1MtK6YJUzcm2mFwnz4mJ25GZccK/PAyUSKE52s6Bu28WqYbH
McMKfZ0VntRjYJrqDAmoa6vxQgo4Ls9shpzxp+vOznoy+13Ymi4nMERrOO/Hggt+
03kD1kyJHWCqCBsutZrot7bdqFBcPRmZL74xNnfwYuVSVxVyIWQOhswJZQPl87Hf
OKCu8jw0EYsC5LOPftEF3R+IOJHU1Z0d4TrSfulB5mgSOtR0hfbLGUPOHgUc+Guc
Iy2O8lKvKlZYzzryRZ18
=N2ti
-----END PGP SIGNATURE-----

--Sig_/wxRMqA0QueYHEwUOUDB2LvG--
