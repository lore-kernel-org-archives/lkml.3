Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbaFTF1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:27:14 -0400
Received: from ozlabs.org ([103.22.144.67]:52073 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934263AbaFTF1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:27:12 -0400
Date: Fri, 20 Jun 2014 15:27:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: linux-next: build warning after merge of the akpm-current tree
Message-ID: <20140620152703.157a66fd@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/G4V=vahUxKDw9mie/dQs9Ph"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/G4V=vahUxKDw9mie/dQs9Ph
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

In file included from include/linux/printk.h:257:0,
                 from include/linux/kernel.h:13,
                 from arch/x86/include/asm/percpu.h:44,
                 from arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from crypto/zlib.c:26:
crypto/zlib.c: In function 'zlib_compress_update':
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 4 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:171:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 5 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:171:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 6 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:171:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
crypto/zlib.c: In function 'zlib_compress_final':
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 4 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:201:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 5 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:201:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 6 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:201:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
crypto/zlib.c: In function 'zlib_decompress_update':
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 4 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:286:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 5 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:286:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 6 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:286:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
crypto/zlib.c: In function 'zlib_decompress_final':
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 4 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:334:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 5 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:334:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format '%u' expects argument =
of type 'unsigned int', but argument 6 has type 'uLong' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
crypto/zlib.c:334:2: note: in expansion of macro 'pr_debug'
  pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
  ^


Introduced by commit 8d9dfa4b0125 ("initramfs: support initramfs that
is more than 2G").  Grep is your friend :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/G4V=vahUxKDw9mie/dQs9Ph
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTo8YsAAoJEMDTa8Ir7ZwV4MUQAJLeBGxvsAjvTFQk8Rc9MxZT
nga/NoUQxmljWz1IbRxqabSkB/taxmgHXTLj2IKVm9Qz+tH24IaEA9FEYNw+XcZs
+wKVy2gRSvSIhNOrkJXN/JpOmiEhmPp2KrXl7vqnX/FrpF1kirQYlfdgfh0ytaaK
5sxVLBgVGX8yfQq4upPWyIjQ4HlUBeJnbSQs/a4790kEp6rd3DdENWPkLy1lLcRe
yYGEi3oPPEVZZerWbx7eEm00oZm/WzHiixMNcwuR/pRo55Lj43AVY0/zK23M7IRv
c/ZENt0L6araydKk3y4aM79ayPDPgwf1mJQmWW64U5QS19aWodcV+hLQK9CUZ/n0
HwXPNfLVxb3puA5rscc47UYNhjPqcN747j5r0XQ1N41gBKpS3slgWni60CivHABZ
OCprUjG2udNcyxLvFsu5GZkyeK5ixkJjFiAi/9Rx0DLEC4jgyaPWfao7Z9mDpgeN
XQDIav2SvD/itCl63IzXF2YCeEUv9kKXu6z7+5SlnOBUOkGZYdSVwgaJZwUW4CSR
WmgEEXqAoSKgZL4vR01zLTvs/8fF/U3VmGUB4AxzPeTVoRoB6GMhKXJa1GqRRExs
CTBWiDLmwEBQR+jgiTUUyji2eXx7rhD8OndQpaR1d4AEexaM9ZrvMBbne3EKyugr
OD3/oYk9chU+6nMGSll5
=6Hx7
-----END PGP SIGNATURE-----

--Sig_/G4V=vahUxKDw9mie/dQs9Ph--
