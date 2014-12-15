Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaLOEGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 23:06:30 -0500
Received: from ozlabs.org ([103.22.144.67]:38279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaLOEG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 23:06:29 -0500
Date: Mon, 15 Dec 2014 15:06:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20141215150613.6191f986@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/I4YuCWnbAhRMAQRgxa2GTP6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/I4YuCWnbAhRMAQRgxa2GTP6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/lustre/lustre/llite/llite_lib.c between commit
6a661bd6ffba ("lustre: get rid of playing with ->fs") from the vfs tree
and commit 9c234f6cb4c4 ("drivers: staging: lustre: Fix "'foo* bar'
should be 'foo *bar'" errors") from the staging tree.

I fixed it up (the former removed te code changed by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/I4YuCWnbAhRMAQRgxa2GTP6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjl5CAAoJEMDTa8Ir7ZwVEg0P/0EBOWSZHaLNj8FskZRp+6mf
D+Qzgb2ZoBpTYAXHsxp/7opggzI2IuMMh6PJRRbQJhfSKMHLkAWukrvyHhDC5sKx
CyRz/Y5KzA4VVtzQ7mXlW4bXLBoi0tFuaWMleZSA2kJ+TiGPQiocWvxHMh1g91+H
DpPlYXgQawh0haKw2VX6kJ9j2NOjWgDThDOL4WulxzgwDrIw0MU+0qJjBtItW/9+
TIunzREInr6u9SIIf09k3sBTmv9btwffbm29db2AMGlJxVmpVoZ4vFy9VssxKsUT
C5lll3uPH8pOHaqngsXUU3A4hOzc81F4paEzf6RQrXJlrli8TqDDJITFgymmugMi
bFlT/PIMK8hNXOk3hi1jK5XPrbaqb8t0s9U8HWK7P+yRQRzvcSpmT9fhL3bgsbok
267L3bBOXXe/Mrkqc0oVekxREurDBTHjaqCMneF/QZZAi61DIF7Y3I4W9f1sbJdF
ft8WlJGp8PkFA86TkCsQGODeXfSgfwfYZJKYY7MaW6uLlH9tsvOypirMCs93slWW
7hPVhYwrKBwD1QUAT2nobpQ452/Ib+V7lS4c3UMHy3CziwPWycz8QYepyl9BNyM/
zzcFQuHbIu9WnlJRplw0/mC0rEIlK/oND0HI91LfQsdcXwpY96OCAuhyM4rTa8PH
mweTrb72fWBHr8ONzuvf
=IDnR
-----END PGP SIGNATURE-----

--Sig_/I4YuCWnbAhRMAQRgxa2GTP6--
