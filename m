Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaE3IRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:17:41 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:63416 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaE3IRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:17:39 -0400
Date: Fri, 30 May 2014 10:15:05 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
Message-ID: <20140530081504.GA16669@ulmo>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
 <20140528205145.GB10468@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20140528205145.GB10468@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 01:51:45PM -0700, Greg Kroah-Hartman wrote:
> On Wed, May 28, 2014 at 04:26:32PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
> > deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
> > functions in favour of the unified smp_mb__{before,after}_atomic().
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/base/fence.c | 4 ++--
>=20
> Where does this file come from?  I've not seen it before, and it's not
> in my tree.

I think it came in through Sumit's tree and it's only in linux-next I
believe.

Thierry

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTiD4HAAoJEN0jrNd/PrOht2QP/A+TbSb3lj5lxLDzizKznMWl
BbGfoptOocnFB7AQfVcCjU64Yg1HwkPCxiEgRCciCMLt2HQFGHdRMgzDMtaPSHYy
mOtS6tJPHsYSOSnvWaf4M2Syc3qHrutVrCDVGtCPbFWPuMDCCWv0Okd3RIkL3K2D
oXRMvpkGhOW3OiveaFqG1oxRpZOpvuSgQFoBa3uSrT9INMcX7BW9ONIQL5YTPA1W
uhG4vadwGbShkCmn/pkt8pZisyu2z2CB15rbXzMdMaXysGtX4H3Om2E7XB+AhUWP
0ZYuWJWuM8GQLp1r5J9yxYknfExweLxat0MpP1+iPMdaaD9dnKSVScb7Ym6hRKGr
jG0YHuJedva3bvVYLmliuvVhl7xx8s30SrvObaPSbg5bN0kam747bIp1R5OP/MrT
9xBHWlFIXY3fdX60uKrBAPapS0t+xTkVLT5vGPnCWqLPZb04bQ8C9wpH10FpXjtq
2n47PuNpB5zN+Gzru0pVjD66aq86MFaUw5IqzckpvUv06vQrJSwsUz1NsTQ+bdpk
djOhePMoy/Q6rMVggMYytxT8eY3pKnt4Fh/Op2ZptX0fHMHPQ9L9p7FlB9Knl0UX
AgWATjx1t9A+31QrftGEeyK0E9rPIUkmuaRoCuCTAJuIr0vzF26LtQl0o35TEIJa
9UHaou+AxEQF82BsXGQQ
=gDV9
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
