Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3CPDcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3CPDbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:45 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=MFx9odF8fFEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=05dgs6v8ndYA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=LkGhqShrmYb3ozcDzywA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=myY8D2aGPQm3gtCG_cEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316033142.994886339@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 5/9] tracing: Convert trace_destroy_fields() to static
References: <20130316032412.416651612@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Convert-trace_destroy_fields-to-static.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

trace_destroy_fields() is not used outside of the file. It can be
a static function.

Link: http://lkml.kernel.org/r/513D842A.2000907@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ba523d7..a71cdc3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -158,7 +158,7 @@ static int trace_define_common_fields(void)
 	return ret;
 }
=20
-void trace_destroy_fields(struct ftrace_event_call *call)
+static void trace_destroy_fields(struct ftrace_event_call *call)
 {
 	struct ftrace_event_field *field, *next;
 	struct list_head *head;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+efAAoJEOdOSU1xswtMJkcH/jk51vWXEEjiQHlpMJUV3w4i
EEWz42UfzLv/AV3mDQIXnvxI4fMYQNgeDFCVBwFgBFzice3FHvQqMDEs0PkNxAxz
NqCX2v540tkndZX3kipLy9R7d4M7fd0/GbEw8jxTK7zZvrcNzhIGYZEBaOQcsK1h
hM9H8Z+sHH001YX26aDrZe8mKr21YDqRMMgzJD3sa53B2ZVqOADMuP4DE7xb9ezb
Zi6JECkdY9Eb559QT/1NmDwy171y+ViXey2fh5XMQIMbquZcLaob6aa/AHwVgHAU
TGUyat+3nCtNvonXHasN8zB/PU+7aEzTfx7zWX1YaUSdS4vPJGPRDSCti+lZM70=
=H70y
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
