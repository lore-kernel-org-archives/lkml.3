Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab3BBOUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab3BBOT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:56 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0SBin2RMb2AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AzsjohP8miMA:10 a=UPm3pfgAAAAA:8 a=VwQbUJbxAAAA:8 a=aAIqk_KayHpFf9Mcg1sA:9 a=QEXdDO2ut3YA:10 a=mOio7EKfaG4A:10 a=jeBq3FmKZ4MA:10 a=bZFuWAgVPQHbjpCZi10A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141954.781391475@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 01/11] tracing: Mark tracing_dentry_percpu() static
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Mark-tracing_dentry_percpu-static.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Josh Triplett <josh@joshtriplett.org>

Nothing outside of kernel/trace/trace.c references tracing_dentry_percpu().

Link: http://lkml.kernel.org/r/1353302917-13995-7-git-send-email-josh@josht=
riplett.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d2a6583..ca9b7df 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4506,7 +4506,7 @@ struct dentry *tracing_init_dentry(void)
=20
 static struct dentry *d_percpu;
=20
-struct dentry *tracing_dentry_percpu(void)
+static struct dentry *tracing_dentry_percpu(void)
 {
 	static int once;
 	struct dentry *d_tracer;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCKAAoJEOdOSU1xswtM2wMIALRgbKWZ6nX++FByv57U1Y87
2O7DQNejIQbLa5ycP81WUMmmha6PghZtvvSaIdlv5JaAfTYv0cWkHcnE44wPQuL/
kqAxYI7oJ0HNvtvSOqDe2A284cqEdPjfWTHyB8Qmg6ojHGskpSZ6uRkHn2YlPggp
UOlLiNMKIT9YAbvqVqHZXP1flcy7of34225Advfs3RijVAS1bD6rwxgTGfZaQzwg
P893SzEYgxIzbkA71ICQg9kCTE1yUQgNSxzf0ltYZOyY92Yd6GiDdV+NxeKUMHJ8
0LpXbz5WvPiDUHR0GC6ZODFrra+F4YGrQQSt2lPzTwMfV+gA6QXgFqXuxwtdfI8=
=XrjI
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
