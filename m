Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966627Ab3DRIDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:03:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48567 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965363Ab3DRIDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:03:13 -0400
Date: Thu, 18 Apr 2013 18:03:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: linux-next: build warning after merge of the akpm tree
Message-Id: <20130418180306.7dd5c5ad968effad4f50b100@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Apr_2013_18_03_06_+1000_x69f//jyiq=PN/k9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Apr_2013_18_03_06_+1000_x69f//jyiq=PN/k9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/fat/inode.c: In function 'fat_zero_falloc_area':
fs/fat/inode.c:170:11: warning: comparison of distinct pointer types lacks =
a cast [enabled by default]

Introduced by commit "fat: additions to support fat_fallocate".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Apr_2013_18_03_06_+1000_x69f//jyiq=PN/k9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRb6i6AAoJEECxmPOUX5FEHEIQAIBhE51rmXmae/j8KeJ7IXf2
2rZ0TZOFfbSeb7E9K0KmQ6B6oYm4S7y5ZtasFwFromTFzAE34fTitz7Cvmmn0kL9
L4Zf7m/oko3thnq9vphuanMcdgmNXH1J3XwG7+yHMQsGCD8LsqItYz9ZE4S0IWgs
pm9NbNjRAA2gmnWeY1Tw1ZgxTfCdQIKbMKA3P0Z8cybKwrFKWN9/CLAMKmTWnItr
Aslku9OXpwSf+ASlswNynmfjPYpeSEbg07e1Ai6tzbkmSxh6wgkqej60yGeyr5C1
JxJDxz5yE+/G30HytMFthNWKQN7Lqc4VejfUBeRuQKC/sPhO6YWPd1TrITmhDiq6
j/SZDwewAg03i52cU39pQxExMeXW8FgSVHJ/84yGsZzGuNoMuicF408Bm4G73nit
lgK+4mMG4fxXlL8L5c55ROQ6jAi/sNW62vLQMxjiKyHng+Du5OVMcCKTjDNlJWuJ
7wFTatp8MPfBw7dRy3lOglq4JAfIzL5lKTKK7a3D7QOmNe9k8zPNfKPSzuzWymgg
ulMm/Vg+uuA1mdHG4JnJL/VMa9CsXLMNQCBS0y0ccEk+0GCVLEZJffFEKjjZd4Ll
I9KE+hQK6qRA8NP5hlmsyJSmiihzJ3GuloIQTlSLJLsIIR/duP7R5kCEUnTb4qlJ
uKz7fp8gAn8eX8lJOf+A
=R5AF
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Apr_2013_18_03_06_+1000_x69f//jyiq=PN/k9--
