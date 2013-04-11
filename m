Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937173Ab3DKDAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:00:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48713 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764684Ab3DKDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:00:13 -0400
Date: Thu, 11 Apr 2013 12:59:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: jhbird.choi@samsung.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, vyasevic@redhat.com,
        patchwork@lists.ozlabs.org
Subject: Re: [PATCH 3.8-stable] net: count hw_addr syncs so that unsync
 works properly.
Message-Id: <20130411125954.74150e5689d3f65365947755@canb.auug.org.au>
In-Reply-To: <20130410.205401.1135160208998128324.davem@davemloft.net>
References: <000001ce364b$f1b178b0$d5146a10$%choi@samsung.com>
	<20130410.205401.1135160208998128324.davem@davemloft.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Apr_2013_12_59_54_+1000_FbKkHEOi/y2QZrQM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Apr_2013_12_59_54_+1000_FbKkHEOi/y2QZrQM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 10 Apr 2013 20:54:01 -0400 (EDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> Date: Thu, 11 Apr 2013 09:31:44 +0900
>=20
> > This patch looks like it should be in the 3.8-stable tree, should we ap=
ply
> > it?
>=20
> I queue up networking patches as needed and that queue is
> visible at:
>=20
> http://patchwork.ozlabs.org/user/bundle/2566/?state=3D*

Actually, this bundle is not visible via that link.  It appears to be a
public bundle and visible via
http://patchwork.ozlabs.org/bundle/davem/stable/?state=3D* .  I have
insider knowledge :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Apr_2013_12_59_54_+1000_FbKkHEOi/y2QZrQM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZicqAAoJEECxmPOUX5FENrwP/2j3VjMoCHNnKjnqGTq8wbNp
gM7FsxRwxgObbPwin8NEZJS5q482VG5XmoQhgoY9yZmXeW5vdaa6bveP1s0niiZ/
fQsHQ0HNaey9fa6Bms5eDUbuk27NBkTFDyxtK/L2vxsaKs6Yeqv9TMfojYp/OME1
H+tqndMb9n1tS5tEODjYrJneJBspyuVSPkELqHm4ctRoN3zLOkBVXu4Gr/FtY9Ia
bLgHoygJe54IXRgpHmIT5C0o+MdcLveq/CWpn8jQ1WFItQp3mWTstirmNPxrfNDM
e+g0d6uaFD48gKKfJ9o4ZvcC16IoKmQ6GEho0RPdPa9neqbW10FwZuAxnAmqXKSi
ofrVUfQbCJh5Zyw/8wL1j0jeE6iVMaXPPrAM+kBlMCxCeVOU6tAaTQUaCn2eL08J
LenhagN4IMqXoZDktKeiXDyI4aXvnpjd7nJOw0xQRDc26U+4v6s/xla/3TTKFzJg
sKunpVv7ueElHAiDCtYoMSvkZxK8GbQNoLKkqLQEKIrTvnwx5MijGqVk5ZQvyXrd
4itMfYvBMfYQmo8gcO5Dnpr83N1LykqDLcj2HBIWWOc9s2IZe5fABiLyDocEpI4K
W90O35BuJZXTPDFfT/xW5+NMXNK1e5gU9cSHdPxtXUENcNxUkQm0ns6miH12iaps
mf9jkZkd0RIUClguWs1w
=vllu
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Apr_2013_12_59_54_+1000_FbKkHEOi/y2QZrQM--
