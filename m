Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaJ0CUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:20:09 -0400
Received: from ozlabs.org ([103.22.144.67]:53614 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaJ0CUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:20:07 -0400
Date: Mon, 27 Oct 2014 13:19:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: linux-next: build failure after merge of the bluetooth tree
Message-ID: <20141027131956.68b62e5e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/CJQ8pJL_ynmO042=+mnD8Gq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CJQ8pJL_ynmO042=+mnD8Gq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

After merging the bluetooth tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/bluetooth/smp.o: In function `test_smp':
smp.c:(.init.text+0x0): multiple definition of `init_module'
net/bluetooth/af_bluetooth.o:af_bluetooth.c:(.init.text+0x0): first defined=
 here

Probably caused by commit 4cd3362da899 ("Bluetooth: Add skeleton for
SMP self-tests").

I have used the bluetooth tree from next-20141023 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/CJQ8pJL_ynmO042=+mnD8Gq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUTavTAAoJEMDTa8Ir7ZwVP94P/jLxrX8EA4jElruTe2d/0IIK
H6Zjk2agXSY3Np3V4RUXyqUZBzUsGqj0+eUBauJ47EY3cXPlJ27AEeFImQm65MWv
yQjrmRrh3IogUMGMANsKug4yqGiq+h3ZzVRVvqtzaOMr8S3cMYBY356MEDUx2mjc
6L7kS6n7h3xb6SIDczjwCZCMPv3t8loVf2O8LTbMQ8L0VwJZB0NnukzPFOsQhwP9
JLccevMlImomLTEODQDidUUR13ZfEmNCf2tCuC2F+L6gJ91b1rV9JYa6R6z1eCEA
YFm/nv3huWh8vOwVCcstrFpYJBcWUgmaMttaZH/wJ9PMR2n8TpLFLGqSTFj+If6c
7C3b/A3o42GouQeQStcAn+vaWSynz0uKhV3+rQldFeOLXmAIMyUsXH9J50P4PAa0
scZaHiX6qCz4xSQ5lPFM0cx0vl+sSUYGh5v0oMISJA6pMUhKANVR04OFXJMHzygj
M1mQhDAAAx6DjcW0dWuhYhAnuxXGQTLzaVsZzcoNWaomNG5ZS7QhpmGegFRzu51Q
bH8lu8ihOl1NNSeF08z1kNfdnejvDCIynPv+s7KfAFF4Dm0hbrlZsXiYrSIFu6VS
uiZrDZVv3JVyX6JroujivY5RB2W6/6dmGpAY0oTRwJF2/TprCYVhMCgcoCn5l4K0
zlG9xwnNunUjMyVfzqT9
=VPuR
-----END PGP SIGNATURE-----

--Sig_/CJQ8pJL_ynmO042=+mnD8Gq--
