Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030557Ab3DSOGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:06:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030427Ab3DSOF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:05:58 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1X6eQJcytwQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UDRJaWTprgQA:10 a=0d9mvdZoeOKRmuv0f4MA:9 a=QEXdDO2ut3YA:10 a=styh1223ASsj7xxBnYEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130419140402.730041313@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Apr 2013 10:04:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 0/7] tracing: Various cleanups and small fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This will be added to the queue for 3.10 and uploaded to my for-next
branch in my git repo.

Chen Gang (1):
      kernel: tracing: Use strlcpy instead of strncpy

Namhyung Kim (5):
      tracing: Fix off-by-one on allocating stat->pages
      tracing: Reset ftrace_graph_filter_enabled if count is zero
      tracing: Get rid of unneeded key calculation in ftrace_hash_move()
      tracing: Check return value of tracing_init_dentry()
      ftrace: Get rid of ftrace_profile_bits

zhangwei(Jovi) (1):
      tracing: Remove obsolete macro guard _TRACE_PROFILE_INIT

----
 include/trace/ftrace.h     |    2 --
 kernel/trace/ftrace.c      |   29 +++++++++--------------------
 kernel/trace/trace.c       |    6 ++++--
 kernel/trace/trace_stack.c |    2 ++
 kernel/trace/trace_stat.c  |    2 ++
 5 files changed, 17 insertions(+), 24 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRcU9BAAoJEOdOSU1xswtMVYoH/jpO2oxmv6D6ZhZnawgy+9Pm
JuU/jnZZyLCKEBpduecWeshrjLkYaxDx+PT6/E3GwNIF1hQGuvWwINH731uljztf
+6a93JDqdyDFRlm0zINtovNfTb5gR2VCDnkk9u3pKTrdcXu9WvqRL2hvRcMUZy5r
auJ/uv48FOZR3WOv5/cf8Dr3MQE/C5jz441aiu+mlYeQOIqA7eXr6P0ZcHbrUJjH
oLR56Rtz9TH7Iw6sV1fGHX0w4tcD2MPkEghrGaoldwxIs6no3yff/V3o8crE383n
z6hBk/SjV4bXwkycLnBMJpkTd6Sgo5SkaKuJOE6nxGUjD/qCqMmScZl+UiXDgus=
=cZdW
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
