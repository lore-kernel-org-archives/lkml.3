Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaKXIR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:17:29 -0500
Received: from ozlabs.org ([103.22.144.67]:51979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbaKXIR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:17:27 -0500
Date: Mon, 24 Nov 2014 19:17:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the char-misc tree with the arm tree
Message-ID: <20141124191720.574ca60a@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wUfRnyJggakPeQwCq+yl9dQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wUfRnyJggakPeQwCq+yl9dQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
arch/arm/kernel/etm.c between commit 4ed89f222806 ("ARM: convert
printk(KERN_* to pr_*") from the arm tree and commit 184901a06a36
("ARM: removing support for etb/etm in "arch/arm/kernel/"") from the
char-misc tree.

I fixed it up (the latter removed the file, so I did that) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/wUfRnyJggakPeQwCq+yl9dQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcumVAAoJEMDTa8Ir7ZwV8sYP/RJfRB5K7UOhnrY318VpMuym
rZVAKYaR8f6+nEBXRCxOKv8eV1AqIRSjClraQnKhO1uYugVDJtUKSUBCzCTnzcTL
E9eaWpuGcwJdLDYJ2LBhdRT++zw5EaRj09uJ9/eniXAvT0n0eLtVUmPMdHN7L8Eo
WQTuSvdmbHaqZDaa7MGFDTEtmEakKmr/X5w0Lcx30PUloM9DbDp+RD/ocyZu73lA
oxOp7FRS+BAlDkdmxr1m4QGiGRoBoEAIQHTqT3LmbjXe/tqtjkjf81lsUNjvhsC5
qg2VnTRJzB1xXkuBosfIvIGU3Km6EC+vXYrEtb2hYxqVnKsNfneRm1+7LQ+EV1jI
7mdZhH2eljzfyBgoOe5q6jCnsJVA9kCX4bDQpqmV0kuF3jtxocowBmIpHyA8OZTk
yv7EXvV2jA0rnI3ekdDwR9llf6/bPIRgvg+ZjCgQjieAg7b0Kbz2Rk0u13zwyR/a
mHwzxOjrReLvn1HyhZv4KoNWHxIy4WwaHqurAEszd8wmc46J7BXW5s817o3zmPeX
/vwT8oaksqgGSN5t5iOymB80x8IIgGsfz0kj7fHE5oeP5NjY27Gp+iFNYuYn5xum
0FRVAtFb4QGyL/yMtOkT9PikgbgF82q911opAZok+Kq69dQ30MH70u4KxPEcyNce
SeFK/uO/d5feKfVBDWKb
=7Ih7
-----END PGP SIGNATURE-----

--Sig_/wUfRnyJggakPeQwCq+yl9dQ--
