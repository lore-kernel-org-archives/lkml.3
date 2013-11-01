Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3KAGF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:05:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44646 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KAGFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:05:55 -0400
Date: Fri, 1 Nov 2013 17:05:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bharat Bhushan <r65777@freescale.com>,
        Scott Wood <scottwood@freescale.com>
Subject: linux-next: manual merge of the kvm-ppc tree with the  tree
Message-Id: <20131101170545.380292f4ac4109b8cd3a72f0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Nov_2013_17_05_45_+1100_xT1EskGmA1xRZOJO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Nov_2013_17_05_45_+1100_xT1EskGmA1xRZOJO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
arch/powerpc/include/asm/processor.h between commit 51ae8d4a2b9e
("powerpc: move debug registers in a structure") from the powerpc tree
and commit 95791988fec6 ("powerpc: move debug registers in a structure")
from the kvm-ppc tree.

Different version of the same patch.  I used the powerpc tree version
(there wer other changes there).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Nov_2013_17_05_45_+1100_xT1EskGmA1xRZOJO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSc0S9AAoJEMDTa8Ir7ZwV2ocP/1esZbdj3gQw5B9/j6MSWs5k
0AKBaI+/mjTx4VbxtrGKcwAcvpc7EHitdPfumlvl/oyGmaGuSCCAXm1BUElp4YIK
kNgMSknpSQyPIaSmg2jhzHmjeCb/4uJpCSFLBRh2SPbK+8eYrJeqtjzKEsT75b97
/ocvTtoNyUImY9KebKyFVSgDfXjQ08gkTdxhwGTeLAhLo29JrhyHh4eX4+fDaoJA
ixpD6R9TA+9jPPP4wcvf6e01SsLi/R3EpkMbeajg8vDHXRXXDcJ2F5YKwRc2aC/T
xUxSq00MmBdfiW1Gqad9NifNEgfabJCwr6/V3PVB3nPxccNE48StqYtplHRZeVjP
upTQ8xTGMjfBxvHJUVglxNdqVaR0ZFas28rX2EgKc2waCtgdtL6g12lyVV5k8bfD
nyDnZUxN4x5Kmtt6cOOtJJ+FO/N+2x+MRutnWY0RkTnUsEzg7oJpXy83SeBP2zQ9
LvR7PmvXda63cxtj0dbDBaIfO0plz2ndOOK8Cj9BWSAA5K2+1OD9z3/pFdg7KnCy
IRADeQ8gmL0h3wDcZLkrTnVRCq9sxJJ0k3h8iQS7UX51Bw6qIfnDbGfaBxX6rlTC
NwZ+vumH5IApy4rNdfi3jSZ0Pz+Hv1PD8EBxICBXgQ6LNeB37YW4RUQsaq+S86K2
RauS801JglsQShbq38hw
=nuwj
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Nov_2013_17_05_45_+1100_xT1EskGmA1xRZOJO--
