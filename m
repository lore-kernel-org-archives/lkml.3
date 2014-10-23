Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaJWB2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:28:31 -0400
Received: from ozlabs.org ([103.22.144.67]:47081 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaJWB2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:28:30 -0400
Date: Thu, 23 Oct 2014 12:28:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: linux-next: build warning after merge of the block tree
Message-ID: <20141023122822.2c362904@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iCQIDrtkHtVZ_uUQ27hVj1W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iCQIDrtkHtVZ_uUQ27hVj1W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

block/scsi_ioctl.c: In function 'sg_scsi_ioctl':
block/scsi_ioctl.c:520:1: warning: label 'out' defined but not used [-Wunus=
ed-label]
 out:
 ^

Introduced by commit 374f8fdea4aa ("scsi: Fix error handling in SCSI_IOCTL_=
SEND_COMMAND").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/iCQIDrtkHtVZ_uUQ27hVj1W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUSFm7AAoJEMDTa8Ir7ZwVkc0P/0PMOSaam2qgDaDJP/gFSjQY
x0nz/IMqWlgJWNvUXrS3x2RbI+wEVw9EpELV8/if10jc1pY1N8ivY7w67lzvxahc
/6+Bo/8IF9Ev6khk2scZdIn7yBE4N3vid9634FDIcm+XhTlsHKTPw+jI7aSOy2hy
BW3dnJFNrGPtlcs52kVfIvODmmYW98lak6GHjRn9GkqXFUOZ7XT+QXDbT3E2JX4X
nubjrqhbtiSLi1LC0fql0uCgyRQbUa2pf6Dn+AdsNoZTHMZz1XDkN8WJPdm6OOXw
hJME+kuTpKH9y1SJ7doZx+qlJREUMoblP8Ya5bnzTqN0FozUYHm/4LkbMG/PuuLH
4awk90a2YaP3dWEOFBmxIDU20F7EAdgbKaFLGid7W/Ss2eXvfEoQAxe7fGyhjdXm
9A+IYq9nThCBShC1yHxrlownMhF/6IinOrSN/6xjGJIYqu1ej6BN01e6dhpJqcK0
YmArkAuYndZAqaghxjHoNfndMfj0RGzZ7d/xiuxQvoEAMbNGtljzKuCZ8ZwyKHxT
bNrm+Y+BHs7FtkCEzOaeZIQlAPkVdmY+13ost20KapLh/PEWdFHTBwciBKKbEGPe
SwrM06OohfRLzApTLLlBskBHJlKEVQiO2Bb9rb2yx4O+lYDNm77mxybmCA97EmJw
BL1YFGwc2o4yDiA3hmrZ
=l4vo
-----END PGP SIGNATURE-----

--Sig_/iCQIDrtkHtVZ_uUQ27hVj1W--
