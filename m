Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3DYLBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:01:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53810 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3DYLBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:01:51 -0400
X-AuditID: cbfee68f-b7f066d000003683-de-51790d1cbad9
Message-id: <1366887650.31792.26.camel@kjgkr>
Subject: Re: [PATCH v2] f2fs: avoid frequent background GC
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Thu, 25 Apr 2013 20:00:50 +0900
In-reply-to: <CAKYAXd-7dkROw0wGQU-9yth90ObRm5b9Vr8aB_zMd4HX2=+ZrQ@mail.gmail.com>
References: <1366857842-17240-1-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd-7dkROw0wGQU-9yth90ObRm5b9Vr8aB_zMd4HX2=+ZrQ@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-5jZxejkueWdBfxEiCUsW"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zfV0Z3spAg3/3RS2u373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfH56z72gi1yFddO
	uzUwtkp1MXJySAiYSJzq+M8EYYtJXLi3nq2LkYtDSGAZo0RH3woWmKIt1+cyQSQWMUr8XNgB
	5bxmlDjXcYARpIpXQFfidudidhBbWMBK4vX5KUBFHBxsAtoSm/cbgISFBBQl3u6/ywoSFhFQ
	k5jwLBUkzCyQKTHn9WSwMIuAqsTJNzUgJqdAsMSK80IQjX2MEku2aIPY/AKiEidbPzFCdFZJ
	NO/+wAxxpZLE7vZOdohbBCV+TL7HAnKkhMBPdolHX1eD/cgiICDxbfIhFpD5EgKyEpsOQPVK
	ShxccYNlAqP4LCRjZyEZBRHXlGjd/psdwtaWWLbwNTOEbSuxbt17qBobiU1XFzBC2PIS29/O
	YV7AyL6KUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyRm+3cw3j1gfYixCujEicxSosn5wJjP
	K4k3NDYzsjA1MTU2Mrc0o4qwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG8R3v
	TG36m31Prf+xcE7ctrzd889/4p906EH35UW7jWp8F+xU+c1lFTQhV1Hy9We/hz9ZVs6MenmQ
	PUjcN+OaEne0kveOuC0tC73Zvx4wn6XpZ3LcMPFZzk9pNgGekNnHBZl/rzB/U7L6JVvzFJtZ
	L3urDa4X90/8oce3zHCm6LzDLoG/ns+qUWIpzkg01GIuKk4EAPbclb8GAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsVy+t9jAV0Z3spAg9vfBSyu373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx+es+9oItchXXTrs1MLZKdTFyckgImEhsuT6XCcIWk7hwbz1bFyMXh5DA
	IkaJnws7mCCc14wS5zoOMIJU8QroStzuXMwOYgsLWEm8Pj8FqIiDg01AW2LzfgOQsJCAosTb
	/XdZQcIiAmoSE56lgoSZBTIl5ryeDBZmEVCVOPmmBsTkFAiWWHFeCKKxj1FiyRZtEJtfQFTi
	ZOsnRojOKonm3R+YIa5Uktjd3skOcYugxI/J91gmMArOQlI2C0kKIq4p0br9NzuErS2xbOFr
	ZgjbVmLduvdQNTYSm64uYISw5SW2v53DvICRfRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZG
	cEJ4Jr2DcVWDxSFGAQ5GJR5egVflgUKsiWXFlbmHGFWA5jzasPoCoxRLXn5eqpIIL/OPikAh
	3pTEyqrUovz4otKc1OJDjBMZgYExkVlKNDkfmMbySuINjU3MjCyNzCyMTMzNaSmsJM57sNU6
	UEggPbEkNTs1tSC1COYoJg5OqQZGDiZr7XzbrwdXsV1eVVmQvjzvImssDyP75bp3LbfnhLd/
	8D2XU1aUOT/2aWb25slq7Sy3XbRWxn3JP/k+lunk43X/q6K+1ThHcn01jNC0nt4abCqR/0pv
	u97XDd+/q6/a8pBLQtBgvte5U/xflVMVvTQX5MSuOT5zZ6/s6Wk3mJz2x67pDAxTYinOSDTU
	Yi4qTgQAePF1HocDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5jZxejkueWdBfxEiCUsW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Namjae,

Agreed. How about this?

Chang log from v1:
 o change timings - min 30s, max 60s, nogc 5 min
 o remove nonreachable routine
 o consider NOGC_SLEEP_TIME in increate/decrease_sleep_time

=46rom 806e344624414fcf9fc87f6193265859027d51b5 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Wed, 24 Apr 2013 13:00:14 +0900
Subject: [PATCH] f2fs: avoid frequent background GC
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

If there is no victim segments selected by background GC, let's wait
a little bit longer time to collect dirty segments.
By default, let's give 5 minutes.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/gc.c |  3 ---
 fs/f2fs/gc.h | 12 +++++++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 1ca3324..6ed3263 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -82,9 +82,6 @@ static int gc_thread_func(void *data)
 		/* if return value is not zero, no victim was selected */
 		if (f2fs_gc(sbi))
 			wait_ms =3D GC_THREAD_NOGC_SLEEP_TIME;
-		else if (wait_ms =3D=3D GC_THREAD_NOGC_SLEEP_TIME)
-			wait_ms =3D GC_THREAD_MAX_SLEEP_TIME;
-
 	} while (!kthread_should_stop());
 	return 0;
 }
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 30b2db0..2c6a6bd 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -13,9 +13,9 @@
 						 * whether IO subsystem is idle
 						 * or not
 						 */
-#define GC_THREAD_MIN_SLEEP_TIME	10000 /* milliseconds */
-#define GC_THREAD_MAX_SLEEP_TIME	30000
-#define GC_THREAD_NOGC_SLEEP_TIME	10000
+#define GC_THREAD_MIN_SLEEP_TIME	30000	/* milliseconds */
+#define GC_THREAD_MAX_SLEEP_TIME	60000
+#define GC_THREAD_NOGC_SLEEP_TIME	300000	/* wait 5 min */
 #define LIMIT_INVALID_BLOCK	40 /* percentage over total user space */
 #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
=20
@@ -58,6 +58,9 @@ static inline block_t limit_free_user_blocks(struct
f2fs_sb_info *sbi)
=20
 static inline long increase_sleep_time(long wait)
 {
+	if (wait =3D=3D GC_THREAD_NOGC_SLEEP_TIME)
+		return wait;
+
 	wait +=3D GC_THREAD_MIN_SLEEP_TIME;
 	if (wait > GC_THREAD_MAX_SLEEP_TIME)
 		wait =3D GC_THREAD_MAX_SLEEP_TIME;
@@ -66,6 +69,9 @@ static inline long increase_sleep_time(long wait)
=20
 static inline long decrease_sleep_time(long wait)
 {
+	if (wait =3D=3D GC_THREAD_NOGC_SLEEP_TIME)
+		wait =3D GC_THREAD_MAX_SLEEP_TIME;
+
 	wait -=3D GC_THREAD_MIN_SLEEP_TIME;
 	if (wait <=3D GC_THREAD_MIN_SLEEP_TIME)
 		wait =3D GC_THREAD_MIN_SLEEP_TIME;
--=20
1.8.1.3.566.gaa39828



--=20
Jaegeuk Kim
Samsung

--=-5jZxejkueWdBfxEiCUsW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJReQziAAoJEEAUqH6CSFDSaagP/1FQ/Eu4iNv8Bve8MHUyGH+Z
3l4KztdiLtJ5BVhrc02SqJTvuvSUzxFM73Pf8llyIA/Uvlt3AeatqcPgv+v2dtEM
wIF6er70T4+1cP4dnMI54RtYop4k8eYxff2Q+msui9iUgXQLHTOTVbdZJp3+fGRF
y8cRRIbKVb/IJ7e+wQUsTPovaHhj4M4cMantIQJy4fTObdKQ8meWntBv0xYHyPC9
3GacGQmWuL15L1NWQAP9pT6OBh8ql6nTQS6qpJXhddk45xR0St4R045RuUzzLOoU
8NoGyGtIsxTEYcDx4iPAGtQ6d4RQTpX4cBWBX0sSiSL7nlS9a3svHwBTsENFEQty
kLAvfA4V0K562mHJFdYCE3GD75+PPgpTwxLH68iYtU5oNUnmv2XJheeRln5Di94W
V8VFpK89thYW59D5aY1mJTmdkc3sj/7rRIFkPQFhzpctEA8QXD5Epz/ilrVw4Js0
13BNUnZkJWk9BJXE942KgdvgNLGDaTKsh7yYXXxTy60u9TQEEDl6kV1jNpcjrB/6
Fr2iSb1fIv149dbUyZHrgbUMLCh69a/72ubqiCMPCc6zxz2hAlGN7X1iAI/O7YHP
EUIol8xJHZstk4wY6eB6ql+KUncqED86EdGQpz9dCAKrOV+lceH0/SkI0U/MQKow
8X/4T4Go1GpuOa3wHeKY
=RvOE
-----END PGP SIGNATURE-----

--=-5jZxejkueWdBfxEiCUsW--

