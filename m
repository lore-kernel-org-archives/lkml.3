Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbaIRArM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:47:12 -0400
Received: from ozlabs.org ([103.22.144.67]:52691 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbaIRArJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:47:09 -0400
Date: Thu, 18 Sep 2014 10:47:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Scott Wood <scottwood@freescale.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the fsl tree
Message-ID: <20140918104701.1f99aa6b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2i6rv9ARndZSc+IqzaRCCeW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2i6rv9ARndZSc+IqzaRCCeW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Scott,

After merging the fsl tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kernel/built-in.o: In function `.dma_direct_alloc_coherent':
(.text+0x14bc8): undefined reference to `.dma_pfn_limit_to_zone'

Probably caused by commit 1c98025c6c95 ("powerpc: Dynamic DMA zone
limits").

I have used the fsl tree from next-20140917 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/2i6rv9ARndZSc+IqzaRCCeW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUGiuKAAoJEMDTa8Ir7ZwVrokP/i8gpNlGCiaQSjBqQLKkZlUJ
pY73GPyDg9doTTWxPzAWSCjKqI47uBoEh+rGbwkQyv8NiZ8wdLd53IChN4Q8VUR8
tewKPRzNHzWPSDNUCPAVZo6LTTSNtU1Jqp5Ci7yarBWRUYRMwrMc+lM/Mw0DzEmp
5+qfYK0Da/6PMTWnxh7DCYb4pKmpT3RThONhpd4qc3yY6+6qxHwSfCoLd1/Z+j5F
blyZ2eynmD8BGFJO42mcAiyTRNNSRrEuXrm0H/5Sqgs7uAp5f1xKdYK1ajok8RR8
o8ZN3px4wEUCJga96Dsyx+8TyifGGD6e1SatQddvmfA0WjXotoaB18ezXCLLZSsd
nHTDSkj6kNR6J4AGTH0/j08k3UjfYcsvfl2EKYe8zca+FSdQLYcId0UXem01ad5+
FDYSeZ8978KxDFqJHpJ0skjkJ2llgIG4a3UFgrmOajM2YrxZR+mUfAgJ4w2UsP2A
SbdzjjZFolxAGWW71jRfwsQXK7QsjUtasAvvBmHuZ2MQ0QofMMV+TJ78ph3Aewgc
fMGW8cgPV8oYm0NggttRaG94NyjwWDiTrW2xTDbU042jI2YxLxe2nE0iU1lhZC+R
8bxD3rOiAyfGRLxxXw/YLTddcY6uaBrdv8NijyQGLhpFpNaEJRTcZfPzWE1LQ413
a9hvA6xARtcfbN6hnpMq
=lL5b
-----END PGP SIGNATURE-----

--Sig_/2i6rv9ARndZSc+IqzaRCCeW--
