Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaFDGJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:09:33 -0400
Received: from ozlabs.org ([103.22.144.67]:53332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbaFDGJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:09:32 -0400
Date: Wed, 4 Jun 2014 16:09:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140604160921.4f4e69c4@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/o69K/u=r5Wh+K8vKN8T19he"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/o69K/u=r5Wh+K8vKN8T19he
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steven,

After merging the ftrace tree, today's linux-next build (x86_64 allmodconfi=
g)
produced this warning:

kernel/trace/trace_benchmark.c: In function 'trace_do_benchmark':
kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq' [-Wu=
nused-variable]
  u64 seedsq;
      ^

Introduced by commit 81dc9f0ef21e ("tracing: Add tracepoint benchmark trace=
point").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/o69K/u=r5Wh+K8vKN8T19he
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjrgaAAoJEMDTa8Ir7ZwVJ8AQAIGNXamsuOGRtZCvJF+xYR25
De+301i2OGWzJuiiYSasq1YaO6q1pRHmQTb9fVctY7H+D+Pv0kE59gqA4H3D2jBI
lYRU+7wChlNh1s0vEVyl+fTwjSfnJS0zEr+FgTboYp/0r8cVx5sg66eo0WShICrS
VES43grKv8vQbj0I6v0pwXg0K1iX2PIkdbYmqp1YVJlV704WXm6OlswBHUBZqpPW
VKr+IZvWRoPR+ev79uSV116MHrGWV07hG+5wBwpoTOv+uPlKa0hq2pQ8fQMIF5P4
oVxF1GfOvyj1qbpN3b41zdjYDrYvIWC56rksl61kaCcEFbycL/U5eNJpjPels/OJ
WibZfVIeUFx7fiq2/bKTgzNsS/lf5D/PsaoYqFqGt2dSshtkmSNh1Xar654YAzRq
qDjSakPW/GrDvrIvmnLERMe6pJJtY1N38j8GshAHOcNdnUEcVzuU7NSEGZEn9NKE
szwIdxSiJE6xTyXoIcQZbgBHkH6+P4m+4FKf+JY52NITMuKWeQaZ+ktX+kDU+oAc
M6mrWe/35TnJLUO0pJQNUpQ19iOmfFGMe7lFm6+U3WQSYGLoT45HCETJ+bTCWo8Z
jKt00tCRpSQ0q2v34XSN+57h/UbhWIUXu9skJkGeGcFp9t7a2Wm9hJz8A6hCSRRa
t8upp40G82qew8T2gzV4
=pNRL
-----END PGP SIGNATURE-----

--Sig_/o69K/u=r5Wh+K8vKN8T19he--
