Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbaCEDc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:32:27 -0500
Received: from ozlabs.org ([203.10.76.45]:33693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaCEDcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:32:25 -0500
Date: Wed, 5 Mar 2014 14:32:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the omap_dss2 tree
Message-Id: <20140305143219.1613f7dcad9ab8a3290be9ee@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Mar_2014_14_32_19_+1100_fmBFALPj2dyj7Rp_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Mar_2014_14_32_19_+1100_fmBFALPj2dyj7Rp_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

After merging the omap_dss2 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/video/fbdev/aty/mach64_cursor.c:8:24: fatal error: ../fb_draw.h: No=
 such file or directory
 #include "../fb_draw.h"
                        ^

Caused by commit 236c52f2ad52 ("fbdev: move fbdev core files to separate di=
rectory").

I have used the omap_dss2 tree from next-20140304 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Mar_2014_14_32_19_+1100_fmBFALPj2dyj7Rp_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFprHAAoJEMDTa8Ir7ZwVH7gP/2YSwA4hlDGyGsRyForiBq4/
iHqCqOJkbXf0LxyozMiI0JIZTLQ3phvIcZ4lhPKq+V9+y0KPLipi1PZGC0iLbyCU
YSHue75ogFCV1WuZXeToOPLhCz3C2BLTGiryfY1QaIJGt6UQss2WRRkD/Mci7CQa
MH1UOVrNaiAk3DIEWpH6XFEjyg0JWRv8v2HY3H5Z9285U2laf1kFf2HImHRZvQkq
kfZ2NUoUxtOWryh3QRj3EnkI0JY34wSmp2eqRU7gRim/aZR3zQffDW/glQ4Y5P9i
36/G71hr2ROym8puVoOKzeXb4C/A2afwhN99f+5qbaUXQ3AGPfqWbxoQjjge2IvT
heDCwV944VKjH2Y+WkC9lFvg4atwSMr7L+imK5S8PoJqUf2VTgKo8n5SFyhLMvKh
aWbMEYeg8d9Fz7/I9swGecX5cepaxECCKQ5upu6ZKqHwxK3q79WTgfSHg5uqAvqF
+dauvwOLaB53IlYalH3Au4Iulv3/njiU92nRzpWr11BsGSWdyIhbAz0VEm8Wf9Pv
X+NLA1e8rCCSuusV14RF0XlT/Tlg7f8xinepgHf5em/9ylRi77LsJSisirmqfg4W
2JybA9Mza1awvVHfo/9SIzAJPsReaUfCeIJqfvvQx3hndkjNoUgVtDyoWAHkf/y2
SDehqmI1+KQT/9LARgIR
=IEXh
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Mar_2014_14_32_19_+1100_fmBFALPj2dyj7Rp_--
