Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbaGRFAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:00:43 -0400
Received: from ozlabs.org ([103.22.144.67]:38902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaGRFAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:00:42 -0400
Date: Fri, 18 Jul 2014 15:00:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: linux-next: build warning after merge of the tip tree
Message-ID: <20140718150005.73db8eb9@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KcKYX/G5U9H1l=lDOn9ZQr0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KcKYX/G5U9H1l=lDOn9ZQr0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

In file included from arch/x86/vdso/vdso2c.c:161:0:
arch/x86/vdso/vdso2c.c: In function 'main':
arch/x86/vdso/vdso2c.h:118:6: warning: assuming signed overflow does not oc=
cur when assuming that (X + c) < X is always false [-Wstrict-overflow]
In file included from arch/x86/vdso/vdso2c.c:165:0:
arch/x86/vdso/vdso2c.h:118:6: warning: assuming signed overflow does not oc=
cur when assuming that (X + c) < X is always false [-Wstrict-overflow]

Probably introduced by commit e6577a7ce99a ("x86, vdso: Move the vvar
area before the vdso text").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/KcKYX/G5U9H1l=lDOn9ZQr0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTyKnfAAoJEMDTa8Ir7ZwVv7oP/RdW2QzH+rDLsB4kgTiVoiiM
cv762WJC4N5KEVZEjA4zrzxvs5RWXBqbQ1/SH+/GYxtoZg5rUowxbuJ6rNff5Ymd
NOptEyMJ14YDWlXbhyZAogQDUSKHc1G1WQmlZUp2hniQQbAAiESRN0N3SfUnzxBW
XQ5ofxxdjBoAF00oS3truY0mKoyIf/pBbhaKemKVrdUgI/wlAxFjH8D8lVhrMt7e
UIjGai0kIpWgnfhkF3coePpDV490b9/sZ7JodO4bTSR3TNUAqpfgpYm7Dr7Zq2KH
6EsgHA1q94zhVryCmcSP1xeSygvmozTzWWEgW9jnBedPvjR8KZRH495LUU5k0/av
Gfb6+8pvkoJV2jX3cwhIaIlE10guokkbcWgbmpBtwEYqjgEJ4NwpFrFUaket3e97
o09dxd9xZzra88OYRdftvqSvhmZJIuGp56G5paql2eYoeqz709qibTO9B7Eh2xL8
0SFMGXjGXAXa4XmHtuFG8PIDuxnI3SornkGuH8oUB99kQV7bZsTMGNGTAvxkDE2/
mlgtEMCtG9RLqtDCpJsSZoPXJSLr4BuCNh08C2EnP9dN3wQxiiZ/dUedwXH1GsRG
evhCewrydpIfgdOyRFQtAleTZc9ZeCEXNh0vEtLl2+/al3rjcg1GzIr2EEvpzIqA
OO5ziVxzdyR5R2aixioo
=iy2g
-----END PGP SIGNATURE-----

--Sig_/KcKYX/G5U9H1l=lDOn9ZQr0--
