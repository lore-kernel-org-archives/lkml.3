Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3BBFzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 00:55:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45627 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3BBFzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 00:55:42 -0500
Date: Sat, 2 Feb 2013 16:55:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alok N Kataria <akataria@vmware.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20130202165540.497b18a36832f2113541e938@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_16_55_40_+1100_ihfuo2O9hVnwX3Zt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_16_55_40_+1100_ihfuo2O9hVnwX3Zt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/kernel/kvm.c: At top level:
arch/x86/kernel/kvm.c:509:2: warning: initialization from incompatible poin=
ter type [enabled by default]
arch/x86/kernel/kvm.c:509:2: warning: (near initialization for 'x86_hyper_k=
vm.x2apic_available') [enabled by default]

Introduced by commit 4cca6ea04d31 ("x86/apic: Allow x2apic without IR on
VMware platform").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Feb_2013_16_55_40_+1100_ihfuo2O9hVnwX3Zt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDKpcAAoJEECxmPOUX5FErBEP/3q4sINhJxFdUfvZvJ3sJTLr
J/K87TIOoBqg4TKD6gEN3791jf7Mz1sRiYplXzBhANBfTkUTjEgnstcGgQXGvqmG
NNwPHLTioYvzd8cOTZ24k+MekpZSlSAH/0Bsskba6aiZ3ifxaGEOf4kfv4wk1l2A
xvS1PPoueMJJLr37ywmx7aizrqnLF8zFFHfPJ2H3x+yCyELPC34/GT0ZhigzX1y6
AqhV9KEaPhrgXwgCH9NlNbmYBZVh//RlTBXYcCjhbYeL2PIPP1J8qT5mzMq052zF
o1k0+YtXLBoiwfzqIOVTje84GMT9WVnIm8Vy1Pk1O0frD+aFwnC/kxjddAW8OXPp
adclTnElRfJGegHJGdQJ34+NAE9DDR6GxkTjDsjoZZTfDnXD1UiGRTawSTRarNSc
M8HgviBd9yyUcArKM3Z7Hn4V9cNtbdR1QP8BkMVk+Lz4OV6eY0fBIpwgpouu0YBr
SKDrvX5ro4YKBvcmi+bWnUSlGsjguUiqEKtdfCjJyAJAx7Nf14+I6Ye0mD/fxoho
6tRrCL67PigQsrfwbO2UnZuKQj14PaX81WCe0OeS/lIJYVO2ZGfB0a5ZF+qZn/ht
60w046XaLZ9+Pt0pJyHddSGkxAB3ojOWAb998pJl+qTG9+2x5/0MCUsdtKM6VYJb
3gfOBDOsdvBvsuDHzZmy
=uDdz
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_16_55_40_+1100_ihfuo2O9hVnwX3Zt--
