Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLQDED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:04:03 -0500
Received: from ozlabs.org ([103.22.144.67]:53271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaLQDEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:04:00 -0500
Date: Wed, 17 Dec 2014 14:03:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the ipmi tree
Message-ID: <20141217140353.04eebe5d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sTbLc+/YWE9CoXPwaNVtxUO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sTbLc+/YWE9CoXPwaNVtxUO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Corey,

After merging the ipmi tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/char/ipmi/ipmi_ssif.c:55:26: fatal error: linux/ctypes.h: No such f=
ile or directory
 #include <linux/ctypes.h>
                          ^

Caused by commit 707096b4dd41 ("ipmi: Fix compile issue with isspace()").

I have used the ipmi tree from next-20141216 for today.

Also, you seem to have rebased your tree and thus duplicated a whole
series of commits that are now in Linus' tree :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/sTbLc+/YWE9CoXPwaNVtxUO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUkPKeAAoJEMDTa8Ir7ZwVnhQP/iV5m8WKGBmF2bNHbLicDNae
LnlijPWpSYxH1oXBfMZS8WizN7t4Elvp7vGnkvf52vZ3Ds3p/fTkvflA5hEl3/Zr
LxrGI9E2ZWUqq/uRol6HG2YbUgN04KnP48CPB6yIZP6/QSatukOYNXnx5jL2vQdz
K+iGATNto/yAJUQ29CK87Z+zJ3A/umUDwkILWpo39DsevusBKmTvpgGKZFfKNNdR
i920gU9Qm4Zqn7IF0kDYiBnvJzsB7Cm4SqXfpNS2M6mQDXOIXhAtce0LeQam/Fp4
8FagcQ0GUT1WZBuPYY+kPpN6fOBsQ6FnZVleXIJVaSz9aYtv9/Id/0IRjYQEyscq
oZf54Qr/ieNi5GnAvkjEpoqraoMZHzo62w1hiVTHidSr2aZe4fG89bgdfl27bgsg
wTPRA9e5mk/DgLp6m4W8T8dj2OhqA91xLZmL8sIyb+X4Q6lp5ENyloAdndasmwcC
VomjX2LU9sdog7clxHwTrqgKYW5foPnCZpSKFp0EdoWp7tt095j/AeznurIwo/x5
P8oMHs2ddJ7n6Qflix6RcH5XekjjihiqrOUSiEUGgZUUP+LmTJ7Vilr8SMzscQJl
VPKZb+NrMe06g2iiQ+79E23FKYgwn/OBMhhzmTBCWVMvIfagQxfcSpbJbvwhx/YN
B8fINVIO6Po4DVeMVoRg
=f+PD
-----END PGP SIGNATURE-----

--Sig_/sTbLc+/YWE9CoXPwaNVtxUO--
