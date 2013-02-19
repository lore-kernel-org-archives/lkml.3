Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab3BSEQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:16:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab3BSEQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:16:28 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=FbgsWPMclSkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xf8W2v3WoJsA:10 a=VwQbUJbxAAAA:8 a=NqKv5SmU2mmw4N_2_wIA:9 a=QEXdDO2ut3YA:10 a=Yslf6USXtZ89GZZ3gB0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219041554.221170392@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 18 Feb 2013 23:15:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: minor fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 8c189ea64eea01ca20d102ddb74d6936dd16c579


Steven Rostedt (1):
      tracing/syscalls: Allow archs to ignore tracing compat syscalls

Steven Rostedt (Red Hat) (1):
      ftrace: Call ftrace cleanup module notifier after all other notifiers

----
 arch/x86/include/asm/ftrace.h      |   24 +++++++++++++++++++
 arch/x86/include/asm/thread_info.h |    1 -
 kernel/trace/ftrace.c              |   46 +++++++++++++++++++++++++-------=
----
 kernel/trace/trace_syscalls.c      |   43 +++++++++++++++++++++++++++++----
 4 files changed, 94 insertions(+), 20 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRIvyXAAoJEOdOSU1xswtMgCoIALDqHP/sVAtooUHsyxAuYqJm
LfYKUDKZ8XibloOVUsq6etY/aYZfz2SqoOFxn2Nz0oyYHhImXEd6xZb6IfmyEP7W
HjhqgCVcouiFTDBSsy/T2GPjGOhRhs+PKrA5dThaxqjQXytJhGhH4co07yBR/5sB
tb2O+v2m086lJo5Muzoj6q4m0VaRHXFvxF0R9lMb1DNimCDmeoslBi5c051BABkY
9YHHiOcEhQ+ZzQLELup3Ii/wIslxseOt1eyjCWkGpN1fbPcqrB1Q8oMSokRbksEt
UQRQ262pPtRkAONffdsphzAQ2BU0ZAvk1gEoOdL0NIT5/w9bc0Gl5FvVimjTxwg=
=dkPk
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
