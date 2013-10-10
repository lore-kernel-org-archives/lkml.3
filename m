Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3JJKut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:50:49 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:53718 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3JJKup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:50:45 -0400
Date: Thu, 10 Oct 2013 12:48:41 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: Unbreak build
Message-ID: <20131010104840.GC6735@ulmo.nvidia.com>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
 <1381328067-1593-2-git-send-email-treding@nvidia.com>
 <1381329703.4971.18.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
In-Reply-To: <1381329703.4971.18.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2013 at 07:41:43AM -0700, Eric Dumazet wrote:
> On Wed, 2013-10-09 at 16:14 +0200, Thierry Reding wrote:
> > IPv6 specific fields in struct sock_common are accessed in various
> > places even if IPv6 support is disabled. Fix this by including the
> > fields unconditionally.
>=20
> Well no. There is a reason we keep CONFIG_IPV6 at all.
>=20
> The right fix is under review :
> http://patchwork.ozlabs.org/patch/281784/

Yes that's obviously the better fix. In fact doing exactly that was my
first instinct as well, but it seemed to be more invasive and I really
just wanted a temporary fix for the build errors.

I see that David has already applied the above patch, so this band-aid
should no longer be necessary.

Thanks,
Thierry

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVoYHAAoJEN0jrNd/PrOhIXYP+gNpXFuh+Bd1Py/xhUCh1ix3
DXdWfnJeYufP1npI1ifzhMSun6R6zakksF1agRz+ZKEunTAMhoypvZP/sj+py5I6
SB1Fl1IY3N9fpnlhJtaDj6EBItVTz+N4xTEZ12d0I5d/58hrEeW1IVmMkzCEhPPt
dGGZ1dgit4ZNv0tM3KMXIeMvdTqGjlTz6vaRKMjDheS33k3rikbvxHQ/qiU2zeEF
cC4RecX8/SL6pyxD9FLJSiTK3M+wRCyKWkEwxdSSF/zDBfsxgLCCsotliJG8prnd
3z1T1GhLVIGy++B9xkUvzQDglaSXRuHxToZwJCYjD68NDgHXosIwOQpYUVKHIMGZ
FLVWgYIM9/zjNpqChr33bNCZECzeVC+2USMkOHwxczYLfQKvhihbuEh6CZAg0vNg
9OMl2XnUWmlOyzsAPiamKz0mCCD/aBFDCOXj33tBFKk+ui0YKIeCP3n8M6UlouQ2
ZRgf1vj80vax18KOuSBkExZrAOb6TtUWNECgL0vH7kqwL6T+Z7wPwp+DykCpQYjV
YDi578FXyJXmMrqCYi1PKEnHlmg2Z+FHzssabTdy0bDWrmBKOh89oZ90WixOYTyf
bMyOAAWg0HnRUT2pIbbscEGnlZjxRpWQGdvD5FdvSiEtKDP16p4fCK2vGdKwK3RK
K1v/eHcnABXZztDQp9OQ
=HTVF
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
