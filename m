Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaIJELL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:11:11 -0400
Received: from ozlabs.org ([103.22.144.67]:38702 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaIJELK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:11:10 -0400
Date: Wed, 10 Sep 2014 14:10:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        viresh kumar <viresh.kumar@linaro.org>
Subject: linux-next: manual merge of the pm tree with the mvebu tree
Message-ID: <20140910141057.21726568@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/O7Cmgyn4rCF9WwQd0Niqx=/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O7Cmgyn4rCF9WwQd0Niqx=/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
arch/arm/configs/mvebu_v7_defconfig between commit fc9fa8714a75 ("ARM:
mvebu: update v7 defconfig with useful options") from the mvebu tree
and commit 978027e170fb ("cpufreq: cpu0: rename driver and internals to
'cpufreq_dt'") from the pm tree.

I fixed it up (maybe - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/configs/mvebu_v7_defconfig
index 0acbe1134eba,7309988b0f1f..000000000000
--- a/arch/arm/configs/mvebu_v7_defconfig
+++ b/arch/arm/configs/mvebu_v7_defconfig
@@@ -25,14 -29,12 +25,15 @@@ CONFIG_ZBOOT_ROM_TEXT=3D0x
  CONFIG_ZBOOT_ROM_BSS=3D0x0
  CONFIG_ARM_APPENDED_DTB=3Dy
  CONFIG_ARM_ATAG_DTB_COMPAT=3Dy
 +CONFIG_CPU_FREQ=3Dy
  CONFIG_CPU_IDLE=3Dy
  CONFIG_ARM_MVEBU_V7_CPUIDLE=3Dy
 -CONFIG_CPU_FREQ=3Dy
+ CONFIG_CPUFREQ_DT=3Dy
  CONFIG_VFP=3Dy
 +CONFIG_NEON=3Dy
  CONFIG_NET=3Dy
 +CONFIG_PACKET=3Dy
 +CONFIG_UNIX=3Dy
  CONFIG_INET=3Dy
  CONFIG_IP_PNP=3Dy
  CONFIG_IP_PNP_DHCP=3Dy

--Sig_/O7Cmgyn4rCF9WwQd0Niqx=/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUD89bAAoJEMDTa8Ir7ZwV6icP/1dzg/4ecMXzJOw5OyoCd/3n
6gR/RWgvaUjm7JFi8BPpBvw843BNNp2lqn61EIwS4LPPBKO64QOHwWDtMDZ5kGmM
lR+QKTGZ3bHVFlFO5Bav4+oGujKHWcLdst6vc3y3j8x7tz/91hHvpSK3RK45wKwG
Mx12C01JO3fTPKehzhKlK1CFE9yp4eBflwqIs6FVyKd7SyHY90OHPKp4wXz19Rvk
uDLa1lf2rhWFvcS0jSzosUNabpr+9MYi0cQRW2jLhFaw9I4hRmus3s6rnvGZyzy0
ofv8XWrNFf4NKfVCsyknK6g1MCcwKAvPk+6xO1V4p1q16fDpdpR6WappbDwLJZhy
QW7R4ujYeAuCV1YXSJvpJo64xqmI5Ir6DrGgBNKAoK6tEd1jTDweutVWkAOCX83Q
dLEOdFCZXPRRT6jVTEFzADJfLvfzc6DKDxIaT4NXw8eh/W8DClbxkp1Ka/w0EyjD
bKztFrsWdNEVctu6otFScjbl1rsdbCoe2P+vLDu+SKB8/9w4S/JfoVzjP6j97Cl7
+8KKgbLdq8KxDlMXSt4gMYCYtrTTwreoFEBLr5KCufsbWcJeElJ2S/2hOYRF7GkA
cDkXz/dDqV4ORziJtimigKU0b0cksb0j8x2kBN4Or4OogLdoWc+YXhtpZK0sljzv
jRCcOKL6cbZJ/HYJ5MKn
=x+6F
-----END PGP SIGNATURE-----

--Sig_/O7Cmgyn4rCF9WwQd0Niqx=/--
