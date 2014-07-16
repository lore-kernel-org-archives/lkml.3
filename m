Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812AbaGPGrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:47:03 -0400
Received: from ozlabs.org ([103.22.144.67]:51827 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbaGPGrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:47:00 -0400
Date: Wed, 16 Jul 2014 16:46:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-ID: <20140716164654.67300e1a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fT/s3CMcpdi.N/Ijy6ax_vv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fT/s3CMcpdi.N/Ijy6ax_vv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/media/sn9c102/Kconfig between commit c0e11a2a24db
("[media] sn9c102: remove deprecated driver") from the v4l-dvb tree and
commit cfa880069d09 ("staging: sn9c102 depends on USB") from the
staging tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/fT/s3CMcpdi.N/Ijy6ax_vv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxh/iAAoJEMDTa8Ir7ZwVxmAQAIfIt09EEf2YuF3IO98RRa89
xJsJxR+8Qr8j1wFpuen1OF+OVYFvy81wEIPAWqnaIbbByb2Kww7dopwAvYVVrpZh
iailDBWM16k3aMNbMtGOgvbLjmCEjBGFrYjHh9H9FdYQBZ5djSQxsZ9Qp1OA7uEG
EPDG5famxrQOA/8aWVd17QEaWIJwwY+4YfprRZSt1f9EudT84g9SteKqqM4tMOz3
s+MG2vj3CKnIp1OhqwT3zEnpZlNzO+MRNpbHWI0H241L4xslQ/pilBt4/17PyKtt
TaDZNl51FTl5uVC9jce0RMTG7VPuemF0636S8WDWK6IqEocGhvWv60Yzf5J/NaeD
VO8KT8RXiW5SasvO+o699xw1UpzmtCNyy1VYA6Kc/vsGM2htrCuHVlNg3PsBtH8q
xVisUmxUWLOz3Wt7A9UQdQuOnvDbcHvlZUs+kxvqu/HUwRqtHLp3xZBbqpIyDpAB
O3zoWwo7wi3J1ZI4oBxjb7DPcUFOpdm17jK0DUmKXRF7Ku4VDDud3Buj54kQbPxx
JCAx2diO6LcO1Lc7u5hNILCvnF4/r9dlFTcTR0MEZWsUaw1s52OCb0wGPIdBif1y
PL7ymbep3cpx2sqGsT7TS9jE6ymDn9kJU+i0XfI8Z9OPpYFtuguJKtUzfRg19XIi
9aWm4ZBloi/6L/1hOGcL
=g0xw
-----END PGP SIGNATURE-----

--Sig_/fT/s3CMcpdi.N/Ijy6ax_vv--
