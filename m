Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbbA1ALF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:11:05 -0500
Received: from ozlabs.org ([103.22.144.67]:47904 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758735AbbA1ALD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:11:03 -0500
Date: Wed, 28 Jan 2015 11:10:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the pci tree with the mips tree
Message-ID: <20150128111055.41091d7e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/cWUmR9g2AYdMXeDOdb3TzP1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cWUmR9g2AYdMXeDOdb3TzP1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got conflicts in
arch/mips/pci/pci-bcm1480.c, arch/mips/pci/pci-octeon.c and
arch/mips/pci/pcie-octeon.c between commit 7b09777c187d ("MIPS: Add
struct pci_ops member names to initialization") from the mips tree and
commit ab1d7f9646fe ("MIPS: PCI: Add struct pci_ops member names to
initialization") from the pci tree.

I fixed it up (same patch, different white space - I used the ones from
the mips tree) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/cWUmR9g2AYdMXeDOdb3TzP1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyCkUAAoJEMDTa8Ir7ZwVGiQP/i97LjqxWnA46OWXyBKirc/v
4vQUw3ms4jEMVkLpysxrtGOWSap5AB5HOAC6GCArY19BgjgAKy3fzRCn95I6n1Mw
zebGz+JtAnF2kHx2dsugeHGxMVf6Hq5HTc1QZ+XlLAwqY1051DtIPTMOXMx0sPrl
Jfz5Ko3GHHFDvjcPjelSOXLxW0OwKYLvpx417wO29r49FgopG+gzWkdCWvFKxf1n
Jrwi1xac0FEQ2PeBQ13bXqzQJJMr5pgMAsrmX72jYajjZbHQuQpE7tHVhwBnJwiZ
LoIMFjnnzzBK8DXG2gWuBezNRdSdT9XoQm8CH8SO3ugET/BKK4Dfk7b8yzTjeFbq
djwPFG9H4z7qgp3E87W/a/yxlZva4w7j2se+M5tE+vHYVDcDF5mh71v33T6M0tbF
YsbI9V44i0WklNLdDlSFoFNN6yQuHWys6xMK4WrdgKzfxII8j94xVsas2qg48fK/
7qvls+dfkDok62lHM7STAyZj9CcWtqlObRSMWvIizJwdf/vCTnzBqpb+dMoW1vNf
5Jpl8x2x7QEMM2lmGKleBHfRrZGQVizZir+2OImUkGQ3FpoYD9tfYn1ChQb6CQd2
rU2WTJWUHzaBl+X1L6Ily+avCz88LHUpMboEUoXYfuEq+c/ooIW4SpBYVdjWkygV
AQVwMZ7X0TeYG+qx8EBH
=QTbX
-----END PGP SIGNATURE-----

--Sig_/cWUmR9g2AYdMXeDOdb3TzP1--
