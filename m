Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab3EZJSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 05:18:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3EZJS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 05:18:28 -0400
Date: Sun, 26 May 2013 11:18:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Simon Horman <horms@verge.net.au>, Axel Lin <axel.lin@ingics.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] pwm: renesas-tpu: Add missing pwmchip_remove() call
 in tpu_remove()
Message-ID: <20130526091824.GA12361@avionic-0098.adnet.avionic-design.de>
References: <1369057541.11578.1.camel@phoenix>
 <20130523013933.GI22608@verge.net.au>
 <20130523191217.GB17462@avionic-0098.adnet.avionic-design.de>
 <4528298.O99iVSpig9@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <4528298.O99iVSpig9@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:hecXBTg9G9yP5tTn0pw1b54bmrABMEFHK+1W0q0M0Ne
 yp9BI4+JVKNa2GgdKMHBnCqQpyx8+Z0/MyXgK128cMG+boSxO2
 J7dSFGGTdky5rOubFLLv2C6P7n6xmkUpKP9klcpyCu2+wEJf8p
 QUVTAACOj+ujt3iuz9uArcwoS0DjiVe3Cv2DX/5qmZQ5TyCM6v
 fMaPIjt+GP9lo9hK68u7Ol3u1zhb0jNKTaxoVdqViv3y7POIcj
 RYLX73jTRoCX0URThqqe4XQozyntBHSkaS1F7mEhY8Mx6bG583
 xbaDObEEUq20WryqNw1gOOB4tl9EIRebPywM+crnVkmuV7Nk2o
 fGvceJqRKHzPM0BXB0gAg/bIUkX5sA0wdgGspuFjDmkFGhVy6u
 jEUl2awQMJtcDl+dVMchIIQ2aqfzYOPuN59QmCIXmq816MtCYe
 I1zXE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 25, 2013 at 03:42:42PM +0200, Laurent Pinchart wrote:
> Hi Thierry,
>=20
> On Thursday 23 May 2013 21:12:17 Thierry Reding wrote:
> > On Thu, May 23, 2013 at 10:39:34AM +0900, Simon Horman wrote:
> > > On Mon, May 20, 2013 at 03:46:59PM +0200, Laurent Pinchart wrote:
> > > > Hi Axel,
> > > >=20
> > > > Thank you for the patch.
> > > >=20
> > > > On Monday 20 May 2013 21:45:41 Axel Lin wrote:
> > > > > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > > >=20
> > > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >=20
> > > Thanks. I have queued this up for v3.11 in the pinmux branch
> > > of my renesas tree on kernel.org.
> >=20
> > I'd rather take this through the PWM tree along with the original driver
> > patch.
>=20
> As I will need to submit a new version of the renesas-tpu patches should =
I=20
> fold this patch in ?

Yes, that's fine with me. It'd be nice to credit Axel, though.

Thierry

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRodNgAAoJEN0jrNd/PrOhgx8P/2WRvGi+BykuUiKEaAECnsCn
DLbHFEJI5EVW1dnvK95YtFrrQTXKvU386toY4G/3DQasOGkF+adrirk3K52WwQnH
5O3BS7omAMVmXCPp47jrRQR9CL2oDAjzm1GEIoYKQB+PQcESDZjc/R53zxLADltD
rBnt4+FzNZQ9gRfoBpgd3lEDHGTgBPkUT62SXEvEELQMo8a668pGZ05v2G78PTUf
Oxduq+JhG5fcbkSHG/3zXQSe6PKQp+2OUVqhoLJd1YS42gRA6UNDeXatml6+Idbe
wqkOgx5H/YzJ0JwuW540SlSd/6NnRWONPzhpod6Qg2a1q5y7JFHoMiaronstZR+K
SkYdqo1SL3n2aNCuDeg8Nuc62+AaQp/pdkaaT/W3al/k3dHpQIk7yt0yFoydjzxk
bijTmHAFcdHcMt1MrwRVa+CbN6Cqknmegd0/zll9scN8Bphs+uIua65wQN/T8+Ua
mOE723tS2Uw7/P6KAKVhh9USZkhkamm0xZpteRDXIvr37+iTQxtbZ3UeGTuWDgxC
1qD2K2+GJYFnjtGgIXn4UonR24KH0lMkbDteLFw/tHYZjbFXcp0V0yRA0LVJzonX
m9S/Sy9Kx2XbgFY6JEmp6ftHAOZVwVBVWJj2wiKBKDJ4mNGM+EGqUYv0Cc805N/U
aeZExTKADdbqgmTsaDuM
=3stA
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
