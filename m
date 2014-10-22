Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaJVPyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:54:25 -0400
Received: from sauhun.de ([89.238.76.85]:46570 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbaJVPyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:54:21 -0400
Date: Wed, 22 Oct 2014 17:55:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] treewide: Fix typo in
 Documentation/DocBook/device-drivers
Message-ID: <20141022155509.GA1895@katana>
References: <1413903614-20775-1-git-send-email-standby24x7@gmail.com>
 <20141022114917.3b34905d@lwn.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20141022114917.3b34905d@lwn.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 11:49:17AM -0400, Jonathan Corbet wrote:
> On Wed, 22 Oct 2014 00:00:14 +0900
> Masanari Iida <standby24x7@gmail.com> wrote:
>=20
> > This patch fix speeling typo found in html files within
> > Documentation/DocBook/device-drivers.
> > It is because html files are generated from comments in source,
> > so I have to fix comments in the source.
> >=20
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
>=20
> I can pick this up, I guess.  But I'll copy the relevant subsystem
> maintainers just in case they would rather carry the changes themselves.

For I2C:

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUR9NcAAoJEBQN5MwUoCm2gz0P/j4bQa6EKmw0RxFA0pOXjnme
0wafVJZrHuCzynqT3igz+PVpl5vFkV7QFNhcrBhZX2DxYNj20aDoESFSiJ4TH+Mx
9+NEUlG5C4CDCIwCtQvlarwBPmbsj+z82Sd/4tAr+1+nDacVQXjfYPAuTPdTs68w
y0x2SXq2V1sN8ufFCK6+/0SME4Oj+/xXllZbiSklOnm6QDK7vVYOsURi1uyKFyoU
gKhVc5s+2Twm0quLssatVUbQmH+6QT3q/cWFV2VBNY0G439Z0wOm7BAVn72QFxnI
8wLYbq1qljgNLi/2Up8Npt7aT+7/kpUPxgHehWusop/IOxw35lkKpR1AGhe46ZZJ
yAXmf37FG6AuXBF97ljjIHEcp2Sx9AEk9hZLD0UKfGsZxRmrmYI34GrDQE6SszXL
jCnLVb4GFhMQ6M45ETD/sZII4H8VY3eK3slDKpNXVJ47NV6s/j6qmRPbgHgo37Jo
dOMPPo9hjdtsDquCxUdFezzwEMz1JjquTCw3VNt13p3dvfBIp3Aokgo3pBhtsTUn
9Mgu8r0S3hocgl1sniVJ/gzk3sO9ho1XU9wdRHLluWrJiATKyRNCibx4/uTqkPV/
Yr2zyOdh4JepX0DOBZIsRciL99nzQXE1AAtV7I/4dboGjIZglfrnmpfA0M0EJxEW
fX0nw9i48iNBM32X/myL
=1i6W
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
