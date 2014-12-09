Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaLICRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:17:52 -0500
Received: from ozlabs.org ([103.22.144.67]:55158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745AbaLICRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:17:51 -0500
Date: Tue, 9 Dec 2014 13:17:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>
Subject: linux-next: build failure after merge of the thermal tree
Message-ID: <20141209131744.084929df@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/J+Xtqe6RXr1IQMktB9wEdIv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/J+Xtqe6RXr1IQMktB9wEdIv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Zhang,

After merging the thermal tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/thermal/Kconfig:265: can't open file "drivers/thermal/int340x_therm=
al/Kconfig"

Caused by commit 4152c8bc018d ("Thermal: introduce INT3406 thermal
driver").  Presumable a new file was missed.

I have used teh thermal tree from next-20141208 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/J+Xtqe6RXr1IQMktB9wEdIv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhlvMAAoJEMDTa8Ir7ZwVUHoP/iSsEw8/KmV5MN8YNllJGten
2eyxP+ShFUz3mF5P8Ho1OpOJt3zTZirw+UVRfOZmmCWnXUdYDnnEjymHF5aZEcWB
UxvQoPn0dlfjwRXFy2Az4yvro8pyT00aWadf8X0NE6ZuBMm9maIPMxCkpi90Fl/k
Xg3FIyhuAtSqfA5zwl8RDHryCDn9Ipj8AGLC8kA+5TP5GXEeqZ8X8c9UnaJC6mRE
5QXJk0ttRszPVJ64XvDO7edjFynYSgAlS1kgg7fK5yOYn6flv1mNcRNyoQTvjseu
0dt8HOhpUWHj2zt7F+wrcaJYFyg1M+9O3m7lve6+hmJZsyjrwTtvSoUBaArBcuUJ
U+EIcWFHIvLX2AgrTDoThUR4iBHqQF+VqOCte3wLKEAMTBVAESTLpna7BaPqirlh
48E4GsWj+qPyQP9BLKt5arJTr2oo36j49tNA4eCz/agK+J4GXgEC9Dua6bIa/3lT
UamI9QneB2QZJkMbwIQtcHqGz1AEmT/4x+UpOJ2ChdjBcZWzNn1Yg8F+KMF6wQam
JN8yDwqC3ewqXgeXGwUu9dy8uJ+b7M8IXXYRcVwTphSZoDheunl4NqtP9E/A/hPg
loz682+r5UjhgBpQbg3zQE4iFVjxtfdDZ1KunjqTJItK3p/yxBBKkEgwu9GVvFkR
nmH5pkD9J4PVGcXebgtm
=IY/N
-----END PGP SIGNATURE-----

--Sig_/J+Xtqe6RXr1IQMktB9wEdIv--
