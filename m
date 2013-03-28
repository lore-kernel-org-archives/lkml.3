Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3C1Mwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:52:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3C1Mwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:52:34 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=A0Xx6ySGHMwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=h-k7l3VsYcsA:10 a=VwQbUJbxAAAA:8 a=TExKkRM8WJb7dC8g9ioA:9 a=QEXdDO2ut3YA:10 a=Du4RQqgcx0bw7taqpBQA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130328125214.132479321@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Mar 2013 08:52:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL][3.9] tracing/perf: Various fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: cc1e2627b179f0fccb3285fe565e893b570558b8


Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Steven Rostedt (Red Hat) (2):
      tracing: Fix race with update_max_tr_single and changing tracers
      ftrace: Do not call stub functions in control loop

----
 include/linux/ftrace.h |    2 ++
 kernel/trace/ftrace.c  |   13 +++++--------
 kernel/trace/trace.c   |    5 ++++-
 3 files changed, 11 insertions(+), 9 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRVD0NAAoJEOdOSU1xswtMqyAH/3q44CiXaLrkFX4/QWqiBUGY
LDuPj8jr6fPjIcWd5cZuEwVpB8ljTm+2CmycZrCibAlid24bAMSNoaCqns2E7/Lt
zSLuBHkvUYnzOgF9Ryw0uLt5i6oA7PZf/FKOPMpPgCK8QcQhKciljBdisj6Mi1kw
BVCjbVOMJ1Ua8maS6wx2N3kfvthcliPbcI+GwIvlWQ1puG9PmcNVZkyg0O7cFseP
kYFyldYo8Zx1ftBGeFe0/aSSp1nGATI5AgMVUn8XswBEqrLdi/oX951xFs6qCCs+
o3XMljWiW5sIcOmU/mbySFBCXtFX5sTmiCa4MltjvGuMLro61e2t3wuNxWMTBCc=
=X+b+
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
