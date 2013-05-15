Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab3EOTm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:42:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab3EOTm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:42:26 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3d6PPGnq1VEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2mWzHaID1lcA:10 a=VwQbUJbxAAAA:8 a=HAXULnWv_17sqyW6Xp4A:9 a=QEXdDO2ut3YA:10 a=iZQiFgd2cr_LY_24ygkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130515193922.094868872@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 May 2013 15:39:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 0/4] tracing: Memleak fix and sparse warning fix ups
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

This includes a fix to a memory leak when adding filters to traces.

Also, Masami Hiramatsu fixed up some minor bugs that were discovered
by sparse.

Please pull the latest trace-fixes-v3.10-rc1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.10-rc1

Head SHA1: b62fdd97fcae17e483b005bafd13fadbd9840672
Tag SHA1: 6edfe0df5694052bc42faabe98bfe031eab3a41f


Masami Hiramatsu (3):
      tracing/kprobes: Use rcu_dereference_raw for tp->files
      tracing/kprobes: Fix a sparse warning for incorrect type in assignment
      tracing/kprobes: Make print_*probe_event static

Steven Rostedt (Red Hat) (1):
      tracing: Fix leaks of filter preds

----
 kernel/trace/trace_events_filter.c |    4 +++
 kernel/trace/trace_kprobe.c        |   53 +++++++++++++++++++++++++++-----=
----
 2 files changed, 44 insertions(+), 13 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRk+UbAAoJEOdOSU1xswtMXLAH/RjLzbytSQ7iSXQPBMMvrJSL
oBtoGk2lDFrw3aTu55TBM/DMgqonfoGn4XGA44n/RMjpqbiwYP07ggduN5Zm/Kei
7WSdqWEQTec1n45QElE5J9+lPKeuVOq4dfnThPMDy01mZALWZ3tiGByGstCWq6cO
PQMQMmNeUXOul7DHbRMfmH4zJCRRHltXpdDBXeDEjAunl7Cx+mG+ujbjFRqmEjrA
aR21dwIt0cjdFC34z0nBQj8uM8YK1s9AcYW0m2mPJXqM9COHNT4Q+m8asDmGksYV
8tpu4f9z+T2lccIN98I7AxzlbpzPeEp4PnzPQgPbm5U5YeUCOu9UVLSpsDi6Ujs=
=ljFc
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
