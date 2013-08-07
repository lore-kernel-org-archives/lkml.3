Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3HGEZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 00:25:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54682 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3HGEZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 00:25:41 -0400
Date: Wed, 7 Aug 2013 14:25:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: linux-next: build failure after merge of the mvebu tree
Message-Id: <20130807142501.79fea47cae17a6a25f1e719e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Aug_2013_14_25_01_+1000_rLQMmm4gx0P/1Wg1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Aug_2013_14_25_01_+1000_rLQMmm4gx0P/1Wg1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the mvebu tree, today's linux-next build
(x86_64 allmodconfig) failed like this:

arch/x86/kernel/x86_init.c:115:22: error: 'default_restore_msi_irqs' undecl=
ared here (not in a function)
  .restore_msi_irqs =3D default_restore_msi_irqs,
                      ^

Caused by commit 8f400e08b197 ("PCI: use weak functions for MSI
arch-specific functions").

I have used the version of the mvebu tree from next-20130806 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__7_Aug_2013_14_25_01_+1000_rLQMmm4gx0P/1Wg1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAcw7AAoJEECxmPOUX5FEs6YP/0xu3yQnEtlLhkbod6GHczMR
D3RCWMIPJUXJZ2wzhJHkQr4SN4oG6Olu995aKzCZfcY2y0oqDtA5cZcGsz/nA8mN
g0jmZ6WGLHBN1L7z7xmfJO5bGC6AAKQZV9TKlxLvqhXq1TmBqOZ7gdfo7u9lkqGI
Wntw45xdYWNkwLSrp+Whf3tylntR2bG0FPxJVjBKNiyOeJK7SGxo1RRIJS0qE6Oa
n9RWN6ZYGqzzc1ON+Hf3lNi6ZywLYkr5Wcz4ksDAsILqrtp0FJvpC7+azH19JuY2
JK0I9IYP9tC6/KQ8HHOkM4wTh1qCzIkE66lPMddVEJg/AmstyQhg3BUjYsYe0QcC
XS/vhlai6rd5hBBQ8zGA1KBxaqhe3CfOkJSAlYIWfzzSPbWRyZWnJsRRW09lYQ2W
Xo7IEl7ORbi2ROn1orqPE7vRXkAq61Jnerdkmw0clHtcRGDcbCdbmwnuHs+xFLmS
EVb6ryUwLGjB27r69yZ3MrLdnRQaZ+ID+HZT0A+cSLz6OkNR83seI2HYyBZqOAkN
j9Vb89tszkNFFLR/hSMRIHiI2R8GmrE2AB/Fdfoseej53hOhSU8VRFCo30n/bbPL
4FR3RKYOcTKBX97AQHpHQJe6T11/e/NrO2I+02XFH9ClRlbDxmyCskXIHnryVrm5
af5ZMx0m2YE7NFRWlKJ4
=Tyic
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Aug_2013_14_25_01_+1000_rLQMmm4gx0P/1Wg1--
