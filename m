Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaE0Sxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:53:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59595 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaE0Sxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:53:41 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: next-20140529 - 'perf' fails to build on Fedora Rawhide...
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1401216702_14392P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 May 2014 14:51:42 -0400
Message-ID: <15963.1401216702@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1401216702_14392P
Content-Type: text/plain; charset=us-ascii

So what did I do wrong with this build of 'perf' (other than
trying to do it on a Fedora Rawhide box updated to last night? :)

(The obvious hack fix is to change the '#define _BSD_SOURCE 1' in util/util.h
to use _DEFAULT_SOURCE instead, but not sure how that plays on older
userspaces, as that was a glibc 2.19 feature that only escaped about
3 months ago....)

[/usr/src/linux-next/tools/perf] make
  BUILD:   Doing 'make -j4' parallel build
config/Makefile:580: No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev

Auto-detecting system features:
...                         dwarf: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...                       libnuma: [ OFF ]
...                       libperl: [ OFF ]
...                     libpython: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...     DWARF post unwind library: libunwind

  GEN      common-cmds.h
  FLAGS:   * new build flags or prefix
  CC       bench/mem-memcpy-x86-64-asm.o
  CC       bench/mem-memset-x86-64-asm.o
  CC       bench/mem-memcpy.o
  CC       bench/mem-memset.o
  CC       bench/futex-hash.o
  CC       bench/futex-wake.o
  CC       bench/futex-requeue.o
  CC       builtin-diff.o
In file included from /usr/include/unistd.h:25:0,
                 from util/util.h:44,
                 from builtin.h:4,
                 from builtin-diff.c:7:
/usr/include/features.h:148:3: error: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Werror=cpp]
 # warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE"
   ^
  CC       builtin-evlist.o
  CC       builtin-help.o
In file included from /usr/include/unistd.h:25:0,
                 from util/util.h:44,
                 from builtin.h:4,
                 from builtin-evlist.c:5:
/usr/include/features.h:148:3: error: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Werror=cpp]
 # warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE"
   ^
cc1: all warnings being treated as errors
make[1]: *** [builtin-evlist.o] Error 1
make[1]: *** Waiting for unfinished jobs....
cc1: all warnings being treated as errors
make[1]: *** [builtin-diff.o] Error 1
  PERF_VERSION = 3.15.rc7.g531a53
make: *** [all] Error 2


--==_Exmh_1401216702_14392P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU4TevgdmEQWDXROgAQKT1hAAm0Lna8gLcZ/i2vpx4uSWA4lx/6o4837J
gQSgzIAK28hy9P7Ro6rbrHArlO5PCIcYBV7bAVSGKqTragqaDy8jiQ590Bq6uZ1k
Z9KuUE4nG4PZbx0k0CkxIa6tWyGoH73JqKeAjtwsMEV8eKInlDv1rIcoJu7lKD3w
9srrjgpcRAjB1n143+DyoLTiysyQZiw/WUTKTSgA4TMapyCmwR444GQFVx3RZjN0
LAn/6DfX4QpOFm4/BU5B/zoLmo6bFv5y6/6Jx6iEQeTKy2ntSIJGZ42L6P+Rze4A
SzYiz9Ks3ug7oBxUZfO7heFDp02nmy4jc9TgUMbP7Ttc7QCyVZoTzt3qJk80Rbdf
J0U5t3yOcyRezJywAHo8UNsqSGKDA27MhrOzQK0CA2rev/9tpPwefQXFWCWbO9XP
hqlA06mht5khga0Mo1obp9TU+higfjTPO2sXbkPZY13dVtzjBvlXwoXMZMK8zO6c
QEDJD2fwYQre0QnGolzZrkHoJcD2/AiK17y3iFwU60m4QW/U6+XecK0EfuNnke6W
nriB9zejSJx6Fzk9YI+pavfqyfmn0VTuI9k2JlGWPwM6rEP3UjrrBpIt2pMMWvZD
94lcOSz0+rYrrrhpp+UGD1NgI7Z/FYT9SOZxZ/v6jkzrCqoTH3dHvFKvc8t6BCbs
sGKxRCEIzdo=
=hwqa
-----END PGP SIGNATURE-----

--==_Exmh_1401216702_14392P--
