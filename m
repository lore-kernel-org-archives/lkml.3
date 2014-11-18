Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaKRIWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:22:03 -0500
Received: from ozlabs.org ([103.22.144.67]:36431 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaKRIWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:22:00 -0500
Date: Tue, 18 Nov 2014 19:21:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: build warning after merge of the scsi tree
Message-ID: <20141118192148.1c77179c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GQfrx+RN=pKpBd0idFwR6Fl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GQfrx+RN=pKpBd0idFwR6Fl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

drivers/scsi/ibmvscsi/ibmvfc.c: In function 'ibmvfc_queuecommand_lck':
drivers/scsi/ibmvscsi/ibmvfc.c:1618:5: warning: unused variable 'tag' [-Wun=
used-variable]
  u8 tag[2];
     ^

Introduced by commit 5066863337af ("scsi: remove abuses of
scsi_populate_tag").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/GQfrx+RN=pKpBd0idFwR6Fl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUawGlAAoJEMDTa8Ir7ZwVRbcP/1Wxq69z14jsH/wxFUgS3W03
dEMKhE8G27V4Y5DDGi6ZMyJpkc56Sr1RMxZXLOZgkOTgxLODoDlH5O1pzOzKA9f5
gpD1lBezYbvTorjGIU80GmyMGFQ2mtCz6V7y4qzj1T2eYs4ojsA69g5AohR7C5nM
pyVp/T+XU5tJo+r0k/xjPPi+v6lEIxZR4GpQE2r4vLWOcTEOd/DplnOGHDdeODo0
8DxoIF9gdGdYf8s/M0nhaX1uBZEbNVgzlaSiAHVII7axPQl2sad3Y756NOO1Mtpd
z73ryMGu5nT2fPQLkcZk8sutfKQ4JMG5rMuU+tUtl6KuM//ceX8v8WQM+Z/YvCs9
63hrhSMXFjVKJJlHsZYH+VCxAXrxvZeHOXXWYHYUqnUQHCpAhJMoeI5x3y/w4M9e
SiO0rTN28nN4gzzm5M0hmQjd/KHhEWcVvgURAT5n/KW6s+XIb/0QCnwZxvhoTtGy
BHf0DPASYbMbh8SwzzPA6FGaR5TBQfHDNUD7R0NhLKdGYDcJGvG7fOT7HvhUIXrS
XJuQNC7gR0Qtsq6IDe35fgZ/SFIZobr4/3nYCSaBjQlmkIMra2qBrSal48uCP2uc
TvVNo8byv433RjPapV2Y+RV4sl/sUGBNzumCAJ6d7EiKTCevg5JunpmALE0VL2Z8
nig2k9wFyey4eKVuWmsY
=blrP
-----END PGP SIGNATURE-----

--Sig_/GQfrx+RN=pKpBd0idFwR6Fl--
