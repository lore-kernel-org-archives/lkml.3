Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143Ab3ECBD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 21:03:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34111 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3ECBD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 21:03:28 -0400
Date: Fri, 3 May 2013 11:03:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alex Courbot <acourbot@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [GIT PULL] Removal of GENERIC_GPIO
Message-Id: <20130503110318.0d30b773852640ee94ba07b5@canb.auug.org.au>
In-Reply-To: <20130503105234.6e9c8aa5ed2784bbe084caa8@canb.auug.org.au>
References: <51823DDA.7010103@nvidia.com>
	<20130503105234.6e9c8aa5ed2784bbe084caa8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_May_2013_11_03_18_+1000_w/XPNNnLrlUlu2x/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_May_2013_11_03_18_+1000_w/XPNNnLrlUlu2x/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guys,

On Fri, 3 May 2013 10:52:34 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> I currently have 3 merge fix patches for the gen-cpio tree:
>=20
> gen-gpio: GPIOLIB merge fix up
> merge fix for Convert selectors of GENERIC_GPIO to GPIOLIB
> merge fix 2 for Convert selectors of GENERIC_GPIO to GPIOLIB
>=20
> I have attached them.  All three are now applicable to Linus' tree.

Just to absolutely clear, I *do not* expect either of you to rebase your
trees or backmerge Linus' tree to fix these, I *do* expect whoever send
this stuff to Linus to mention the necessary fixes to him.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__3_May_2013_11_03_18_+1000_w/XPNNnLrlUlu2x/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgwzWAAoJEECxmPOUX5FEWMcP+wTmk7O2tuZWLo8NHnhED2t4
vuzPCnFsIm7MnjP1CGyjvwBYaVnDnn5BP/L7upA0AXIm/pDqa8owF6iQ1VPFfnRT
/o8pwnKiejGT4XISmA4A4KdcPRQOoHIsfKQK4Hno/B4XOAQKD5xAaht6zkrs065B
fGachtioCvJVJsFm58Y6by2UFi9QThaRP/QS3vbFA8HKRVMwUypUv63rPXHdjy5b
+Loga7p1S21CwxDGfwRE4NXrH/OrpK3WB7VBlh6HZXpuzEX+z7Yx2LC41J4amQDO
6lgTAm5ZWJpa3yLmsDxhy9afbB04a00xCK50OVlNKb6pQXlTILV0hDQV7H0kbE6A
I7/hqUDZ4h79QWeelVt1UpkPapAlQTRpbMFamiihRNuFrgg1lESFHI2Rts3ZkkoH
Rl9jpy4OhFF0OxIfafe110XSnK9+WmC8KBzo/sZGvqQtpky7jZQGDhvqm3PEaRxn
D/jsQZ7iMytN+J+xXnwhF95Eaea97/76HT7ik+Xr3SR5vqYy7iyZDM7QiqhsPY8Y
dqMjRJXgQAsi3jdqm2337D3RY5ptmvW2BQW0o7xxsyi2N28vYX9E3NqmN3esx3Vt
DL1YtsdvOMNfDFj52TZTXENEYL0KSIAGod63yedBJ1wGE7bEkCYCy4CpfqYEzN+K
Ovj2d9EZuv5N6vleMz4t
=vcFM
-----END PGP SIGNATURE-----

--Signature=_Fri__3_May_2013_11_03_18_+1000_w/XPNNnLrlUlu2x/--
