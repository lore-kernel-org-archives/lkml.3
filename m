Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaETHpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:45:25 -0400
Received: from ozlabs.org ([103.22.144.67]:33831 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbaETHpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:45:21 -0400
Date: Tue, 20 May 2014 17:45:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: linux-next: build warnings after merge of the input tree
Message-ID: <20140520174513.26247582@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Ocshdhk+reSrLYg7U13RCD5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ocshdhk+reSrLYg7U13RCD5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

After merging the input tree, today's linux-next build (powerpc
allyesconfig) produced these warnings:

drivers/input/touchscreen/atmel_mxt_ts.c: In function 'mxt_read_t9_resoluti=
on':
drivers/input/touchscreen/atmel_mxt_ts.c:1043:2: warning: passing argument =
1 of '__swab16s' makes pointer from integer without a cast [enabled by defa=
ult]
  le16_to_cpus(range.x);
  ^
In file included from include/linux/swab.h:4:0,
                 from include/uapi/linux/byteorder/big_endian.h:12,
                 from include/linux/byteorder/big_endian.h:4,
                 from arch/powerpc/include/uapi/asm/byteorder.h:13,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/powerpc/include/asm/bitops.h:279,
                 from include/linux/bitops.h:33,
                 from include/linux/kernel.h:10,
                 from include/asm-generic/bug.h:13,
                 from arch/powerpc/include/asm/bug.h:127,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/asm-generic/preempt.h:4,
                 from arch/powerpc/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/input/touchscreen/atmel_mxt_ts.c:16:
include/uapi/linux/swab.h:223:20: note: expected '__u16 *' but argument is =
of type 'u16'
 static inline void __swab16s(__u16 *p)
                    ^
drivers/input/touchscreen/atmel_mxt_ts.c:1044:2: warning: passing argument =
1 of '__swab16s' makes pointer from integer without a cast [enabled by defa=
ult]
  le16_to_cpus(range.y);
  ^
In file included from include/linux/swab.h:4:0,
                 from include/uapi/linux/byteorder/big_endian.h:12,
                 from include/linux/byteorder/big_endian.h:4,
                 from arch/powerpc/include/uapi/asm/byteorder.h:13,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/powerpc/include/asm/bitops.h:279,
                 from include/linux/bitops.h:33,
                 from include/linux/kernel.h:10,
                 from include/asm-generic/bug.h:13,
                 from arch/powerpc/include/asm/bug.h:127,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/asm-generic/preempt.h:4,
                 from arch/powerpc/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/input/touchscreen/atmel_mxt_ts.c:16:
include/uapi/linux/swab.h:223:20: note: expected '__u16 *' but argument is =
of type 'u16'
 static inline void __swab16s(__u16 *p)
                    ^
Introduced by commit de22385758fa ("Input: atmel_mxt_ts - read screen
config from chip").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Ocshdhk+reSrLYg7U13RCD5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTewgPAAoJEMDTa8Ir7ZwVEDAP/iWJ02uz8xcR8StrOwOwCqzp
Jg7olnFCwRLD6wR2U+dJ4HgOQbl0DAnOevQEBw1/uux/T9JfVM3eV0+WqHECfjC2
R0Oj0bKk0+8T6+BHeFErPEeQfOYmKDmwsvSJo+vy/FFFk73CbKwwu3kJdXKv8dts
n8xgBoA4kFWQkCnlImoMLxO/JFvkAPTvJ/MKiNDRDD8u9Y9yEEhZSAFcyvI/DEWf
yeYdhATBMVxjX2/jBYCIV9pkV9TitsoRlHPMl2BXRy96uGw+LbRtHYIbO8o8QmPE
NMwB82/PLU73hv4G9vxXXiwPXbiyQmjfZyig1a6H3B2jO0NHc5Ae5PkqqGdzj2wv
9XYaQpxlSuzcdpGPZHjp/CIMXt5yZZZ7iqLNlYhTO72mslTft0uV5Vx4klQGEpM5
6NzJ2mdG0c2qVpniQMa3uZ05xcV5BKtL60Kiegy5ej6bFrYH0k3gE7a5Aibr2Rs0
Aq2BIvE9pQspcUjDDQ9U6I/teE2WKhf9RGkB+xoE8TAdVkglopx+m88RBkp+F1WH
2ZmS1nRpXjodJNdNsDvkM7WaUOSFRdg/1EYCFVFgd3/tQtG0V6hQN4o2kntkMhOZ
NbSdg16RQGS15CvQ7Z5kEJSJszSfvVgm+G3P3momxOR5JtJag+ecnEbmr/7WAazf
D2tP9mzVXLf1Z6wVIq0f
=MdQi
-----END PGP SIGNATURE-----

--Sig_/Ocshdhk+reSrLYg7U13RCD5--
