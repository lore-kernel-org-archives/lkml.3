Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaDZKYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:24:51 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64667 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaDZKYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:24:49 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: intel_rapl: No such device
Date: Sat, 26 Apr 2014 12:24:45 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc2-generic; KDE/4.12.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1899371.bPdbjU1GMe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201404261224.45353@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1899371.bPdbjU1GMe
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

on intel haswell mobile cpu it is not possible to load intel_rapl=20
driver. Modprobe will show this error message:

intel_rapl.ko': -1 No such device
intel_rapl: driver does not support CPU family 6 model 60

Is not intel mobile cpu supported by intel_rapl?


Here is info from /proc/cpuinfo

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i5-4300M CPU @ 2.60GHz
stepping        : 3
microcode       : 0x17
cpu MHz         : 2585.375
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep=20
mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss=20
ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon=20
pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu=20
pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma=20
cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt=20
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat=20
epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid=20
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips        : 5187.99
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:


And from /sys/devices/system/cpu/modalias

cpu:type:x86,ven0000fam0006mod003C:feature:,0000,0001,0002,0003,0004,0005,0=
006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,0013,0015,0016,0017,0=
018,0019,001A,001B,001C,001D,001F,002B,0034,003A,003B,003D,0068,006B,006C,0=
06D,006F,0070,0072,0074,0075,0076,0078,007C,007D,0080,0081,0082,0083,0084,0=
085,0086,0087,0088,0089,008B,008C,008D,008E,008F,0091,0093,0094,0095,0096,0=
097,0098,0099,009A,009B,009C,009D,009E,00C0,00C5,00E0,00E1,00E3,00E4,00E5,0=
0E6,00E7,0100,0101,0102,0103,0104,0120,0121,0123,0124,0125,0127,0128,0129,0=
12A,012B,012D

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1899371.bPdbjU1GMe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlNbiW0ACgkQi/DJPQPkQ1KT4QCfc+KA2G+LxoNf5evkrvHZgbvw
WHsAninOFkPw+EZBzhmY4XNjqgy9b6iM
=Ok2p
-----END PGP SIGNATURE-----

--nextPart1899371.bPdbjU1GMe--
