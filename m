Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaDHHQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:16:14 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:61475 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbaDHHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:16:12 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: git@xilinx.com, wsa@the-dreams.de, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: [PATCH] asm-generic/io.h: Add default configuration for readX/writeX_relaxed
Date: Tue,  8 Apr 2014 09:16:01 +0200
Message-Id: <35729b5d2bf080d3029f69af4bc638a268bf1a8f.1396941358.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-26422-1396941361-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-26422-1396941361-0001

Define default readX/writeX_relaxed IO helper functions
for all archs which use asm-generic/io.h.
Using COMPILE_TEST, moving drivers out of arch/arm and
removing architecture dependencies in Kconfig is causing
that more and more drivers is using _relaxed IO helper
functions which is causing compilation failures on architectures
which don't define them.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

git://git.monstr.eu/linux-2.6-microblaze  xnext/io
4b9d4a7ed112d0b68b654f09b87ad16ccd644a47  asm-generic/io.h: Add default configuration for readX/writeX_relaxed

elapsed time: 59m

configs tested: 119

sparc                               defconfig
sparc64                          allmodconfig
sparc64                           allnoconfig
sparc64                             defconfig
avr32                      atngw100_defconfig
avr32                     atstk1006_defconfig
frv                                 defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
arm                              allmodconfig
arm                               allnoconfig
arm                                      arm5
arm                                     arm67
arm                         at91_dt_defconfig
arm                                  at_hdmac
arm                                    ep93xx
arm                       imx_v6_v7_defconfig
arm                                  iop-adma
arm                          marzen_defconfig
arm                                       mmp
arm                       omap2plus_defconfig
arm                          prima2_defconfig
arm                         s3c2410_defconfig
arm                                    sa1100
arm                                   samsung
arm                                        sh
arm                       spear13xx_defconfig
arm                           tegra_defconfig
x86_64                            allnoconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
x86_64                     randconfig-c0-0407
x86_64                     randconfig-c1-0407
x86_64                     randconfig-c2-0407
x86_64                     randconfig-c3-0407
ia64                             alldefconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
microblaze                       allyesconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
mips                             allmodconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                                     txx9
i386                             allyesconfig
i386                             alldefconfig
i386                             allmodconfig
i386                              allnoconfig
i386                                defconfig
m32r                       m32104ut_defconfig
m32r                     mappi3.smp_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
i386                      randconfig-fd0-0407
i386                      randconfig-fd1-0407
i386                      randconfig-fd2-0407
i386                      randconfig-fd3-0407
powerpc                      chroma_defconfig
powerpc               corenet64_smp_defconfig
powerpc                    gamecube_defconfig
powerpc                 linkstation_defconfig
powerpc                         wii_defconfig
i386                      randconfig-iv0-0407
i386                      randconfig-iv1-0407
i386                      randconfig-iv2-0407
i386                      randconfig-iv3-0407
x86_64                           allmodconfig
x86_64                    randconfig-sb0-0407
x86_64                    randconfig-sb1-0407
x86_64                    randconfig-sb2-0407
x86_64                    randconfig-sb3-0407
m68k                             allmodconfig
m68k                          amiga_defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
i386                       randconfig-r0-0407
i386                       randconfig-r1-0407
i386                       randconfig-r2-0407
i386                       randconfig-r3-0407
s390                             allmodconfig
s390                              allnoconfig
s390                                defconfig
x86_64                 randconfig-s0-03291922
x86_64                 randconfig-s1-03291922
x86_64                 randconfig-s2-03291922
x86_64                 randconfig-s3-03291922
x86_64                 randconfig-s4-03291922
x86_64                 randconfig-s5-03291922
arm                      jornada720_defconfig
ia64                            sim_defconfig
x86_64                                    lkp
x86_64                                   rhel
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
---
 include/asm-generic/io.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index d5afe96..0b1de87 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -73,6 +73,18 @@ static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
 }
 #endif

+#ifndef readb_relaxed
+#define readb_relaxed readb
+#endif
+
+#ifndef readw_relaxed
+#define readw_relaxed readw
+#endif
+
+#ifndef readl_relaxed
+#define readl_relaxed readl
+#endif
+
 #ifndef __raw_writew
 static inline void __raw_writew(u16 b, volatile void __iomem *addr)
 {
@@ -91,6 +103,18 @@ static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
 #define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)

+#ifndef writeb_relaxed
+#define writeb_relaxed writeb
+#endif
+
+#ifndef writew_relaxed
+#define writew_relaxed writew
+#endif
+
+#ifndef writel_relaxed
+#define writel_relaxed writel
+#endif
+
 #ifdef CONFIG_64BIT
 #ifndef __raw_readq
 static inline u64 __raw_readq(const volatile void __iomem *addr)
--
1.8.2.3


--=_mimegpg-monstr-desktop-26422-1396941361-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlNDojEACgkQykllyylKDCEZTwCcCYvfnPJc34F7W6sdZjg1y/Ng
rFEAn2UAZQBFdEHquyH14qWancN9AZR/
=VZh1
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-26422-1396941361-0001--
