Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaLJBtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:49:35 -0500
Received: from ozlabs.org ([103.22.144.67]:53812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbaLJBtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:49:33 -0500
Date: Wed, 10 Dec 2014 12:49:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Paul <seanpaul@chromium.org>
Subject: linux-next: manual merge of the drm-misc tree with the drm tree
Message-ID: <20141210124925.2cba833c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8hx1ORyya/chZUdXc0RdPdZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8hx1ORyya/chZUdXc0RdPdZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-misc tree got a conflict in
Documentation/DocBook/drm.tmpl between commit 6f134d7bb434 ("drm/tile:
expose the tile property to userspace (v3)") from the drm tree and
commit e2beb6cd5d0f ("drm/Documentation: Fix rowspan value in
drm-kms-properties") from the drm-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/DocBook/drm.tmpl
index 60c1063d4178,b344bc3b0d77..000000000000
--- a/Documentation/DocBook/drm.tmpl
+++ b/Documentation/DocBook/drm.tmpl
@@@ -2550,8 -2546,8 +2550,8 @@@ void intel_crt_init(struct drm_device *
  	<td valign=3D"top" >Description/Restrictions</td>
  	</tr>
  	<tr>
- 	<td rowspan=3D"23" valign=3D"top" >DRM</td>
+ 	<td rowspan=3D"24" valign=3D"top" >DRM</td>
 -	<td rowspan=3D"3" valign=3D"top" >Generic</td>
 +	<td rowspan=3D"4" valign=3D"top" >Generic</td>
  	<td valign=3D"top" >=E2=80=9CEDID=E2=80=9D</td>
  	<td valign=3D"top" >BLOB | IMMUTABLE</td>
  	<td valign=3D"top" >0</td>

--Sig_/8hx1ORyya/chZUdXc0RdPdZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUh6apAAoJEMDTa8Ir7ZwV8ccP/jCRpUsMCDki74P0aKeViJZu
AuWo5XhftMVgOL1rKAgvwDavwZEa7IERAH/aUm+eZOjUAoO9F+aDrHy+9oIP95QC
xxmMD7Z4eg1R3kIfQTcfnns23pMRjkrpUO6jpfgWtWpPFUelyoVstnZ7AamNQDgX
vDqq8ylppdQFW8fS4g7R+q3cZ+F4eyi/7C9elbRO9wTBWN7Zp7ZoAiCZzTaGzfBk
d4u9yYugTxK+ynNlxxq3s6MTosukZhPp/IwiedH43MIJBURiAGFL3COKPhiNAfo3
QBcVvy/eY8onfBvxte7bYdQASPYD31ReTMB+hqxUNk6Ejv7C37HZzvLZpSuQRaCi
RX0sFK9/OLmrrOqaZ5w+WC47hdex8AzOiez5yN5xDjo7vx/FwxRAlqft0SkuW4Lw
niRmnOSe8zOAFyZuw5wvl/drLwEvUYLjE4pYayWK3bfsatPRx/YVFZaebj/uhSjm
T9aRkYN18IobOHX6n3kk9ODIhnZX/nanjqhdeXfM6DIIegYfMIVAx3o5mynJ1vrf
R/ictK4RMcqh9rxtlzeXAH2cObTwSSPvEwY7TLT0mPL6eJHwn/BC4Kh7wa1N2J0Z
MAQTk2CZEWNE3njHjvb5nZPJf7BM1qqRNDlrtbCD0ObVi5bJejRoiVQAkPkXh74G
GMbo67I6l5z5o8KMUlPy
=g5+i
-----END PGP SIGNATURE-----

--Sig_/8hx1ORyya/chZUdXc0RdPdZ--
