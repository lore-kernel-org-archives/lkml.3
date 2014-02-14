Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaBNEaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:30:19 -0500
Received: from ozlabs.org ([203.10.76.45]:39399 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaBNEaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:30:17 -0500
Date: Fri, 14 Feb 2014 15:30:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 cgroup tree
Message-Id: <20140214153010.7ccb12b8518a46b21a158b22@canb.auug.org.au>
In-Reply-To: <20140214152557.cf6e5b5b0961dc47f800fe4d@canb.auug.org.au>
References: <20140214152557.cf6e5b5b0961dc47f800fe4d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Feb_2014_15_30_10_+1100_4IT5bCg+/A9kEaaz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Feb_2014_15_30_10_+1100_4IT5bCg+/A9kEaaz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just adding Tejun]

On Fri, 14 Feb 2014 15:25:57 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi Andrew,
>=20
> Today's linux-next merge of the akpm-current tree got a conflict in
> kernel/cpuset.c between commit d66393e54e0a ("cpuset: use
> css_task_iter_start/next/end() instead of css_scan_tasks()") from the
> cgroup tree and commit a82211b06d6e ("cpusets: allocate heap only when
> required") from the akpm-current tree.
>=20
> I fixed it up (the former removed the need for the heap, so I effectively
> remove the latter) and can carry the fix as necessary (no action is
> required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Fri__14_Feb_2014_15_30_10_+1100_4IT5bCg+/A9kEaaz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/ZvWAAoJEMDTa8Ir7ZwVk3wP/2s0F46DVtBshmQYwdW1va4w
bayj13jQeF2rYpzdu46l5Odn+k8EsjvwJ7/1OQhngVtOL+cGqpmQfTGaOKOVaboA
mHhEDWh6zAYzsnTn6t1ZTId7naSkLmUq1f5Cov2L4RfYZehs/O3l+Q+3SZGG91sQ
TQuAeOoJn2qtt2hWjtwz5xWcDJrFq7ZtkADmVljbBBOuwbspSj6RZRfjIzlt7/Z1
6LNJBcKQ+/AzDhmgbBrT8aTMlrh3V64JTj2B/My7SLwWiAht310i+pYOx6UrqPLC
wUdndv8Oyx9/glbdPkqdAPM5QG+DM+qLSGxj74SW+4PFi6Cxj0Fsy0Euq9G3M6qZ
1JhX8Gl+M5GaPovoQcYlLwJstQXmG7jYmIhZJrnmlxEDqVQAUQVede/A2ibua4q+
sQccy3ycyQ0O4UGgV64PprIvztlqVf6pe3GjJf00SURAUv2Y6sLhdPLVFbUvyo9J
lcjyM7z5Bmmdvu90/wg5Z8wHJcm+L3uPa8ozuJYH6OFhaut+5xibihdT7oRLazON
OlaBmdoIcXvd8d8TV0Ik0YSrPyyo2DlQrJI4DOSGw+gvsqXxn50/QUL1FynWqZpa
bjccuc/T26rrj4CWehPeTGvh+AjrT3knvJqmfY+bEYWCLAYeHy6iYhGCOtATSyGO
yk1X1btMWk4Ooshw6dY5
=1km7
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Feb_2014_15_30_10_+1100_4IT5bCg+/A9kEaaz--
