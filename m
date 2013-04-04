Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787Ab3DDGEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:04:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51665 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab3DDGEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:04:23 -0400
Date: Thu, 4 Apr 2013 17:04:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Nathan Zimmer <nzimmer@sgi.com>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130404170414.33181fd7ba8e17a6b662b200@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_17_04_14_+1100_GN7pAPTmbvlbEkMr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_17_04_14_+1100_GN7pAPTmbvlbEkMr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
sound/core/info.c between commit d1ffe1db6641 ("snd_info_register: switch
to proc_create_data/proc_mkdir_mode") from the vfs tree and commit
"sound: convert snd_info_register() to use proc_create_data()" from the
akpm tree.

It looks like they are trying to do the same thing, so I dropped the akpm
tree version and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_17_04_14_+1100_GN7pAPTmbvlbEkMr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXRfeAAoJEECxmPOUX5FEYEoP/RTOCw5561/2LwuJ1iWNgnnG
PFa/MEuz2SHFfgRd1ZjiyNfmBaEDE99jKvN/Ckt55s+qDLc9GiFxMTOxVXPe+N+3
QcE88fmR7hLwbVRV5TwvtiMepC/yzhoXh+kPSePZ69FuAfRo6L7i6RlXjA9EQd9F
TcaIH9cXSiQ1VooZ0Y4j5lNCN45VzPDPRc4t31JIAdadimmWzsYm/96LY16HdkbW
A50YVg98H0xydoCD9fk/r1u/Kz5Me3QToEtQavlvRKik/zoC2FmzEVXhOn6HGW3Y
DUwk5osE2QJRuFaB0uiChjXKE0TblOftZR7awDZZtVO1Rm8xHSLL55euV+hQthti
h7V2XsmjfrWDn0DBYI6G7NGT8W/cnGApK+VLGcbtWxoeokUKycgXdWTi1rQQxVZg
0CUnJbaP6+Jxa0egd0IhGStwTB3vNFGlR/7C46pxtzKa9e5Oa/f7lKHzSmbYO/Fs
01cLtpniK9CFfMckDRhE5on1jGvegxa2/zOkTCYnaM9Epa/AOKkiMw2rGpSdFI8a
e2hRHUuBqLmEC9JpW/KmEyHIlcTcC/rcpMCzOX58XhWaXOOyq0t/xM0ZiPyRk94B
7sCorxf2fAwO++b3+XfMusvbDeKnpWIyULarP1V/coxURXOhhUZghgMZuXmkgz46
d0RECxlmJcUIi+5RI9IZ
=JwBg
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_17_04_14_+1100_GN7pAPTmbvlbEkMr--
