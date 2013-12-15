Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3LOMGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:06:15 -0500
Received: from nm3-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.154]:24781 "HELO
	nm3-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754074Ab3LOMGN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:06:13 -0500
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2013 07:06:13 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 239256.40718.bm@omp1008.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=DZJj7EXRC3sWUcZszJUnFEQZ1SHtTaT9IowRgeWpCtG91vHmfKAu2HBDE48oQ2aGOSCCyyRo92e6VYCcV+v4BLZ9ESxZ6/7fIJ67qdY8fu7Q6y2Md+sIT/eWz6ZwTn4R/6WeFnm7g9STA/OOKxbvSwz6JTiRbL653QOTb2UR1+c=;
X-YMail-OSG: bbPBZ7cVM1niknCS9aHboTb8OFPJV2TGbn_FXsKsyuZBCNR
 mvaXsTDd1euyjZU8FdX4YX.62iIUq3ZPC4nBQXH4awkA9AUED5E9Lbe8WiHj
 19Tu1d4E.VnPkd3JEDTEpR.KXHrxxHPBMWLOqOMacur3aaI0OQbbtY4O4hCC
 PQJvE4c5tU6mw4VjsinzUfmfYXereMgq0n06W4LO9B.QAVG69hDBgR.wC2.C
 oitcFODu3Y2b3wXhHJUs6DiXTuhKknVVPHSI5oyHett1IOJYpJ3wj4Z6.rKx
 UXizNxJRyMoF7u4mu5jrvTxzl9Ad7sYDVMOoJnMSDpVsHY21X9runFy2t9Qd
 Mb1PWImVP7yWON7pIsqOnxpvuMK1yUWZrXfptajir2Hn1bJu3zoacZqaz41P
 rnW_TYff.dX1_D6L5nt8COFOaUvJ.ol7jbG5HGNvEUcL9jfA6spQT6BmwDpS
 0onZrjiSO54TlR4tr96GA7hgrUbiYfCt8TgYFAcWpfsChskVKtq038iUHqeP
 QFOEWUgWdN7nA3QAo1wqFucfyNZvQxOT8gcCPSFKo_cffnshJIYo1iDqceXb
 tr4ter_vAbZqG1ykZg1glPJIoLyi2vVhj8dTxc2MfBU.zifk3jQ0QTq87hAz
 ulywSXKnySYNuJoa86DOSzwozK8GNYla3.QDx8QcLmT0K_42T
X-Rocket-MIMEInfo: 002.001,LS0tLS0gT3JpZ2luYWwgTWVzc2FnZSAtLS0tLQoKPiBGcm9tOiBILiBQZXRlciBBbnZpbiA8aHBhQHp5dG9yLmNvbT4KPiBTZW50OiBTYXR1cmRheSwgRGVjZW1iZXIgMTQsIDIwMTMgNjo0MSBQTQo.IFN1YmplY3Q6IFJlOiBGdzogW1BBVENIXSBleHBhbmQgbWljcm8tb3B0aW1pemF0aW9ucyBpbiBrZXJuZWwgdG8gbmV3ZXIgbW9kZWwgQ1BVcwoKPiAKPiBQbGVhc2Ugc3VibWl0IGluIHRoZSBlbWFpbCBmb3JtIHJlcXVlc3RlZCBieSB0aGUKPiBEb2N1bWVudGF0aW9uL1N1Ym1pdHRpbmdQYXRjaGVzIGVtYWkBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.169.609
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com> <864985fbeb1d8148439e25ec01f47a67@ixit.cz> <52AAFF89.5080509@gmail.com> <1387051250.86178.YahooMailNeo@web140005.mail.bf1.yahoo.com> <ce679ca5-bf83-4c2a-9234-859cc7a4206b@email.android.com> <1387057337.97000.YahooMailNeo@web140004.mail.bf1.yahoo.com> <52ACECC4.208@zytor.com> 
Message-ID: <1387108841.76039.YahooMailNeo@web140006.mail.bf1.yahoo.com>
Date: Sun, 15 Dec 2013 04:00:41 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
To: "H. Peter Anvin" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david.heidelberger@ixit.cz" <david.heidelberger@ixit.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <52ACECC4.208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

> From: H. Peter Anvin <hpa@zytor.com>
> Sent: Saturday, December 14, 2013 6:41 PM
> Subject: Re: Fw: [PATCH] expand micro-optimizations in kernel to newer model CPUs

> 
> Please submit in the email form requested by the
> Documentation/SubmittingPatches email; in particular we need the
> Signed-off-by: statements.
> 
> 
>     -hpa
> 

From: John Audia <da_audiophile@yahoo.com>


Signed-off-by: John Audia <da_audiophile@yahoo.com>


This patch has been tested on and known to work with kernel versions from 3.2
up to the latest git version (pulled on 12/14/2013).

This patch will expand the number of microarchitectures to include new
processors including: AMD K10-family, AMD Family 10h (Barcelona), AMD Family
14h (Bobcat), AMD Family 15h (Bulldozer), AMD Family 15h (Piledriver), AMD
Family 16h (Jaguar), Intel 1st Gen Core i3/i5/i7 (Nehalem), Intel 2nd Gen Core
i3/i5/i7 (Sandybridge), Intel 3rd Gen Core i3/i5/i7 (Ivybridge), and Intel 4th
Gen Core i3/i5/i7 (Haswell). It also offers the compiler the 'native' flag.

Small but real speed increases are measurable using a make endpoint comparing
a generic kernel to one built with one of the respective microarchs.

See the following experimental evidence of this statement:
https://github.com/graysky2/kernel_gcc_patch

---
diff -uprN a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
--- a/arch/x86/include/asm/module.h2013-11-03 18:41:51.000000000 -0500
+++ b/arch/x86/include/asm/module.h2013-12-15 06:21:24.351122516 -0500
@@ -15,6 +15,16 @@
 #define MODULE_PROC_FAMILY "586MMX "
 #elif defined CONFIG_MCORE2
 #define MODULE_PROC_FAMILY "CORE2 "
+#elif defined CONFIG_MNATIVE
+#define MODULE_PROC_FAMILY "NATIVE "
+#elif defined CONFIG_MCOREI7
+#define MODULE_PROC_FAMILY "COREI7 "
+#elif defined CONFIG_MCOREI7AVX
+#define MODULE_PROC_FAMILY "COREI7AVX "
+#elif defined CONFIG_MCOREAVXI
+#define MODULE_PROC_FAMILY "COREAVXI "
+#elif defined CONFIG_MCOREAVX2
+#define MODULE_PROC_FAMILY "COREAVX2 "
 #elif defined CONFIG_MATOM
 #define MODULE_PROC_FAMILY "ATOM "
 #elif defined CONFIG_M686
@@ -33,6 +43,18 @@
 #define MODULE_PROC_FAMILY "K7 "
 #elif defined CONFIG_MK8
 #define MODULE_PROC_FAMILY "K8 "
+#elif defined CONFIG_MK10
+#define MODULE_PROC_FAMILY "K10 "
+#elif defined CONFIG_MBARCELONA
+#define MODULE_PROC_FAMILY "BARCELONA "
+#elif defined CONFIG_MBOBCAT
+#define MODULE_PROC_FAMILY "BOBCAT "
+#elif defined CONFIG_MBULLDOZER
+#define MODULE_PROC_FAMILY "BULLDOZER "
+#elif defined CONFIG_MPILEDRIVER
+#define MODULE_PROC_FAMILY "PILEDRIVER "
+#elif defined CONFIG_MJAGUAR
+#define MODULE_PROC_FAMILY "JAGUAR "
 #elif defined CONFIG_MELAN
 #define MODULE_PROC_FAMILY "ELAN "
 #elif defined CONFIG_MCRUSOE
diff -uprN a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu2013-11-03 18:41:51.000000000 -0500
+++ b/arch/x86/Kconfig.cpu2013-12-15 06:21:24.351122516 -0500
@@ -139,7 +139,7 @@ config MPENTIUM4
 
 
 config MK6
-bool "K6/K6-II/K6-III"
+bool "AMD K6/K6-II/K6-III"
 depends on X86_32
 ---help---
   Select this for an AMD K6-family processor.  Enables use of
@@ -147,7 +147,7 @@ config MK6
   flags to GCC.
 
 config MK7
-bool "Athlon/Duron/K7"
+bool "AMD Athlon/Duron/K7"
 depends on X86_32
 ---help---
   Select this for an AMD Athlon K7-family processor.  Enables use of
@@ -155,12 +155,55 @@ config MK7
   flags to GCC.
 
 config MK8
-bool "Opteron/Athlon64/Hammer/K8"
+bool "AMD Opteron/Athlon64/Hammer/K8"
 ---help---
   Select this for an AMD Opteron or Athlon64 Hammer-family processor.
   Enables use of some extended instructions, and passes appropriate
   optimization flags to GCC.
 
+config MK10
+bool "AMD 61xx/7x50/PhenomX3/X4/II/K10"
+---help---
+  Select this for an AMD 61xx Eight-Core Magny-Cours, Athlon X2 7x50,
+Phenom X3/X4/II, Athlon II X2/X3/X4, or Turion II-family processor.
+  Enables use of some extended instructions, and passes appropriate
+  optimization flags to GCC.
+
+config MBARCELONA
+bool "AMD Barcelona"
+---help---
+  Select this for AMD Barcelona and newer processors.
+
+  Enables -march=barcelona
+
+config MBOBCAT
+bool "AMD Bobcat"
+---help---
+  Select this for AMD Bobcat processors.
+
+  Enables -march=btver1
+
+config MBULLDOZER
+bool "AMD Bulldozer"
+---help---
+  Select this for AMD Bulldozer processors.
+
+  Enables -march=bdver1
+
+config MPILEDRIVER
+bool "AMD Piledriver"
+---help---
+  Select this for AMD Piledriver processors.
+
+  Enables -march=bdver2
+
+config MJAGUAR
+bool "AMD Jaguar"
+---help---
+  Select this for AMD Jaguar processors.
+
+  Enables -march=btver2
+
 config MCRUSOE
 bool "Crusoe"
 depends on X86_32
@@ -251,8 +294,17 @@ config MPSC
   using the cpu family field
   in /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one.
 
+config MATOM
+bool "Intel Atom"
+---help---
+
+  Select this for the Intel Atom platform. Intel Atom CPUs have an
+  in-order pipelining architecture and thus can benefit from
+  accordingly optimized code. Use a recent GCC with specific Atom
+  support in order to fully benefit from selecting this option.
+
 config MCORE2
-bool "Core 2/newer Xeon"
+bool "Intel Core 2"
 ---help---
 
   Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and
@@ -260,14 +312,40 @@ config MCORE2
   family in /proc/cpuinfo. Newer ones have 6 and older ones 15
   (not a typo)
 
-config MATOM
-bool "Intel Atom"
+  Enables -march=core2
+
+config MCOREI7
+bool "Intel Core i7"
 ---help---
 
-  Select this for the Intel Atom platform. Intel Atom CPUs have an
-  in-order pipelining architecture and thus can benefit from
-  accordingly optimized code. Use a recent GCC with specific Atom
-  support in order to fully benefit from selecting this option.
+  Select this for the Intel Nehalem platform. Intel Nehalem proecessors
+  include Core i3, i5, i7, Xeon: 34xx, 35xx, 55xx, 56xx, 75xx processors.
+
+  Enables -march=corei7
+
+config MCOREI7AVX
+bool "Intel Core 2nd Gen AVX"
+---help---
+
+  Select this for 2nd Gen Core processors including Sandy Bridge.
+
+  Enables -march=corei7-avx
+
+config MCOREAVXI
+bool "Intel Core 3rd Gen AVX"
+---help---
+
+  Select this for 3rd Gen Core processors including Ivy Bridge.
+
+  Enables -march=core-avx-i
+
+config MCOREAVX2
+bool "Intel Core AVX2"
+---help---
+
+  Select this for AVX2 enabled processors including Haswell.
+
+  Enables -march=core-avx2
 
 config GENERIC_CPU
 bool "Generic-x86-64"
@@ -276,6 +354,19 @@ config GENERIC_CPU
   Generic x86-64 CPU.
   Run equally well on all x86-64 CPUs.
 
+config MNATIVE
+ bool "Native optimizations autodetected by GCC"
+ ---help---
+
+   GCC 4.2 and above support -march=native, which automatically detects
+   the optimum settings to use based on your processor. -march=native 
+   also detects and applies additional settings beyond -march specific
+   to your CPU, (eg. -msse4). Unless you have a specific reason not to
+   (e.g. distcc cross-compiling), you should probably be using
+   -march=native rather than anything listed below.
+
+   Enables -march=native
+
 endchoice
 
 config X86_GENERIC
@@ -300,7 +391,7 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_L1_CACHE_SHIFT
 int
 default "7" if MPENTIUM4 || MPSC
-default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
+default "6" if MK7 || MK8 || MK10 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MJAGUAR || MPENTIUMM || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MATOM || MVIAC7 || X86_GENERIC || MNATIVE || GENERIC_CPU
 default "4" if MELAN || M486 || MGEODEGX1
 default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
@@ -331,11 +422,11 @@ config X86_ALIGNMENT_16
 
 config X86_INTEL_USERCOPY
 def_bool y
-depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
+depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || MNATIVE || X86_GENERIC || MK8 || MK7 || MK10 || MBARCELONA || MEFFICEON || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2
 
 config X86_USE_PPRO_CHECKSUM
 def_bool y
-depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
+depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MK10 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MATOM || MNATIVE
 
 config X86_USE_3DNOW
 def_bool y
@@ -363,17 +454,17 @@ config X86_P6_NOP
 
 config X86_TSC
 def_bool y
-depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MATOM) && !X86_NUMAQ) || X86_64
+depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MK10 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MJAGUAR || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MCOREI7 || MCOREI7-AVX || MATOM) && !X86_NUMAQ) || X86_64 || MNATIVE
 
 config X86_CMPXCHG64
 def_bool y
-depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
+depends on X86_PAE || X86_64 || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM || MNATIVE
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
 config X86_CMOV
 def_bool y
-depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM || MGEODE_LX)
+depends on (MK8 || MK10 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MJAGUAR || MK7 || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MNATIVE || MATOM || MGEODE_LX)
 
 config X86_MINIMUM_CPU_FAMILY
 int
diff -uprN a/arch/x86/Makefile b/arch/x86/Makefile
--- a/arch/x86/Makefile2013-11-03 18:41:51.000000000 -0500
+++ b/arch/x86/Makefile2013-12-15 06:21:24.354455723 -0500
@@ -61,11 +61,26 @@ else
 KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
 
         # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
+        cflags-$(CONFIG_MNATIVE) += $(call cc-option,-march=native)
         cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
+        cflags-$(CONFIG_MK10) += $(call cc-option,-march=amdfam10)
+        cflags-$(CONFIG_MBARCELONA) += $(call cc-option,-march=barcelona)
+        cflags-$(CONFIG_MBOBCAT) += $(call cc-option,-march=btver1)
+        cflags-$(CONFIG_MBULLDOZER) += $(call cc-option,-march=bdver1)
+        cflags-$(CONFIG_MPILEDRIVER) += $(call cc-option,-march=bdver2)
+        cflags-$(CONFIG_MJAGUAR) += $(call cc-option,-march=btver2)
         cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
 
         cflags-$(CONFIG_MCORE2) += \
-                $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
+                $(call cc-option,-march=core2,$(call cc-option,-mtune=core2))
+        cflags-$(CONFIG_MCOREI7) += \
+                $(call cc-option,-march=corei7,$(call cc-option,-mtune=corei7))
+        cflags-$(CONFIG_MCOREI7AVX) += \
+                $(call cc-option,-march=corei7-avx,$(call cc-option,-mtune=corei7-avx))
+        cflags-$(CONFIG_MCOREAVXI) += \
+                $(call cc-option,-march=core-avx-i,$(call cc-option,-mtune=core-avx-i))
+        cflags-$(CONFIG_MCOREAVX2) += \
+                $(call cc-option,-march=core-avx2,$(call cc-option,-mtune=core-avx2))
 cflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
 $(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
         cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
diff -uprN a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
--- a/arch/x86/Makefile_32.cpu2013-11-03 18:41:51.000000000 -0500
+++ b/arch/x86/Makefile_32.cpu2013-12-15 06:21:24.354455723 -0500
@@ -23,7 +23,14 @@ cflags-$(CONFIG_MK6)+= -march=k6
 # Please note, that patches that add -march=athlon-xp and friends are pointless.
 # They make zero difference whatsosever to performance at this time.
 cflags-$(CONFIG_MK7)+= -march=athlon
+cflags-$(CONFIG_MNATIVE) += $(call cc-option,-march=native)
 cflags-$(CONFIG_MK8)+= $(call cc-option,-march=k8,-march=athlon)
+cflags-$(CONFIG_MK10)+= $(call cc-option,-march=amdfam10,-march=athlon)
+cflags-$(CONFIG_MBARCELONA)+= $(call cc-option,-march=barcelona,-march=athlon)
+cflags-$(CONFIG_MBOBCAT)+= $(call cc-option,-march=btver1,-march=athlon)
+cflags-$(CONFIG_MBULLDOZER)+= $(call cc-option,-march=bdver1,-march=athlon)
+cflags-$(CONFIG_MPILEDRIVER)+= $(call cc-option,-march=bdver2,-march=athlon)
+cflags-$(CONFIG_MJAGUAR)+= $(call cc-option,-march=btver2,-march=athlon)
 cflags-$(CONFIG_MCRUSOE)+= -march=i686 $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MEFFICEON)+= -march=i686 $(call tune,pentium3) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MWINCHIPC6)+= $(call cc-option,-march=winchip-c6,-march=i586)
@@ -32,6 +39,10 @@ cflags-$(CONFIG_MCYRIXIII)+= $(call cc-
 cflags-$(CONFIG_MVIAC3_2)+= $(call cc-option,-march=c3-2,-march=i686)
 cflags-$(CONFIG_MVIAC7)+= -march=i686
 cflags-$(CONFIG_MCORE2)+= -march=i686 $(call tune,core2)
+cflags-$(CONFIG_MCOREI7)+= -march=i686 $(call tune,corei7)
+cflags-$(CONFIG_MCOREI7AVX)+= -march=i686 $(call tune,corei7-avx)
+cflags-$(CONFIG_MCOREAVXI)+= -march=i686 $(call tune,core-avx-i)
+cflags-$(CONFIG_MCOREAVX2)+= -march=i686 $(call tune,core-avx2)
 cflags-$(CONFIG_MATOM)+= $(call cc-option,-march=atom,$(call cc-option,-march=core2,-march=i686)) \
 $(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
