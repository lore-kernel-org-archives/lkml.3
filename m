Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935137AbaGYAYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:24:19 -0400
Received: from ozlabs.org ([103.22.144.67]:55308 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934483AbaGYAYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:24:18 -0400
Date: Fri, 25 Jul 2014 10:24:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Tomasz Figa <t.figa@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the arm tree
Message-ID: <20140725102410.44ffa99d@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oR0i4vRFn6CNj+ZhWdw5D3W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oR0i4vRFn6CNj+ZhWdw5D3W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-s5pv210/include/mach/memory.h between commit 3ae4e9812941
("ARM: 8113/1: remove remaining definitions of PLAT_PHYS_OFFSET from
<mach/memory.h>") from the arm tree and commit d78c16ccde96 ("ARM:
SAMSUNG: Remove remaining legacy code") from the samsung tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/oR0i4vRFn6CNj+ZhWdw5D3W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0aOwAAoJEMDTa8Ir7ZwVMKUP/j30PEgC+DeM9hI2jS4/+x3i
qP3+tchJ3DFG/+02F/ie6gGA/V4+B7TUJhbawTAcEUSpAMOGW2rke24BLLzjOADF
iPpa+ni626sgIMXrqTQcIYyLnSE8Q8PZzcccKfzmv0IcVyGHH4ycs2e9LvDN/Jw3
wpX4hd8M+PsTT5N1pNdXDcGbMCcOb5/ZHR9YHpE5g7/AigWyiKdsXA4GIPWdEl+M
7RKaxNsoWQE5IF/TOgnHkJ/9vTNSGZE38dS6YpHMohupDA5NmfWgIrDPrry3m2mX
Tbt7Se1q2JIPbPexJzBAfTeO3in0CkSx5Qy2x5d+fQn95EZ9R/w/WvjaeHIh4ooG
adWC4SlFlv9FgwASq0g5g5aKOgUEDxbi6jZKxTLIboZAF342XZ054fV8KEhvdi6Z
SMvm++4J41Pz2F5T9osWz7kbUMDK8jwjkyh6BvjljnnCf4wJnSo5YbL8a7R7F5Hn
L1NhSzRgIeB8UDICkrPlg5zcYmlNDCskXdkAweASyOSISIHA0217vG+cjxbx8+Wb
e80q+xnuaCxtOWZgJ+xajul5MSe4bFmkk+hz64xQ8isBOpckdkpI+KKkJo4Ostk/
q3QEbGTXQY6drAjFRsIu8gwddBzRKW5UEzOwVWXS1I3D5fWrfwTJkG9Lc+2elUqP
WNOAnzoGWeCqSB9RZNv2
=78PA
-----END PGP SIGNATURE-----

--Sig_/oR0i4vRFn6CNj+ZhWdw5D3W--
