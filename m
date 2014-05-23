Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaEWFcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:32:22 -0400
Received: from ozlabs.org ([103.22.144.67]:55356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaEWFcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:32:21 -0400
Date: Fri, 23 May 2014 15:32:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Markus Pargmann <mpa@pengutronix.de>,
        Stephen Warren <swarren@nvidia.com>
Subject: linux-next: build failure after merge of the mmc tree
Message-ID: <20140523153212.40c9cc95@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.utNCsXpI+tSiiVBVlKTI1P"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.utNCsXpI+tSiiVBVlKTI1P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (arm multi_v7_defconfi=
g)
failed like this:

drivers/mmc/host/sdhci-dove.c: In function 'sdhci_dove_carddetect_irq':
drivers/mmc/host/sdhci-dove.c:42:24: error: 'struct sdhci_host' has no memb=
er named 'card_tasklet'

Caused by commit 3560db8e247a ("mmc: sdhci: push card_tasklet into
threaded irq handler").

I have used the mmc tree from next-20140522 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.utNCsXpI+tSiiVBVlKTI1P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTft1hAAoJEMDTa8Ir7ZwVcnYQAIqwfT+ZAgdbx63SjRag6dyt
o9A/4Uy4DDVtPlVeHaTbNNQGVdAcb969QUMwpP3fqlGuh69daE1I2CfwT94i1QR7
zDHYihBbptn4ZzTvHw4TjGTEebwG/ZVvoLxZ0UjKRuP9iz0OPFS8WYFzDeVjUoso
U+qI8sLVZJkgqi/Ko/ABeXiNF6bj2qUTQ7d9JZ29hTQAUmhibdRUUy4xgkd8YmD2
BGI1RMLn3kK5f7iPfJAUTE2EUwMAD7mO1HZbmGEC4uKYxAm61oq45kfWVhazS9c7
m94czOMPEQDrMcnnUG8e/xOtfmj8ZkG09pUE4oERqpw7RA3pofI5o07e6C22UKb5
s7dYrs68GlV+4ObHfSUsH7WUmoC6Cpqur1lp9p1WFnxlVxM1dgKo/Tpgu/gAF58a
kfFPmrXnfwpgpeNc9Ea4E50qdy6uh3vanjrvXj3j6imtfVwMAumcBw6D5F9tHt1u
0fypy+aEfwGFb/4Dyy4wQekY49zvyQUm7jHftIc6gPFHCorDkp3We+DRPWxMsimb
rWdrlhPjBnSa8qn0u/skXcXXsVdyaJHlCPoAdxRW9ZM20D9TwdKjUuzYJGQMAIsm
aT2OtsvxdfA3S0vD94XheeaYsz3MWtLQI/T+zpPXqURVPJ+swHHHJ0MY/rHsD76a
riHoyav7k9uZEwuHCuGF
=+JX2
-----END PGP SIGNATURE-----

--Sig_/.utNCsXpI+tSiiVBVlKTI1P--
