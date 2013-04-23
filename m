Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3DWKkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:40:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53922 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3DWKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:40:41 -0400
X-AuditID: cbfee68f-b7feb6d000003f6c-f4-517665282dca
Message-id: <1366713583.31792.13.camel@kjgkr>
Subject: Re: [PATCH v4 4/7] f2fs: add tracepoints for GC threads
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 23 Apr 2013 19:39:43 +0900
In-reply-to: <1366388958-18915-1-git-send-email-linkinjeon@gmail.com>
References: <1366388958-18915-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-RIbw+vlERuNPlQihbMfo"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zka5GalmgwftTIhbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGj4nLmAuealVM2PacuYHxoXIXIyeHhICJxJEZu9khbDGJC/fWs3Ux
	cnEICSxjlHh8fD8rTNHbjTCJ6YwSy5dPYIRwXjNKvNo6mxmkildAV+Jn828WEFtYwEHi3YFr
	QDYHB5uAtsTm/QYgYSEBRYm3+++ygoRFBNQkJjxLBRnDLHCWUeLfvCZGkDiLgKrE6qlgezkF
	XCVm9j5nh2h1kVh2qRPM5hcQlTjZ+okRxGYWqJI4efQPI8SdShK72yFqeAUEJX5MvscCMl9C
	YC6HxKpvv8CGsggISHybfAjsNAkBWYlNB5gheiUlDq64wTKBUXwWkrGzkIyCiGtKtG7/zQ5h
	a0ssW/iaGcK2lVi37j1UjY3EpqsLGCFseYntb+cwL2BkX8UomlqQXFCclF5krFecmFtcmpeu
	l5yfu4kREun9OxjvHrA+xFgFdOJEZinR5HxgosgriTc0NjOyMDUxNTYytzSjirCSOK9ai3Wg
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaEU5eKHnlsaLrS4HX0J0+IJK+Vyb+Y/IKFQhE7
	/1lNTcoNNclcUVlt5PBnTnvtRKOu+4clvm+4X3r/1+8arZ+SG96dXHkkpmxOVNWNH3mqpV4n
	LAP35hhxNqmI3+cXLG0PTEtd0swdu9rzpgDzXL0/syW2e2yT3Oi1LGFScGmDWv5UKXdmMSWW
	4oxEQy3mouJEALihYyIhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xoK5GalmgwfdV/BbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjB8TlzEXPNWqmLDtOXMD40Pl
	LkZODgkBE4m3G9ezQdhiEhfugdhcHEIC0xklli+fwAjhvGaUeLV1NjNIFa+ArsTP5t8sILaw
	gIPEuwPXgGwODjYBbYnN+w1AwkICihJv999lBQmLCKhJTHiWCjKGWeAso8S/eU2MIHEWAVWJ
	1VNZQco5BVwlZvY+Z4dodZFYdqkTzOYXEJU42fqJEcRmFqiSOHn0DyPEnUoSu9shangFBCV+
	TL7HMoFRcBaSsllIUhBxTYnW7b/ZIWxtiWULXzND2LYS69a9h6qxkdh0dQEjhC0vsf3tHOYF
	jOyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLTyDPpHYyrGiwOMQpwMCrx8Aq4lwYKsSaW
	FVfmHmJUAZrzaMPqC4xSLHn5ealKIrzXpMoChXhTEiurUovy44tKc1KLDzFOZASGxkRmKdHk
	fGDyyyuJNzQ2MTOyNDKzMDIxN6elsJI478FW60AhgfTEktTs1NSC1CKYo5g4OKUaGNfoaKor
	2sebRM9vY5BxlPr3cOJ7ruPXqlfonz6voPtn7539Yj9TdK6fTw6P/MLA2Bi+UGPpp8zq/v33
	lEL2xmxvVl9aoq8XEqkVIT83IydN89OHvYvUT/nuP/9ZtfbnM87wW5Km+w9m9OT2fy855337
	j/DPiu2lU3/bPX676F9AOPMEtqTK50osxRmJhlrMRcWJAC4rkByiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RIbw+vlERuNPlQihbMfo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom 8e46b3ed11b750a740fec0a313ad9118059fc37b Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Tue, 23 Apr 2013 16:42:53 +0900
Subject: [PATCH 4/7] f2fs: add tracepoints for GC threads
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

Add tracepoints for tracing the garbage collector
threads in f2fs with status of collection & type.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[Jaegeuk: modify slightly to show information]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/gc.c                |  5 +++
 include/trace/events/f2fs.h | 75
+++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 37b05e1..1ca3324 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -23,6 +23,7 @@
 #include "node.h"
 #include "segment.h"
 #include "gc.h"
+#include <trace/events/f2fs.h>
=20
 static struct kmem_cache *winode_slab;
=20
@@ -301,6 +302,10 @@ got_it:
 				set_bit(secno, dirty_i->victim_secmap);
 		}
 		*result =3D (p.min_segno / p.ofs_unit) * p.ofs_unit;
+
+		trace_f2fs_get_victim(sbi->sb, type, gc_type, &p,
+				sbi->cur_victim_sec,
+				prefree_segments(sbi), free_segments(sbi));
 	}
 	mutex_unlock(&dirty_i->seglist_lock);
=20
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 924e69a..6f7cf7a 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -18,6 +18,33 @@
 		{ WRITE_FLUSH,	"WRITE_FLUSH" },			\
 		{ WRITE_FUA, 	"WRITE_FUA" })
=20
+#define show_data_type(type)						\
+	__print_symbolic(type,						\
+		{ CURSEG_HOT_DATA, 	"Hot DATA" },			\
+		{ CURSEG_WARM_DATA, 	"Warm DATA" },			\
+		{ CURSEG_COLD_DATA, 	"Cold DATA" },			\
+		{ CURSEG_HOT_NODE, 	"Hot NODE" },			\
+		{ CURSEG_WARM_NODE, 	"Warm NODE" },			\
+		{ CURSEG_COLD_NODE, 	"Cold NODE" },			\
+		{ NO_CHECK_TYPE, 	"No TYPE" })
+
+#define show_gc_type(type)						\
+	__print_symbolic(type,						\
+		{ FG_GC,	"Foreground GC" },			\
+		{ BG_GC,	"Background GC" })
+
+#define show_alloc_mode(type)						\
+	__print_symbolic(type,						\
+		{ LFS,	"LFS-mode" },					\
+		{ SSR,	"SSR-mode" })
+
+#define show_victim_policy(type)					\
+	__print_symbolic(type,						\
+		{ GC_GREEDY,	"Greedy" },				\
+		{ GC_CB,	"Cost-Benefit" })
+
+struct victim_sel_policy;
+
 DECLARE_EVENT_CLASS(f2fs__inode,
=20
 	TP_PROTO(struct inode *inode),
@@ -439,6 +466,54 @@ TRACE_EVENT(f2fs_get_data_block,
 		__entry->ret)
 );
=20
+TRACE_EVENT(f2fs_get_victim,
+
+	TP_PROTO(struct super_block *sb, int type, int gc_type,
+			struct victim_sel_policy *p, unsigned int pre_victim,
+			unsigned int prefree, unsigned int free),
+
+	TP_ARGS(sb, type, gc_type, p, pre_victim, prefree, free),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	type)
+		__field(int,	gc_type)
+		__field(int,	alloc_mode)
+		__field(int,	gc_mode)
+		__field(unsigned int,	victim)
+		__field(unsigned int,	ofs_unit)
+		__field(unsigned int,	pre_victim)
+		__field(unsigned int,	prefree)
+		__field(unsigned int,	free)
+	),
+
+	TP_fast_assign(
+		__entry->dev		=3D sb->s_dev;
+		__entry->type		=3D type;
+		__entry->gc_type	=3D gc_type;
+		__entry->alloc_mode	=3D p->alloc_mode;
+		__entry->gc_mode	=3D p->gc_mode;
+		__entry->victim		=3D p->min_segno;
+		__entry->ofs_unit	=3D p->ofs_unit;
+		__entry->pre_victim	=3D pre_victim;
+		__entry->prefree	=3D prefree;
+		__entry->free		=3D free;
+	),
+
+	TP_printk("dev =3D (%d,%d), type =3D %s, policy =3D (%s, %s, %s), victim =
=3D %
u "
+		"ofs_unit =3D %u, pre_victim_secno =3D %d, prefree =3D %u, free =3D %u",
+		show_dev(__entry),
+		show_data_type(__entry->type),
+		show_gc_type(__entry->gc_type),
+		show_alloc_mode(__entry->alloc_mode),
+		show_victim_policy(__entry->gc_mode),
+		__entry->victim,
+		__entry->ofs_unit,
+		(int)__entry->pre_victim,
+		__entry->prefree,
+		__entry->free)
+);
+
 #endif /* _TRACE_F2FS_H */
=20
  /* This part must be outside protection */
--=20
1.8.1.3.566.gaa39828



--=20
Jaegeuk Kim
Samsung

--=-RIbw+vlERuNPlQihbMfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdmTvAAoJEEAUqH6CSFDSSSMP+wecjF+4COAUvkk/TzPwPj9g
mZEQKVhSBpWaRDVevYequJo1G5bf7YB06//MVMKYj6JGr7JRw57BnXFGbcV6w6aT
Xafbyf8Ust9Qca6pCnwE37Mz1ezx8OH0Ob1t/91RhzEtOJ81Pu9rXOkEHiWXdXqO
ueYqdy3p2kXuiesY6OwxrLkub7oivWNDgmCYsOJv5UrDBw5cFhLHGVChvIbNH6yd
06yIE1e8O/HzoqHPwdy08XF1KA6Y6peucBps8U3H7hrOY+LjJmnguuF/aeK0b7Pd
Rq4eO0wU7rGRj3aO52aMYd1UvzlFijlEe7McVQ9aB05zQzhd1by0nzXTzYtFvnp4
6PS+EL2/640kE/iet115ZDHQWMqal77Vkl/V4ziwtkff63j03ROGPlehrDLzYd1i
vsbxyyiaaamBX01+Ayj7wTEImtPO+qH2iCfCBgrF+v0m7j3NnrzTmq/gr0sHx8uZ
anZtMQAdycsGNvcaty8ANTOzwyfhs4B1Q05idJks98o2Qc6AZIqq7BYcdiaPfldb
pZ11yTQDdtnGCzbcsogOf6ZQvu3ZyXOFf03PMa5giSE44Pq5GVPlxqMxsn4/7yyK
kVm4z87/P498MIGFpmlJXybqMQ12qX1wO2kUzJ2Ku/AK1vs9DazDCPvJaQDGhOrr
TpKWQlKhmkWe3FYWzVG2
=6e1s
-----END PGP SIGNATURE-----

--=-RIbw+vlERuNPlQihbMfo--

