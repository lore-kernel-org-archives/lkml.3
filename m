Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3DZFKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:10:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38989 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3DZFKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:10:37 -0400
Date: Fri, 26 Apr 2013 15:10:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the omap_dss2 tree
Message-Id: <20130426151027.db71ddf367c85fe0682cbff6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_15_10_27_+1000_664yTLzvJr6n2Mhm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_15_10_27_+1000_664yTLzvJr6n2Mhm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

After merging the omap_dss2 tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/video/ps3fb.c: In function 'ps3fb_mmap':
drivers/video/ps3fb.c:710:2: error: implicit declaration of function 'vm_io=
remap_memory' [-Werror=3Dimplicit-function-declaration]
drivers/video/ps3fb.c:712:2: error: 'offset' undeclared (first use in this =
function)

Caused by commit 6ea19860d6c5 ("fbdev/ps3fb: use vm_iomap_memory()").

I have used the omap_dss2 tree from next-20130424 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Apr_2013_15_10_27_+1000_664yTLzvJr6n2Mhm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRegxDAAoJEECxmPOUX5FE1vgP/RYl87Xow7YyIwk/OoimCCgy
zzU/9paXOQpSmrjnL5Q1nfXumUekBG3o9XmoZFgGWxo0GevnCxGIRJopsnd0bmaJ
qUVmzcFkgxcVdjP9hguYJnb1Q01bEobuoCZfQWSGTg7QrpPjDrnnsinUKOHJ20/7
cZV48KKcRVkYTzkS/KtX05RlGoOM4kPOicorjBM6pFiulhgmbqKavQT1La6HX7T5
8S7893VWSOoQ5QDv3ZuFNmRCxqHFkO/nhUS+jeUW4IGMrJsVT5wP6COt8U8h8JK0
iiDmd/Dd3Ahpncn7Yrgm3oyrLDRUtWpl7SN0ITLZ1VJDePgHHgAxKZMzMFD9WhZ+
3hAUxCeO4x6IcJMPEtQ9SvCjxVcOTUQeu5+c9p6b3AQLhiY7Jc2v5IM96xUbwb92
H3cwSORTUCF1738Yrjmhv5enS5vTb+T07F0e21BsNtLaUkMVrULbtFbWNhhlVyjC
G+1ILAsrYB3XltuW5CzGCo6JmvE/EZ/uOZ702lp/sx0NHCpf34F6EjVbU0t9+aFy
uLrrOnqDXqBMBhZlOczfmU/PubuVTFDPcmlRYJg9AqvMMKbNNmACZMQStIRRka9c
aHzs3pSeNf5eJEf7IDWoBg0qirBe9g0Hc8dhOClyHfO7ruJLLIRVzEeOrclRIgaf
IhH6A06jCPkShT8+znvq
=Tp05
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_15_10_27_+1000_664yTLzvJr6n2Mhm--
