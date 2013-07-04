Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3GDE7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:59:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50437 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3GDE7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:59:09 -0400
Date: Thu, 4 Jul 2013 14:58:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@purestorage.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
Subject: linux-next: build warnings in Linus' tree
Message-Id: <20130704145852.44975d5801f592d00807d1c0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Jul_2013_14_58_52_+1000_y/PfMes75x=ATTjR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Jul_2013_14_58_52_+1000_y/PfMes75x=ATTjR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Building Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced this warning (these have been around for a while):

drivers/infiniband/hw/nes/nes_hw.c:81:23: warning: 'nes_iwarp_state_str' de=
fined but not used [-Wunused-variable]
 static unsigned char *nes_iwarp_state_str[] =3D {
                       ^
drivers/infiniband/hw/nes/nes_hw.c:92:23: warning: 'nes_tcp_state_str' defi=
ned but not used [-Wunused-variable]
 static unsigned char *nes_tcp_state_str[] =3D {
                       ^

Introduced by commit bca1935ccdec ("RDMA/nes: Fix compilation error when
nes_debug is enabled").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Jul_2013_14_58_52_+1000_y/PfMes75x=ATTjR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR1QERAAoJEECxmPOUX5FEwDwP/3VEhP235gXs/Re1EMPhRGsF
nkVxYtX+RHZ3DeE0Bcy5cNDLDBqhNtyRd0XN8N68sT5JzJtB7lEr4K1zOKhzZAoj
y3BAPL0QlpVy60rGBIVsT7oAryptY831eQXMY2MZhFqPtczjaQdz7XmWVf3evMuN
MX1C14L+eIWK/UwUAIkKQ3WIOe/2GujEZCqIfP0zKBXr5a9Ze9Xu5xryW4Pz6Kvy
Uk/FHA66/hkr/UpLs0/+pJJGHiYKD098Nfn5pRJhnV0h2Q6/KASKWDUbOEqEkijM
H91B7gFP+amum+gqjFvfFv9Z5c0eueYNfosXFqXqb/q95ZDof7xdtCINQc1THOlD
5ENI3DfhLGuOg6SVExyf7iQ4UxspnflzZcYWjzguRHPW6TSUW5pXON4hMPMisSBZ
AAu2nvnXi0Tk4P90SeD0Cbr2C/tUagEqXjCovQfVHKSrHum25/n6oz+nWnjDEBsd
Z0q9U1CSbvSf1a7sS9aizkOAXtY4FkJ0Mtva3rH0ynQSVc0JuEqHO8d1F7cWy90b
fFxRVbRcmIZvdEBlIyyfWgsPcH8XNv4Z/2vlQiEBW4iqr3taWLVGAZRqfiL/cr+8
qPzlSGZC+rlOulyCdBP86E4exwzlELirSb9bOm1Q/Xw9s1rI8Qii8y0HHzKgoZSN
BWTlvv9RRi8RDJCkt7ew
=WV3k
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Jul_2013_14_58_52_+1000_y/PfMes75x=ATTjR--
