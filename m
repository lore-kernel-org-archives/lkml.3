Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3LRBE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:04:27 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64848 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750875Ab3LRBE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:04:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Wed, 18 Dec 2013 02:17:38 +0100
Message-ID: <3421207.2WIkp69pe3@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131218120026.aa6c48feca3e24c59b5bf4c3@canb.auug.org.au>
References: <20131218120026.aa6c48feca3e24c59b5bf4c3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2597279.Dcx8d1QEKD"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2597279.Dcx8d1QEKD
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Wednesday, December 18, 2013 12:00:26 PM Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/acpi/nvs.c:15:27: fatal error: linux/acpi_io.h: No such file or directory
>  #include <linux/acpi_io.h>
>                            ^
> 
> Caused by commit a99493647c1a ("Merge branch 'acpi-cleanup' into
> linux-next") which incorrectly reintroduced the include of
> linux/acpi_io.h.
> 
> I have used the pm tree from next-20131217 for today.

Sorry for the breakage, I messed up a conflict resolution.  It should be
fixed now in my tree FWIW.

Thanks,
Rafael

--nextPart2597279.Dcx8d1QEKD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJSsPe4AAoJEILEb/54YlRxeDsQAIn6YDAqyYwCg9hYNvMg1lTA
VDjC1nen0B92inSCCwX5m2PxqYp+e7f4UxTS3IwdpeMYvar2xFBELJBG8jy5QL1S
DO3VuHoeNgAczrJYq7iyPKodl65PI1r5/y/eCUau7sEgtCut+NO/6PoFRZ7SgcTk
lpvshIUtJFK+rfnLpFQaX8zafUZ2rfro5rEoFvzEF8L213gHRoOunlMLRTqtCYkB
TRtik3cVqrqRtG/u5pk/vBkpx+Psv31IYNVYj3YsnvfsGjzAL2lG+Kc/TCeCFoGc
hP3E45/T2d4WDkNzmzeRtmuR08o+oyrtXitY16iE3LXKq/Yi2CwOx0vA/HDCAdyb
PZyoLwOA2zXv0P9tn2K6RVn4Dy6qJ21IxtGq1qAmYkT+4xl2kbSph3QVsTxKG2uT
3NCadUpGNHVhnh64ZWQjfp6GQC/YarpC4aUS/kPWVTcgYjeuZOMLRBOrtGydSdxt
3nFikaoOctEVLvviyamFJORavtxepb4Lh4VruQvzw5xJII1jN67xHEBB1ky+DYr4
3NLETpNOlY4xczBxwkLVzxowHskXQBZH4hM5dV7T3pq5uaeKwtRv3cLSjQi3Gpsz
I+l3wJYIJX7vS9z/YCrKdAUw3M+pAC8Cr/EQcNU1Hq4V2pZyf6RVo16btzm9n6yL
wjz7O2nGPcwmJD51DxqE
=H7DY
-----END PGP SIGNATURE-----

--nextPart2597279.Dcx8d1QEKD--

