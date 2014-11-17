Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaKQDoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 22:44:55 -0500
Received: from ozlabs.org ([103.22.144.67]:43790 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaKQDo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 22:44:26 -0500
Date: Mon, 17 Nov 2014 14:44:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the block tree
Message-ID: <20141117144415.6af6c9d6@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/T6G/Cnpb4G3=+WCOXBQIoXo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/T6G/Cnpb4G3=+WCOXBQIoXo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "blk_mq_free_request" [drivers/block/nvme.ko] undefined!

Caused by commit b94ebc3c7a0f ("NVMe: replace blk_put_request() with
blk_mq_free_request()").

I have used te block tree from next-20141114 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/T6G/Cnpb4G3=+WCOXBQIoXo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaW8VAAoJEMDTa8Ir7ZwViGwP/iLPwdUUtrC9UFEHEgIbLciq
yXNvVGWZysjavibjNxr+cdMchjqm8TDZW3IpGiQbgum8qNinaCccXj8wzSUOJchi
zYcKFQSn9XzaUhuErkCJa5V+b/WiFLnC2TpQI9fqDoz1qNF/FvN41AOlD8ESg19q
8OuvVZP0aP0cDByp+eJgiXSUZtm5HZuoiIAvDAjQQH2K0N2jnnieAMKWM4E7IOpP
EKtGqVwXC1CLq1bNnauNSs11VYbV4bDQTclGU7Doze9ppOIR0ororvXJ84Pp2rtS
9aqf9OidQVZvPnkmFTVGNaS06arrcPXBjfrVH57FGy43i/7nBRVNWvoEfiee5TuG
1yHLyqruYJ5l+7vUN7KvBnXTKycKQW13pu13/to2PBB/NGZvDTV1oultkzbMrZzr
GN5gTUh76gAr8Oc3pRcFgw5kgqBhpBMgyqjsxJPVr33YR8xQD8l5vp0QFTehB2cK
QAhS4hBho7BKnvXeSLTGMQEsYqqrkUca2qUkU5yel9zP7JeLW4wh4ZiTC4kCnHwI
BVq7DCjvMv3bJP4wpwzOgTkxyIr73MnvikYzugzAZiRCuJgMKA+EhzHeJnTD1yfB
bPknLmYRhJNft8Kh+HA9ylXlALfVeOVh87E+F+oezTIFznNACctIIVXSOZ5l0oxh
7M3mMHFIM69BC2ekMI3I
=E2fg
-----END PGP SIGNATURE-----

--Sig_/T6G/Cnpb4G3=+WCOXBQIoXo--
