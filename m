Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3LJD7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:59:25 -0500
Received: from ozlabs.org ([203.10.76.45]:51809 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3LJD7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:59:23 -0500
Date: Tue, 10 Dec 2013 14:59:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: linux-next: build warning after merge of the usb tree
Message-Id: <20131210145915.1cd7eb979bf40a30bfcfe694@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Dec_2013_14_59_15_+1100_VJCFU6=md4tuzTJ0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Dec_2013_14_59_15_+1100_VJCFU6=md4tuzTJ0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (sparc64 defconfig)
produced this warning:

drivers/usb/storage/protocol.c: In function 'usb_stor_access_xfer_buf':
drivers/usb/storage/protocol.c:155:22: warning: comparison of distinct poin=
ter types lacks a cast [enabled by default]

Introduced by commit e5fc70d5ccc3 ("USB: storage: use sg_miter_* APIs to
access scsi buffer").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Dec_2013_14_59_15_+1100_VJCFU6=md4tuzTJ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSppGXAAoJEMDTa8Ir7ZwV/gAP/AuHfH3KoqdddWZ0S6Vp/Cli
ajhagi7GtdTLh2miiGTNudQdcNXjPGdeNlNl+iAvDxB7lujZZsnf8b2q0HXC3SGc
6oQZbgteoZhC47B2UmBKz7HyBzvzXTRXairpxhqMM0sTAqPv/308buwH1kqwHWjf
C6AnsnmV1p+35XnghGQtaT9WJil55RXsEQ2SdYTOSYGlnffxVUnflwNvOVWWZ59H
9jbCrHk2FkbsnzHtTc+DG3uTsk8S+jVZLmfJfVyG7VCgxl0Qj9ailjCXA0vGWoDQ
WpOTyE1rc8BexlLqa02P36i25MKMeS8tEh+yCiijii1oDkeOO9OVd6t7i8229Ijp
bEkhZXl49GvPnMDK3bTyltNyJgH92LGtAKkX3uNDboYkHdxGwdYfNveUyoItlydu
rGATgrXKTPfdnvbnEqCXdnoLjpZTuS1t45R7Cj02Lxr74zO4YoJDDV/+mtU84QVS
ma/OSZ0LBIfYHAdacV7yEUxexhfNMXf1LeEXtd/UssE5jC3JUbGEBPqtqxVzL4RX
9bbpkfgXG60BTaaO2nsoGgEzTFG2TQFDlFD0dSnfhUxC3G9xUhlqfTOI3rCFOJfI
w2Z9blV1yE9eo+1B1RnrmBkcrW3/WWmJHLjS7/xoUyvMo6HL6vil3k59n1He/eyq
cOEIT2PR8O0squFqOoI5
=iNRB
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Dec_2013_14_59_15_+1100_VJCFU6=md4tuzTJ0--
