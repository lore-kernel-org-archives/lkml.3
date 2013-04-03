Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779Ab3DCDEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:04:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15119 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761732Ab3DCDEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:04:07 -0400
X-AuditID: cbfee690-b7f656d0000007e3-71-515b9c255683
Message-id: <1364958193.4353.4.camel@kjgkr>
Subject: Re: [PATCH] To add NULL pointer check
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>
Date: Wed, 03 Apr 2013 12:03:13 +0900
In-reply-to: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz>
References: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-UvUkb36I32Rq6rhPKFed"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zfV3VOdGBBje32Vjs2XuSxeLyrjls
	FlevfGe2mHLyB5sDi8f7fVfZPD5vkgtgiuKySUnNySxLLdK3S+DK6FveyVTwRqxiwYbQBsY/
	wl2MnBwSAiYSq99MY4GwxSQu3FvPBmILCSxjlNj0SRWmZu+xu0A1XEDx6YwSU09dYoNwXjNK
	TP55AKybV0BbYt/PGWC2sICexJvlO9m7GDk42IDim/cbQAxVlHi7/y4riC0iICdxdetusHJm
	gTSJPa33wWwWAVWJnz/b2EFsTgFbibape1ggem0kliy9zAxi8wuISpxs/cQI0Vslsf7WPCaI
	Q5Ukdrd3skOcIyjxY/I9sKMlBD6yS1yfN40dYoGAxLfJh1hAbpMQkJXYdIAZoldS4uCKGywT
	GMVnIRk7C8koiLimROv23+wQtrbEsoWvmSFsW4l1695D1dhIbLq6gBHClpfY/nYO8wJG9lWM
	oqkFyQXFSelFJnrFibnFpXnpesn5uZsYIfE6YQfjvQPWhxirgE6cyCwlmpwPjPe8knhDYzMj
	C1MTU2Mjc0szqggrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamC06uLZe/yYgM93
	xyDnXzZLT571uxUmds1HWcFmicnCu6f287Wo+it9mrps2r5dthX2qos5jHaLLL6VkZR/Lur+
	ngStpdy8RpP+9E0OV63MO6156NQJruKgX+KPlq76lBWSzMM722druvvZfPvZzAZH5v1hitym
	/fvRdd6bZZyvVe78K2h5evy7EktxRqKhFnNRcSIAa7ScgAQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsVy+t9jQV3VOdGBBgt+mlns2XuSxeLyrjls
	FlevfGe2mHLyB5sDi8f7fVfZPD5vkgtgimpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wB2qSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxjzOhb3slU8EasYsGG0AbGP8JdjJwcEgImEnuP3WWBsMUkLtxbz9bFyMUhJDCdUWLq
	qUtQzmtGick/D4BV8QpoS+z7OQPMFhbQk3izfCd7FyMHBxtQfPN+A5CwkICixNv9d1lBbBEB
	OYmrW3eDlTMLpEnsab0PZrMIqEr8/NnGDmJzCthKtE3dwwLRayOxZOllZhCbX0BU4mTrJ0aI
	3iqJ9bfmMUEcqiSxu72THeIcQYkfk++xTGAUnIWkbBaSFERcU6J1+292CFtbYtnC18wQtq3E
	unXvoWpsJDZdXcAIYctLbH87h3kBI/sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOB08Exq
	B+PKBotDjAIcjEo8vCe+RAUKsSaWFVfmHmJUAZrzaMPqC4xSLHn5ealKIrynw6IDhXhTEiur
	Uovy44tKc1KLDzFOZAQGx0RmKdHkfGASyyuJNzQ2MTOyNDKzMDIxN6elsJI474FW60AhgfTE
	ktTs1NSC1CKYo5g4OKUaGDnTIkV7VHcHmVTlr/+e/P/c387NaiLHryke6fOaylM69bmm/1Ib
	cROhHcc69SMmLL9Ss1CzcPOfO+wlhktDFi5Yf0nLKiSvTmjxcaXAqA+HLxWvez7Xo1Ljd27x
	1sKSsAOZSadnmC3gsPkSFi4T+D/Pb0lo/4re+wdav+3vFopNNXdbN/2PpBJLcUaioRZzUXEi
	AAxXjiSGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UvUkb36I32Rq6rhPKFed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
Thank you for your contribution.

As I consider the null pointer check, generic_writepages() originally
does so.
Therefore, I think f2fs_write_data_pages() is better to handle this.
Please review the modified patch.=20
Thanks,

---
=46rom d3c811a51c7062fb1b66bec910ed346447c02032 Mon Sep 17 00:00:00 2001
From: P J P <ppandit@redhat.com>
Date: Wed, 3 Apr 2013 11:38:00 +0900
Subject: [PATCH] f2fs: add NULL pointer check
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

Commit - fa9150a84c - replaces a call to generic_writepages() in
f2fs_write_data_pages() with write_cache_pages(), with a function
pointer
argument pointing to routine: __f2fs_writepage.

  ->
https://git.kernel.org/linus/fa9150a84ca333f68127097c4fa1eda4b3913a22

  This patch adds a NULL pointer check in f2fs_write_data_pages() to
avoid
  a possible NULL pointer dereference, in case if -
mapping->a_ops->writepage -
  is NULL.

Signed-off-by: P J P <ppandit@redhat.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 47a2d7c..cf9ff5f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -559,6 +559,10 @@ static int f2fs_write_data_pages(struct
address_space *mapping,
 	int ret;
 	long excess_nrtw =3D 0, desired_nrtw;
=20
+	/* deal with chardevs and other special file */
+	if (!mapping->a_ops->writepage)
+		return 0;
+
 	if (wbc->nr_to_write < MAX_DESIRED_PAGES_WP) {
 		desired_nrtw =3D MAX_DESIRED_PAGES_WP;
 		excess_nrtw =3D desired_nrtw - wbc->nr_to_write;
--=20
1.8.1.3.566.gaa39828



--=20
Jaegeuk Kim
Samsung

--=-UvUkb36I32Rq6rhPKFed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRW5vxAAoJEEAUqH6CSFDSy6UP/iUm0OlWK0nDNnKQcX1syJbH
ki+Nb1uy9+XzNcXqCQ4GxH4SRqpJwGmOfYMko8GKdEYhmheUoKdWlmLMOX9oE3bO
AvGA7X9146iIqAZw1iC2bz5pYldUOrW3/wUn5glnUaxY8LVutq57384vIAtEMLmH
O3K4wra0A6OTyh/VWOkYbAiS9wesmjMye+gSEx2QxcAXeb1gq3noqj0sCj1CF1oq
lzSqT6r+UUdCojdfrmdgtpNkBV2peox5ROytkX+mLyDTUaQ6SUoVs8hRt9cD2+DA
zn3KiEvBE2VtwLr0yZHGU5baHWJXhLicDgeZZTnZp3KqGpfPIDORj1uCO2muM9Jk
pZLSHpLR+jdto5Kc1kZH44kvMYSbLeqx3dbMKfxjpvo9V1yXoVyJSa2kEM3LhHyr
x5Flzs+W7wnKhgF9vM5+bq/3EU6PVO/d5RiNp6MgwqUlAD6H2k+xmBiGWVDfRipm
X0g5mF7r18xFdeog1KD3UQ7LydtxNerNmzOi3iA0162i8ieuHwmtr83j2u+5w9w/
qa9pNVFaRGjkw1ZZeSEmWaJZN7je9Rf5/nHk2jBXNadC/QNMddeQBWpNjBks2AvR
UtSyrnNiCL/HkDI69s6uX6Ilh5lf0jHGLqpu6q7Ebt4NZ0W9OrqCFwaTeW8iGd8U
OIuIkMncuo7Q3dPAm84g
=6kVW
-----END PGP SIGNATURE-----

--=-UvUkb36I32Rq6rhPKFed--

