Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaDFNLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:11:21 -0400
Received: from ozlabs.org ([203.10.76.45]:46250 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaDFNLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:11:17 -0400
Date: Sun, 6 Apr 2014 23:11:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: strange state of the drivers-x86 tree
Message-Id: <20140406231109.bfb3e6a3566dc8a4d07332b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__6_Apr_2014_23_11_09_+1000_8.7n+fLCDT6gANpf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__6_Apr_2014_23_11_09_+1000_8.7n+fLCDT6gANpf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

I was just looking at the drivers-x86 tree
(git://cavan.codon.org.uk/platform-drivers-x86.git#linux-next) and it
seems to contain quite a few commits committed by you but not signed off
by you.  Also some of those commits look like they belong in other trees
(notably the net tree).

Please clean it up.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__6_Apr_2014_23_11_09_+1000_8.7n+fLCDT6gANpf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQVJyAAoJEMDTa8Ir7ZwVpEQP/0FdpNRbNY0QmAUcYdluK9yI
MNU28PnUmg5IYSSfVE4TBkWx638dr7yrI4pkGQtgLsp6+IiJC/970rAkb2wl+/8M
NAgVX2TTAyNFZMyyHKe1MdRo082jtRjuq1SRddeAwd2iIUg/HHAcebgaIEp6Hx/0
dApUvSPfUlSeo2BBlknkX99K1j6ahDoUltlVlJ6ZB4MciylcaVpmxAr3Juf+CqrT
UnJiXe/6A4kRUo6U41umkfToC+p3cJcnZ7w958FdlYXVnWOUfNrGPJ4t/XDQ3lkL
yYJpvX0UkUirRcORjE0shVLgq2bsRL2gXoSoLNVa15gK2mJn3EUfd2sbUvyk/DYq
3mWL8Ta5zIsYsccjydc/6Y5sKwTT2842Y6O/0Tsvi2Sa71CUtX6S+i8hUG5RfA2o
TVLxUBz36h5DAUFlD35c2JBVQVq045hLngZyvgy2tCsnrk5gALcpfpjXeWf62Ugs
ieClRlb58sTSsl/PM77H0dO1CrnS5KdfonDqO+Ad3DIqYm2FeBcNzaUhtK6MREOg
AHx45TSjJE4ZZ1QUAhJSajTHdNuKXSLiRkfPdwJwnCX5zeBcXyjAI+F3d3tsq0sj
4uf0POeNanf8qae44j3SWOHZgu7AyVF9d7CRCBWBV8F7175Z2y69/11FBmjCz1iU
MERq2Z11fnXqlRagrvDC
=F7K2
-----END PGP SIGNATURE-----

--Signature=_Sun__6_Apr_2014_23_11_09_+1000_8.7n+fLCDT6gANpf--
