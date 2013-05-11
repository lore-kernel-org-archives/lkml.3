Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3EKANu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3EKANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:07 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Xal78F3VovUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Ca8VC0l5910A:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=1hp9V8YanbpHuiuc56YA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=dB4HI6iiHBGgba25q6EA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001305.899117648@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Subject: [PATCH 14/18] tracing/kprobes: Use bool for retprobe checker
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-kprobes-Use-bool-for-retprobe-checker.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use bool instead of int for kretprobe checker.

Link: http://lkml.kernel.org/r/20130509054431.30398.38561.stgit@mhiramat-M0=
-7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 6928633..0b7386a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -46,7 +46,7 @@ struct trace_probe {
 	(sizeof(struct probe_arg) * (n)))
=20
=20
-static __kprobes int trace_probe_is_return(struct trace_probe *tp)
+static __kprobes bool trace_probe_is_return(struct trace_probe *tp)
 {
 	return tp->rp.handler !=3D NULL;
 }
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0RAAoJEOdOSU1xswtMXTQH/jlyVmr2E8V+zYKMuk9F7XBm
h6Dt4T9WJeLz/4xLY5rhEy7yuveTQQOzcoz+JJazQurqUHTPduHQpfKcIQSvFLim
jiMtGK83mqy7R3LrBTu8Zioyrj3SL0LXx6UH4tjlemPGnPdgEE+PfWthAKTe8v5W
OuF3ZU5yV5gpkaZR6sjBvBH0dPrq4+rg8ByC7BxsAYMyf4duCYI3LVKFiYcEYuN+
SAy4imi5A9w3wF4Mggs0r30Z7YvuzbTm/ZYgYH7XXh/luXcxmUByAndl58AZuE82
bpF7nueCdBBQvPcP6jwVNgclMDRw2NgxCDbPjFVYljK5cqikcNu6XjZVnQ05hYg=
=hYce
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
