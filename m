Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030589Ab3DSOIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:08:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31779 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519Ab3DSOF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:05:58 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gvvxVf5Z_3oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8orhOPJRcSAA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=5cncIGN1OebQdfLL-GQA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=cjoT54s2AngtlMHad3sA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130419140557.644385030@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Apr 2013 10:04:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 7/7] tracing: Remove obsolete macro guard _TRACE_PROFILE_INIT
References: <20130419140402.730041313@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Remove-obsolete-macro-guard-_TRACE_PROFILE_I.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

The macro _TRACE_PROFILE_INIT was removed a long time ago,
but an "#undef" guard was left behind. Remove it.

Link: http://lkml.kernel.org/r/514684EE.6000805@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 4bda044..19edd7f 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -704,5 +704,3 @@ static inline void perf_test_probe_##call(void)				\
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 #endif /* CONFIG_PERF_EVENTS */
=20
-#undef _TRACE_PROFILE_INIT
-
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRcU9FAAoJEOdOSU1xswtM5foH/1hwhME7684jJXZZ/PQNIFIS
u26RthfDoNJNyjr4uSrNICBnfA568pfKSSDN76C5C38CBhuPMKwtswe4AVAUvR2J
2PROSYjB31heZG3WBHKslTtfUZAI1JtIgvKeVVpk5cZW2JR6eoBiSHQjAbqt/ClM
esKMkNmlnnPQ+C/WcDCphx99w5+rF4+WZbuxTQGiBzKrzEFmRJeYiYZ+w51LBjIO
nrYkwMba3vffshm5si/uHFjPhO7fjP7uMgV+qPdMZJrxDhyLM7p3ZrGHG+Rlqhxg
vI9Z5vZ1xwirPbeNLea7dISKKgZNcmdL6wx1xZlz+cbnMZWxK5NIcwWMg9jgz1U=
=dooA
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
