Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3CACrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:47:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45967 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3CACru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:47:50 -0500
Date: Fri, 1 Mar 2013 13:47:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the ftrace tree
Message-Id: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Mar_2013_13_47_38_+1100__jTBOxWoouuDwerx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Mar_2013_13_47_38_+1100__jTBOxWoouuDwerx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

After merging the ftrace tree, today's linux-next build (x86_64
allmodconfig) failed like this:

kernel/trace/trace_kdb.c: In function 'ftrace_dump_buf':
kernel/trace/trace_kdb.c:29:33: error: invalid type argument of '->' (have =
'struct trace_array_cpu')
kernel/trace/trace_kdb.c:86:33: error: invalid type argument of '->' (have =
'struct trace_array_cpu')

Caused by commit eaac1836c10e ("tracing: Replace the static global
per_cpu arrays with allocated per_cpu").

I have used the ftrace tree from next-20130228 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Mar_2013_13_47_38_+1100__jTBOxWoouuDwerx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMBbKAAoJEECxmPOUX5FEIzoP/09I0lM+N9my9/rADMR3u4xo
TKrsDYr8yd762mkDfD6bw/rwXoc7JCocuyTyYv5f+nESHsODCR7ONHOBt9khz1XY
lubo/EU0MOqp3i9TG8aXgR4Ix0teyQ4ONWCeW5XsPcz2S/SjLXoAb8HDEHgyx69z
dEjzw4KUN9LfW8/1sDHz0JiqJnKUBagyw1MraUm5DPyt0GffdIC1LcILvrS1HBSQ
o0GmuzCOfNTZDIB7nuZQmQPkhjrOgHO9JsEXAiWidSWVgB7qZWVK7Mn3vG8M2D0s
S0Tv7vyEp8urK50m2HrtfNlpArCK8VhoFPGKzVpHi5ZlN4JUDO0tSXya8qCk4JJu
Y3DeAZR24YTaFpXd9WQdJawqpEc+WO7zKSyOiU8T7Ycu4+9t48Nl3VOu86y1B+oz
xMbZ9DE8bzdqkt8RhoXfaiqY6KfnX9Yjkdb4MR6ugSqa4yII2HeZAScO8EIBlrS+
jf9S7W0cJjKCSosXhNsBBollypFtWHNhiW7zCFCQNgeYlab9j//yD3Nv4ijlg3aU
V0dNvb6f5Tb6sb4jHMZTtDYd+eozJ/7blbrl4PuPeUdyb8TXnyzUzCgmC4OSJ4L9
+oA3IQnhaiRtCBpzubbhPIzN3GmoognBCx6nFSrnZkvEBL/F3ydZFGeLfFruuYSi
Pd0F72UuGoXZ+tWZSXsw
=+x1M
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Mar_2013_13_47_38_+1100__jTBOxWoouuDwerx--
