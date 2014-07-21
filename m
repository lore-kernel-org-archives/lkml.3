Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaGUFKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:10:42 -0400
Received: from ozlabs.org ([103.22.144.67]:43821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaGUFKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:10:41 -0400
Date: Mon, 21 Jul 2014 15:10:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: please clean up the audit tree
Message-ID: <20140721151033.1c9c2bcc@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UB1R5Zy3r.X3btkhNi4xqZI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UB1R5Zy3r.X3btkhNi4xqZI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Eric,

The last commit to the audit tree
(git://git.infradead.org/users/eparis/audit.git#master) is from April
and it is now causing more and more conflicts with other trees in
linux-next.  Please have a look at it and clean it up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/UB1R5Zy3r.X3btkhNi4xqZI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzKDOAAoJEMDTa8Ir7ZwVSLMP/2WDBiX6insBfngE70QWjUqg
tm6ZvcmK921CAE+PydmznTjg2sLFuezCsCj0fFL7Z8XPH91rlD0IjeHWv569y0gh
3e2phlhBQrC4gv6f7XQYstys/ZWxFJuTvw0HUakn55639L3t76WdPOkhxUohFKTe
gwpcmnyBsYe+mqe2pZAQpSFPM9KjEG/CUpSMLjZMUF/2RwFfOPARdmSQsJYKoPdI
zCFhog3EFYnzaQRZDnPq+X+jmisTIX8z8N85enUzdTRu+xdGgqQqRgxclY0FDq2i
Db1XBZzPLaE114LNhq3zP+hv55MZM6tLK71uLcpMZqb+GHZhaiZwHQaCB/odQIfT
TNUFilu4G4TP7NrelkalPobY8JpmzZ+Nmh4csL51+PZ5R7RNJJbpEuZNNi1EFNXM
GVaMLJ5qr1a+ac7U5fq/oLxHD2+2aYt564aNqyUDajT9ThUuN2r7k86r4A1ncVgN
mb+xam/YF6Y7g5v5Bc/FJU1ginVX9eW12+7e92ZTDqR2r5Fkhd61sOpxz1UY1lje
0SLzUGvCxT88D/FQDaZ7ZK7FKUYElt1dLO0Rsb5XRlUgm7YmRAZziHgtwkyGEsDM
8y0f+yFNqAlpnI+RgqSfn3nlEfMEK4S7slma/ezueYLF3X0A7uLBnO6LnXAY7/pD
RBx6dfV/WyiyucDVHSre
=3rAh
-----END PGP SIGNATURE-----

--Sig_/UB1R5Zy3r.X3btkhNi4xqZI--
