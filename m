Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaBFAEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:04:13 -0500
Received: from ozlabs.org ([203.10.76.45]:44569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbaBFAEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:04:12 -0500
Date: Thu, 6 Feb 2014 11:04:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: bad commits in the f2fs tree
Message-Id: <20140206110401.7888b06cbd651b842404b902@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Feb_2014_11_04_01_+1100_jr4GQ+Rlk6m_2+99"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Feb_2014_11_04_01_+1100_jr4GQ+Rlk6m_2+99
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaegeuk,

Looking at the f2fs tree today, it has *copies* of several commits that
are in Linus' tree (including b522196a6ffb "Linus 3.14-rc1" which is
commit 38dbfb59d117 in Linus' tree).  I assume this happened when you
tried to rewrite your tree. :-(

I can't use that tree, so will use the version of f2fs from next-20140105.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Feb_2014_11_04_01_+1100_jr4GQ+Rlk6m_2+99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS8tF1AAoJEMDTa8Ir7ZwVCi0P/jx8BpOovz5N/4lpzqHpm+x7
RjuBVtshxfY00OT6riMM89tdsmyhUe9fLvVi3bslT428/o6Zbl60XyEJ0FHc5L8P
ZMVlZVxIFnE2w8xXY+L2YOu/78hb1Tuume68IxVNY7sx/5F/40Bwc2j3KcmZbO3j
7vPzJHtbvyWQ07rjIBZ07K6AzQ9+IsjvuqzvQwE8YAh94WTFLtarIliufeOmHmzw
cXgx3cT5MsWa1bG8Y93f67JSQ6h5FiDihREAC+gcyPzJxvQ5a43xsk6T7ZFu/rjG
sh5wd0QwF6AtNogkNiQYTXdFFuVi6vT5VSlL6Ti/kExXIxzJZjlWZ4JePu810wQf
VnSp76gi5PproFtPhtBf+leyaPzZSKJDSnDFBgi7Cw6cPRACV5GAP+U/RKonUiiL
plptFGbokXdaExJt71oXqoJ1ySI93pxoDSh/xoR6HOZVy9EMKHrrjPDx6NbhmfgM
d/Up88myriQKFuwm+uPMNOC85cm3TLXp2U/3zDCCtI+6/51EcpSIzq1z0rBhqZCS
K/n1TJdDNul/HjGajF3Lk2Vl+lrwjotu/Tp218ZuJEFNfOfevPa2jMruoQby3jZg
Tp3Wl2eMYtcX8CY75cFtV/QRYSbwa4MB2M1plFaMqAerS5UbqCbO16Y10/lMbchx
grN7FOQypj5c8HPCpm3P
=jNlU
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Feb_2014_11_04_01_+1100_jr4GQ+Rlk6m_2+99--
