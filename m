Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaHDWhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:37:05 -0400
Received: from ozlabs.org ([103.22.144.67]:60284 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaHDWhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:37:03 -0400
Date: Tue, 5 Aug 2014 08:36:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: trouble fetching the mips tree
Message-ID: <20140805083653.34b23d89@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/c/2xlTZXA8msY0NbCRQ1c39"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/c/2xlTZXA8msY0NbCRQ1c39
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

I have had trouble fetching the mips tree
(git://git.linux-mips.org/pub/scm/ralf/upstream-sfr.git#mips-for-linux-next)
yesterday and today.  The "git fetch" connects, but it seems to just
hang for many minutes (eventually, I just kill it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/c/2xlTZXA8msY0NbCRQ1c39
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4AsLAAoJEMDTa8Ir7ZwVmA4P/iRJe9dOtkxpNeLJEefi+yCa
QHLRmk+WEGjTXWgYDiDVDxPCwf0q6qYOGBiTy4ewqQrGMhsFdjEbX3LZTlFnpsbM
8aqCxEC/C2Filk00+aS0CJKy33yxSv+QMkyojfLf7xWg1Xn2ezC2VEbUOLJR+sHy
XIx+7TjW/tgdcEjkdVhRtZF2IyfdxEex+H2QRpydmwk+ctDQdtef2oBRXm6WrIst
JKh1/3AZNveerJFQAUwj7sdelPfdLM/1F6HrczbfbMa/7ZCYgkwVB58Juy8wrZB9
yxMwuLDwhwC3qFvyC0n7N1hcRJAi+sJodGBfg0m1NCftN4TCYcY5Kuo4tRtMey/K
cP40uBAXKzeedJMkT1wz+W7IUMoW6/gkrFtJqAVAfqtfS3iLVW46Y6CwCkD+Q+sS
ta9XATjQFDGk5mVlLtklmAJylCU6/CfQEcgm7qyFihdNQPhqrbR8Sr4b3zPmAcsU
usck+yBZNTDQ6ntf60XZN3owhUaz+ZDld14mI4Oi/SLZiA6hhT7Bshk78+c13vbB
J8tvF3wV8ar9iXJjsOjy+CmQtCBUdNS8wgGjfgvTTrJEQeyYpFaDHfEVdAteij5g
PhzLklz1UwRUMLbphKT52QH5MapNY36SRMH+Pji3QezqAfEVMQ5P5XmY3b0ECprJ
I5MlkCWl0IMjs5kYedrZ
=8y6a
-----END PGP SIGNATURE-----

--Sig_/c/2xlTZXA8msY0NbCRQ1c39--
