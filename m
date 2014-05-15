Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaEOGvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:51:49 -0400
Received: from ozlabs.org ([103.22.144.67]:56541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbaEOGvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:51:47 -0400
Date: Thu, 15 May 2014 16:51:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Scott Wood <scottwood@freescale.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: linux-next: build warning after merge of the fsl tree
Message-ID: <20140515165140.15a0d182@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fl0SRKCZcIN8uwnBX9lDjaR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fl0SRKCZcIN8uwnBX9lDjaR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Scott,

After merging the fsl tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

arch/powerpc/kernel/epapr_paravirt.c:33:13: warning: 'epapr_has_idle' defin=
ed but not used [-Wunused-variable]
 static bool epapr_has_idle;
             ^

Introduced by commit f9eb581c63b2 ("powerpc: fix build of
epapr_paravirt on 64-bit book3s").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/fl0SRKCZcIN8uwnBX9lDjaR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTdGQAAAoJEMDTa8Ir7ZwV7OsP+wSRXYiuvu6+iEyQLpruIBFz
3VfG0MzUTZ3WfnfmDDwdW0Kdzhon9YtZUaQRkCNzYLGEv9Ax6PnCnUUPrPrL1JiR
XAFN5wS2MzNctF7px38PxAIDYzJ8Ju1dpFR+TSleb6+SpjL5yuYBVmXVRl+U+w/g
uK67ah2oVqeUVJqQl6oZaMb9FuqjgcfDhUOr1niBqtZGaJJ8Lh0aK+Gz+DGiBW7H
J6LMIOpdKB3pEWmTkUg0xJlW+8Qe109Q9+3MmPizM99aTtDc9Eyq59hFwk3T7ile
26HeAqZJNPVOV6G7pW89bIgra2vv+G72OPkPyO+4NsvMCxPZG56309c3AHpIGKc6
t4Gnn7M+yYXJZkN1lBRy6H1cfPQ1GYJJ3sojZwafM85S3GvI181TWrhkICoa/iL7
FinEdwT2cKRxxQe9i2+MO54a8i2n52mOb6I66hDeYfQeIHoUy8eDAE1AinFQi45H
gSxsPp3ZiILH3bo2l0M7+EbvLMiVU58q3uc3HvF7ZvGNrP1rzy+kuASWb3KuWHvJ
m8LW8eC+Wzu28MrpOSIxLUzOBpRNsSzTTLp5s/vDbkLJ6a1BTUrO9SMKA5+F8E7n
mn9q+NGlkpybA4rvDxKlgdatDr1IueVF4z1dQYuGicwvGnRc/59L0PG/yuTEuRVG
K3KIddJ+yGsEstFpIdjT
=4u6w
-----END PGP SIGNATURE-----

--Sig_/fl0SRKCZcIN8uwnBX9lDjaR--
