Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3DWKim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:38:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26224 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3DWKik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:38:40 -0400
X-AuditID: cbfee68d-b7feb6d000007be8-66-517664ae4cca
Message-id: <1366713461.31792.9.camel@kjgkr>
Subject: Re: [PATCH v4 0/7] f2fs: Add tracepoints support in f2fs filesystem
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Date: Tue, 23 Apr 2013 19:37:41 +0900
In-reply-to: <1366388891-18778-1-git-send-email-linkinjeon@gmail.com>
References: <1366388891-18778-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-s6jXqheR4k1b6JtLluht"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zse66lLJAgzuz5S2u373FbHFpkbvF
	nr0nWSwu75rDZvFjer3Fvo4HTA5sHjtn3WX3aNl3i91j94LPTB59W1YxenzeJBfAGsVlk5Ka
	k1mWWqRvl8CV8e/rJsaCQ+IVm888ZGxg3CbSxcjJISFgIvF3zTcmCFtM4sK99WxdjFwcQgLL
	GCWm/73NDFP07ewZVojEIkaJ7oVNUFWvGSXuP70EVMXBwSugI/FkRjVIg7CAj8TM0yuZQMJs
	AtoSm/cbgISFBBQl3u6/ywoSFhFQk5jwLBUkzCywnFHizhF9EJtFQFVi7v21LCA2p4CrxO/f
	v9khWl0k1m1ZwQpi8wuISpxs/cQI0Vsl8fz6f6j7lSR2t3eC1fMKCEr8mHyPBeRKCYGZHBLb
	OiewQywQkPg2+RALyA0SArISmw5AvSgpcXDFDZYJjOKzkIydhWQURFxTonX7b3YIW1ti2cLX
	zBC2rcS6de+hamwkNl1dwAhhy0tsfzuHeQEj+ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2M
	kOju3cF4+4D1IcYqoBMnMkuJJucDk0NeSbyhsZmRhamJqbGRuaUZVYSVxHnVWqwDhQTSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTB6LFtp/GGu1T/+kBsSipWxhvtTNPiYmoP3hU5S5HXcOTFs
	4W0fxeV3qqM0vjrteiJqqNchtWFvjuQX2X1P1f3ZL2ye7DwlePOVdef6Lr7P9s9Uv9Z3boHL
	VrWoA/ETHl23+eSldPFN7zmF6Ys94tR1Be/n7/71QHDpHANe/n9dUrM98582b6xXYinOSDTU
	Yi4qTgQAYwEHvRsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42I5/e+xgO66lLJAgz27pCyu373FbHFpkbvF
	nr0nWSwu75rDZvFjer3Fvo4HTA5sHjtn3WX3aNl3i91j94LPTB59W1YxenzeJBfAGtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePf102MBYfEKzafecjYwLhNpIuRk0NC
	wETi29kzrBC2mMSFe+vZuhi5OIQEFjFKdC9sgnJeM0rcf3qJuYuRg4NXQEfiyYxqkAZhAR+J
	madXMoGE2QS0JTbvNwAJCwkoSrzdf5cVJCwioCYx4VkqSJhZYDmjxJ0j+iA2i4CqxNz7a1lA
	bE4BV4nfv3+zQ7S6SKzbsgLsHH4BUYmTrZ8YIXqrJJ5f/88EcaaSxO72TrB6XgFBiR+T77FM
	YBSchaRsFpIURFxTonX7b3YIW1ti2cLXzBC2rcS6de+hamwkNl1dwAhhy0tsfzuHeQEj+ypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4NTxTHoH46oGi0OMAhyMSjy8Au6lgUKsiWXFlbmH
	GFWA5jzasPoCoxRLXn5eqpII7zWpskAh3pTEyqrUovz4otKc1OJDjBMZgcExkVlKNDkfmPDy
	SuINjU3MjCyNzCyMTMzNaSmsJM57sNU6UEggPbEkNTs1tSC1COYoJg5OqQbGVZ+69tR+bfCW
	OjLt1/TbOW3xBz5N6FJzM5m5yGSRc9AXqWc+c450LnWfL5IoPsOTRa7o0MelXr9O73P0WRv3
	rMg7quzxJmV3j19PHv6YEHZOI9rCavNtyfpHoVNZL6p4/zjAI9gw60HWswnzT7zfdUfV2/F6
	7mSlvEhhr8RYE6OFJ31fqFn4KbEUZyQaajEXFScCADyfqjecAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s6jXqheR4k1b6JtLluht
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Namjae.

Still I found several inconsistent codes and flaws of information across
the whole patches.
I've finished changing them, so please review the subsequent patches.
Thanks,

2013-04-20 (=ED=86=A0), 01:28 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> Add tracepoints in f2fs filesystem for tracing the filesystem
> operations for information/debugging purpose if needed. All the
> tracepoints are clubbed with respect to functionalities.
>=20
> Change Log:
> v4: Modified the tracepoints as per the review comments of
> Jaegeuk Kim. Following tracepoints are added newly:
>=20
> trace_f2fs_truncate_blocks_enter
> trace_f2fs_truncate_blocks_exit
> trace_f2fs_truncate_inode_blocks_enter=20
> trace_f2fs_truncate_inode_blocks_exit
> trace_f2fs_truncate_node
> trace_f2fs_submit_write_page
> trace_f2fs_do_submit_bio
> trace_f2fs_write_checkpoint
>=20
> While some of the tracepoints are modified to add new=20
> parameters.
>=20
> v3: Introduced TRACE_EVENT_CONDITION() macro for checking the
> condition page->mapping inside the trace point function call as
> per Steve's review comment for the patch
>=20
> v2: Added DECLARE_EVENT_CLASS() macro for combining the similar
> type of trace function calls which has same type of arguments.
>=20
> v1: Introduced the tracepoint functions in f2fs filesystem.
>=20
> Namjae Jeon (7):
>   f2fs: add tracepoints for sync & Inode operations
>   f2fs: add tracepoints for truncate operation
>   f2fs: add tracepoint for tracing the page i/o operations
>   f2fs: add tracepoints for GC threads
>   f2fs: add tracepoints to debug the block allocation & fallocate
>   f2fs: add tracepoints for write page operations
>   f2fs: add tracepoints to debug checkpoint request

--=20
Jaegeuk Kim
Samsung

--=-s6jXqheR4k1b6JtLluht
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdmR1AAoJEEAUqH6CSFDSNnMP/3Rqe07ocHbuHzAFVmePmZPA
knXQr6ZpUotmZLMFamM/4q5CBGVzUdmX+4NjB8rDvpKBx+KBs6lmZu7k/1XEi5p0
7LjV1ybzwTRoAUIMwQ0+6kp1sYYWUXFyohVctwfYszi6hIxPaOu9xcVVvVZZ9P4N
jYgtQil0no0WMw6x9UhMyHoTrHNos+ivLMcsGWv1+0xUxFMH+t+mexgnI7Ds6aWi
AZFe8FBKG66gu3Z9JKAZnNQDZDw7i95F/dJkkMLg6k8dqy9uEQaQmAwWM6GjW51Q
dcGAc+Gdl0+ERdP/QII6+HvcmbpNkqNmBsVi0HMH8qEoWCe7LvzA4xd8hUAT/133
8VE/Nv4IeYZ/XS1YtR9HeWrTFeQe5ctqMk+F4DKrUY8lTjZ4wXWvxEvmASVKuuNo
TaX/LhvnKgKoWm6V4zxrs/VtchRLhG5dvRCEc2/a5FZZ9ffKFeX3zAHn2Dbn7HZU
8Dmq1dZox4HEh0SKx4VDidqn3mcpYJcQSiZFwWoJ2XJ1TCtFpbACf5JPCFAJzhX/
icSCw3s1ZWGFp41HUEgesFex9zKDX69bxuwuSIudLeq3lVuWxh4VFuIvGRbcW4wk
Eh0ZrQemgXHSEV23Z+w/iECFTYpDXndeXeQspuT7Bp9LjxnsK/IyVpEdhKTo3hLd
K1tw9b1oGZV+UhY5aYkR
=yOb/
-----END PGP SIGNATURE-----

--=-s6jXqheR4k1b6JtLluht--

