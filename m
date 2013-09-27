Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3I0GMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:12:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36074 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3I0GMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:12:48 -0400
Date: Fri, 27 Sep 2013 16:12:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: linux-next: manual merge of the tip tree with the h8300-remove tree
Message-Id: <20130927161238.f168bf3544c56ae1c1dcf439@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_16_12_38_+1000_HjQS8z=Z8=9kJNu9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_16_12_38_+1000_HjQS8z=Z8=9kJNu9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/h8300/include/asm/Kbuild between commit 4b0847842204 ("Drop support
for Renesas H8/300 (h8300) architecture") from the h8300-remove tree and
commit a787870924db ("sched, arch: Create asm/preempt.h") from the tip
tree.

I just removed the file and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Sep_2013_16_12_38_+1000_HjQS8z=Z8=9kJNu9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRSHaAAoJEMDTa8Ir7ZwV70IP/1rdfNuVoM8Ehjtm0uJfkqAK
KZba64S10kVEK/pwZWZIfkOx6M7j8Wv7DB28y4g8OFzlnd8vS/LoDh/sYIlWTjpl
qcke3RkCmr2qJvf99VzzUCKeaAXeuzeNWq73r/U6gJTjzGxxw2U9TRhbsW0o0EBJ
qbPZX+EQ0ZetNjFCerx6B2vJbVA9qnMPMostAwrrOP+sYjDlH5Ugxk1gAJfjQLSP
tPbNpnt6kzcBMf2V3PVEhL647v53RHseKsC6CwiIWwIrWHtOi529g5m8+95pqyzv
HV+u8COJqutQa9ryNG4+kgZo4mQDCgks0ym/K0ObSZI63+l9SLMncLDihUAXLVpV
fnmzuDSuy0XGZ6vkIIT4/t/HflHkX9enga+864yP04qzWK6IKD8pV2ZdSj58eRWq
7KNsmzadkLgG/npc3bV5WyKicadoG3ST9jRnElfSTonsDBgwWy5lYL2MIrHWCXga
I8tSj6KUebb/zogzMMnJYh+6KUUcDNcbqtwux0EXzUf0qliCdIZ+E2xeZJpi1aFt
5aJhz/terZ//LqFw3KfaETl8OOy9wGTC7JCiy6NN975m3O0CpT2e5ZUhNwg2ijB7
gv2QRmk6RzpcS7hOHkHylC3STLgthA3CxHa3XawpqnVmd5x0nuplqXCNC3IsTyoi
RiXiIT2Q/nWh9wquKGgX
=HbSL
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_16_12_38_+1000_HjQS8z=Z8=9kJNu9--
