Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3KGCKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:10:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41471 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3KGCKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:10:51 -0500
Date: Thu, 7 Nov 2013 13:10:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20131107131039.ba60e7db9538175c7a479666@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Nov_2013_13_10_39_+1100_d8w388ay+Kcr3MGg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Nov_2013_13_10_39_+1100_d8w388ay+Kcr3MGg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/atombios_encoders.c between commit c23632d4e57c
("Alex Deucher <alexander.deucher@amd.com>") from Linus' tree and commit
43a340262ad4 ("drm/radeon/atom: don't call [EN|DIS]ABLE_OUTPUT on
DCE3.x") from the drm tree.

I fixed it up (just using the latter version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Nov_2013_13_10_39_+1100_d8w388ay+Kcr3MGg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSevakAAoJEMDTa8Ir7ZwVmKAP/3byXWHIFK9qU+jramHe5SOv
BTPOgtb4HGus+2AoB+27A7iyM39NXSxZKoyidAQ2aYsXszW45sWi5IKwRVCgvF6f
DhpmOIpWpPEYPXhJCu0w9/4qcCuUGq5Y6/VDeqw3qlae9MoJ0yzvCGB1RAdLwwFv
M9BUHAlIJToPT64GSu3yDkVCzr+TAwbrR6GOnw5/9c5HqZDUmeJjGe+0NSoIes0y
NKO6LNRF09KOe6ihRTxxwqL7KkFBz0nVenBTHOUR6mi70oo48+pDwPFSE/YP7elc
3HtdY0odk3xELqM0b9/2LhT2UfMPuhxZfPrBICPMkXJ77UQy16deKVzR/hEgJPrK
banSTiP8AD2+Wel+EWumHRKq6E2SB+Nj+KqCYV5RuEA78gTtEjajx6LfUbejFsaq
o9z7dei6Qze9qw8e1fC5PRdra42XVa1po7RadYtUXqnLTxi9JkyRLbMmw6AIJ5nF
vlMTPN7zI5ME4wZOcP7Q5GulBrcKjBZp7Iyq29uRs8KuRaQ92q8NhHEmQo5kwiiE
4v3ED06RpaTSL6ETMMMqg1KIV6/VcYLWQmKYK8EyBUrSRVaoWMXHfP+Kfj3tYWsq
pZMlvbZh8JZY4WpcUp9SqzQYZQIlz2nqV1efbzKxm+OZGabJ2ZVQ/WLOmUQiDMVB
kAGSTlODSgP363wUwzlh
=N1yZ
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Nov_2013_13_10_39_+1100_d8w388ay+Kcr3MGg--
