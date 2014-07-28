Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaG1EqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 00:46:20 -0400
Received: from ozlabs.org ([103.22.144.67]:40264 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaG1EqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 00:46:18 -0400
Date: Mon, 28 Jul 2014 14:46:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sonny Rao <sonnyrao@chromium.org>
Subject: linux-next: build failure after merge of the mmc-uh tree
Message-ID: <20140728144608.7d9ac736@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qE5TVZNiBFye5C1xmgY3c2v"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qE5TVZNiBFye5C1xmgY3c2v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ulf,

After merging the mmc-uh tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/mmc/host/dw_mmc.c: In function 'dw_mci_reset':
drivers/mmc/host/dw_mmc.c:2262:3: error: implicit declaration of function '=
dw_mci_idmac_reset' [-Werror=3Dimplicit-function-declaration]
   dw_mci_idmac_reset(host);
   ^

Caused by commit 25f7dadbd982 ("mmc: dw_mmc: change to use recommended
reset procedure").

I have used the mmc-uh tree from next-20140725 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/qE5TVZNiBFye5C1xmgY3c2v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1dWXAAoJEMDTa8Ir7ZwVN8kP/20cyDoQGVxgE6nxYTeGA+D7
3Y67ZKuv125icmD5zRfb8zMsxZy8bbWWlj1D+eo5hR1cw6THjEt+xjkIKM9PISpQ
H5uJFpNAwYn239gduOEV92bZdAt6KADldXvMbxt/UGfixhpPdHxikIC9oNBN4xgn
ZMRBKmB/mreKwDRiiWpc6fC7z+XwvaUYl3B2Og0oHJ8mqJ4A86n9CVJMcqu1H0n0
ejQY7+qKrgfDfGFBtSuflyrxTMF8Yz9SZb9yaxUz+XymCNMwnsEphejWySrjGrRo
3sOfNfP/HsRiAqCcLzcxbDWw82Kyde7lWU6Fmns88roJkT2EhDzsLDVRoZLX5SrG
2SRxKZGpc1cLBWAl72M7ORWpRzjIMFx3v7Wi4c1laeA3oHOooXf58kFu3y+ppuGJ
CWwY91WtyKcTZcB7/AZ1+E5vKMS64QjcS/syoxZEE5PqafBKkZGwZ+nyi7IAg+fd
1AUB4jgzPejfK+KR7QL9OnxS8OCP99gVr239Gmj/cvTHzUrmX6FNH83ELQm501VD
hhX0MzzqOhoJqkXvAjV5sl+2ItIyj431s61htmW7t6tHkRUHfNg+an8HIW+FFhjX
ybSVr7hOMHuQ0Au/FWO50i64m12swja1GZfN5l3e2mudzJJkLeWkucXryCqOwaCK
mUapo6hYttzGkUPWh/+N
=9nA/
-----END PGP SIGNATURE-----

--Sig_/qE5TVZNiBFye5C1xmgY3c2v--
