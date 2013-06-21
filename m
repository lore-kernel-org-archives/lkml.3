Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423170Ab3FUGpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:45:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53949 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217Ab3FUGpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:45:15 -0400
Date: Fri, 21 Jun 2013 16:45:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Matt Porter <mporter@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the  tree
Message-Id: <20130621164512.261ad1e1a0cb27f45e955601@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_16_45_12_+1000_Ar/EafspWLIcjljv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_16_45_12_+1000_Ar/EafspWLIcjljv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
include/linux/mfd/davinci_voicecodec.h between commit 997174705458 ("mfd:
davinci_voicecodec: Fix build breakage") from the mfd tree and commit
3ad7a42d5a9c ("ARM: davinci: move private EDMA API to arm/common") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/davinci_voicecodec.h
index 810aee7,7dd6524..0000000
--- a/include/linux/mfd/davinci_voicecodec.h
+++ b/include/linux/mfd/davinci_voicecodec.h
@@@ -26,10 -26,8 +26,10 @@@
  #include <linux/kernel.h>
  #include <linux/platform_device.h>
  #include <linux/mfd/core.h>
+ #include <linux/platform_data/edma.h>
 =20
- #include <mach/edma.h>
 +#include <mach/hardware.h>
 +
  /*
   * Register values.
   */

--Signature=_Fri__21_Jun_2013_16_45_12_+1000_Ar/EafspWLIcjljv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw/Z4AAoJEECxmPOUX5FEfVUQAJ192S7hKakmRiaiMg3pTFWM
71y2PYwek3/HN8blv5vZLvll2RenD+w67Qpjjqcn4xoCM8NTBhN61KHo3PNzciXd
45dkmZwcESoMvrAUuA95XTwWUsPzUoGDG9vd5QrbGD0VHR0dOsUNsTrdheDYmGzv
9iJt7wQeFWKHHRVqvwIBkWnd+u1I3kJgoCjeJSTse9JguJbwU8zjqH+EAC04HGJ4
UrpEq4RNPiBxesbmWMTHULWXZARMZgssP8wufJ/SPk8kqtSO+z/bSuEstXwE1S4k
o849rq4rlERXPiohzNTv4AUTwNY2nAMNYujTLmCorLysZ68522G7+qTM4uoKiWvu
QW+DitFpG54o36oeoXevgohWF9oAFcmrXMuMlEmHw95R6l5YZldqRxx8DtGu6INp
FBaTgYfKyY/IMu3PQ/2fEGBOWcqeM2p+QCIMRU0qMkkjVeCw1P/XUjBAZ/amb7rx
Qu1MOaqd/33s6BGLmHXcXKUoR17S3EXs3cFL7QdC12tZJpjNzTRE/RYCHjJZ78s6
ZXim7ov2cvSOuyMvqtbKHdGgT9KOiVXX6kCPZfUjAwHal4tfUnhGn1Szd6BuH6De
vfY5ec6yMomxogrjMahRXu78VfD7KEn6ykIgHAEIBpcYJ+7TF96PWZVWeC01nem9
znW6c3zynvdAQu6+qqft
=ZZEq
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_16_45_12_+1000_Ar/EafspWLIcjljv--
