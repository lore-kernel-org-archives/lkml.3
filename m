Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3HBHxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:53:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46260 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab3HBHxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:53:14 -0400
Date: Fri, 2 Aug 2013 10:52:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/6] USB tree changes for Tegra30 and Tegra114 USB Host
 support
Message-ID: <20130802075257.GL24465@radagast>
Reply-To: <balbi@ti.com>
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com>
 <51F99C4C.6050508@wwwdotorg.org>
 <51FA5C5A.2080900@nvidia.com>
 <51FA8B3B.8070504@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWRRbczYj8mXuejp"
Content-Disposition: inline
In-Reply-To: <51FA8B3B.8070504@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QWRRbczYj8mXuejp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2013 at 10:22:19AM -0600, Stephen Warren wrote:
> On 08/01/2013 07:02 AM, Tuomas Tynkkynen wrote:
> > On 08/01/2013 02:22 AM, Stephen Warren wrote:
> >> On 07/31/2013 11:41 AM, Tuomas Tynkkynen wrote:
> >>> Hi all,
> >>>
> >>> Here are the patches for the USB tree to enable USB Host support on T=
egra30 and
> >>> Tegra114. These are based on my and Mikko's cleanup patches that just=
 got
> >>> merged to Felipe's tree.
> >>
> >> This series works fine for me on Dalmore. However, on Beaver, I see the
> >> following:
> >>
> >> [    2.428480] platform 7d008000.usb: Driver tegra-ehci requests probe
> >> deferral
> >>
> >> ... which never seems to be resolved. You can take a look at my
> >> linux-next_common branch to repro this. Does Beaver work for you?
> >>
> >=20
> > The clock driver patch is missing from your branch. Applying it should =
fix that.
>=20
> Oh so it does. Sorry for forgetting about that patch. Given that, the
> series,
>=20
> Tested-by: Stephen Warren <swarren@nvidia.com>
>=20
> I'll also try to review/ack the patches ASAP.

I see you requested one minor change, so I'll wait for a new version.

--=20
balbi

--QWRRbczYj8mXuejp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+2VZAAoJEIaOsuA1yqREW0MP/Rb4UbrpHNUYX2104av5kBDy
biTE8EoEBcyDixkUWCnDshVWdCuKjNcxnPgiy6rtlNsA6zUK4PxU4Oibm84qdj1a
OI0PVnB4labjT1HvbS0iETt4+m64Zg4yDcT8SYpU6kCFARk++gQSq0ClfPv3t2pS
yKRf9T3dbP3HAWC1cuRjk1k/xqF9u+jDp4U+KeG9ZNbELvkRXuuXPRefWy4uztHw
X2Ktp9z3ASqrKM2Qed6vqpLldRGomnyI9PppfYqHEpS/VVvg497MKHwBc9DgS+k3
C9lxLN/A8YoCsc/TneBVljmU2uCleI4/JJiASuJ+HZaaS8y6Bj/DDpS+HP2Rxx8f
y4HTwXUvkeXb9JB2hdkLA2dOTxesHPveAj6pq8kwGIJq+g4AVXxl047IsDAn+8Fb
sLIaSCqh5JWKIocSgPg4ZjScoc0V1rDV/q9mAdm7M1kjas9CqqOkZjAsFi9SovdW
bj741ZkgfvW+HekFs3zCZTnLYd6+oIKebjW7cmJ7YIU7vRVlxBrDZAsmj3Y/lkmH
6QkP8JxYtooUb1ODwPCSO/TGmqkGS17eUAzB7/sq5qpA7FGWq1dDAZ3GI6ql+I7O
VDUS0U/HWtOI+OAJBUwjONv3Nmnleao6UinytlKjVrN85Ze0b2mKNT/R9uLgcDLz
qr81gBBySntvZu+h37CS
=SrsH
-----END PGP SIGNATURE-----

--QWRRbczYj8mXuejp--
