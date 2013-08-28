Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3H1HFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:05:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55637 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3H1HFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:05:14 -0400
Date: Wed, 28 Aug 2013 17:05:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hanjun Guo <hanjun.guo@linaro.org>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the dma-mapping tree with the
 driver-core tree
Message-Id: <20130828170503.de07a17bcd5994a7434477da@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Aug_2013_17_05_03_+1000_KI+VhXQ6jmsAxCl4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Aug_2013_17_05_03_+1000_KI+VhXQ6jmsAxCl4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the dma-mapping tree got a conflict in
drivers/base/dma-contiguous.c between commit cebcac7c59e8 ("drivers /
dma-contiguous: Fix __init attribute location") from the driver-core tree
and commit a2547380393a ("drivers: dma-contiguous: clean source code and
prepare for device tree") from the dma-mapping tree.

I fixed it up (the latter is a superset of the former, so I used that)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Aug_2013_17_05_03_+1000_KI+VhXQ6jmsAxCl4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHaEkAAoJEECxmPOUX5FE7+gP/39VCaxh2TaObEvQUgM7ddqq
Yq/krbQBz221DMiq9W7ngxakXbt3EwJbEE/ekr4CEKQM/JmMfwlzD/GwbTaG4g9R
bpJW+Enu5QbqrOMA1zb0sboDLDDouD+Z5v0ET7JtUDf7YlqB7CHVZyp91GdgHBel
gRMn32FdezAEfEHyVkBUqEe09Uj4soHDCNFB6u0yMRSXI5gI2EgnjnRCfDZ5danD
Q5khczql+s+tOaQVy8WlXyzmg1YCDHSP5Taejb+3uSaa4vMMuvnrCfv22BGqAdnu
rXOTWe3fqB4cImbPzrx+feo+4CMtBnyEmVUFkHCppozmnxDNppI1EEIrvXkRpVfs
6uHHt2kMYWs61GopoqBt1XKjJp+1BprFSgBdgs4CMvYQDj3gxiIIXIyeHZs447S5
X3jwBEGASxve33eK2HCX697KTbd/MoLTlE47vxX/qeN43pXq1tLmgZBNZ2kleH7T
AmoJKzD1zbE92P5/6hjTEL8nbM5ZR1ID2lQE53nrccaiOEgVArXd3BEYNYX+dvoQ
yFGGcvqiTaBwJklF32AgLyE8SsdZ/+ZMaLHxo+nWDhRvTtI9IQSd/OvPqoYgPTMT
8dGD1wAQs8cYQ1JZg1vxPQnvuUkXUVJrghXLc4VNIdyjMJkA7IWCWHCs1vKNrbva
lCp6qxEKNKG7GbzllRUn
=qXGm
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Aug_2013_17_05_03_+1000_KI+VhXQ6jmsAxCl4--
