Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3AROXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:23:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37080 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab3AROXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:23:01 -0500
Date: Fri, 18 Jan 2013 16:22:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <jg1.han@samsung.com>, <linux-samsung-soc@vger.kernel.org>,
        <p.paneri@samsung.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kgene.kim@samsung.com>,
        <rob.herring@calxeda.com>, <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v7 2/4] usb: phy: samsung: Add host phy support to
 samsung-phy driver
Message-ID: <20130118142251.GL4672@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1357916550-11421-3-git-send-email-gautam.vivek@samsung.com>
 <1358166135-22073-1-git-send-email-gautam.vivek@samsung.com>
 <20130118131633.GJ4672@arwen.pp.htv.fi>
 <CAFp+6iF9H+n1Fwr89es-jtDAN=ht1PuXQER9vQ=jG2RZQTceWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yaPAUYI/0vT2YKpA"
Content-Disposition: inline
In-Reply-To: <CAFp+6iF9H+n1Fwr89es-jtDAN=ht1PuXQER9vQ=jG2RZQTceWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yaPAUYI/0vT2YKpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2013 at 07:51:08PM +0530, Vivek Gautam wrote:
> Hi Felipe,
>=20
>=20
> On Fri, Jan 18, 2013 at 6:46 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Jan 14, 2013 at 05:52:15PM +0530, Vivek Gautam wrote:
> >> This patch adds host phy support to samsung-usbphy driver and
> >> further adds support for samsung's exynos5250 usb-phy.
> >>
> >> Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >
> > Missing Kukjim's Acked-by here
> >
>=20
> Hope you are fine with the changes happened after discussion in thread:
> [PATCH v5 2/4] usb: phy: samsung: Add host phy support to samsung-phy dri=
ver
>=20
> Is it something you want me to modify in this patch ?

please send the final patch and we shall see. After quickly browsing
that thread, I didn't see anything scary, but I'd like to see your final
version before giving my final answer ;-)

--=20
balbi

--yaPAUYI/0vT2YKpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+Vq7AAoJEIaOsuA1yqREVhMP/iytQnQsMkL1bgqiPk5RenN1
iOd437Hs++ASP4iaCREbymedkGtu7nYhPKAtJbO2rj9/cHwksjUxEmEU/OlaFzvF
ARsHaFeBdVmZZJHYLP1IDGgd5KFW1n45n1vc8ML/wVPbQ8ZHrXUd1lGAX8aH8wx3
oJjoGHP6C8NOuQcEoAPoIcTFQSKWUBntWpEHT0EaU2swHi3D/OFY6AGfhF3U6QEi
ApcLH4Kob3gXyoPp7An48qsrQH1HX5gXyICTOLQNgEFq5WlZ2Ri8BEc/GQ3AuRu2
G8Ih1IdfqVoc1NE3YloIDT6q540dd9681BTGGCGxeauqtqGyC5Bw5fHUAiXPj/sH
ectJ3cjQbiGC6kcpwhC3HrvYeuxK8ZH67zfR+QF6D17KIS664/sU58KhjisEjIG8
gJhv1eV0hr/GQVdxBUhTg5kTfPs+7FKi3SvxukbM971JksYRdJHQubafLOz5dPEO
qTCYWMc2wXO7cQcm/vuo/Q7hp604BGntfiZB2H4KcxkRzEizKoFuR+983YkKDMU4
bUfUOnCkihuDG/USqS18Gw/oPKnkGeRArPagaMLFcu1xv4n2tv7tYhjz1Y9VY7Dr
+r8hENofT8lsdtCX8OiexgpJ4e83qhT6hKJRGhqfiDvR2jj0csiszwJNPvt/04rZ
9xe4C/J4/nof42VJHKqe
=yMgC
-----END PGP SIGNATURE-----

--yaPAUYI/0vT2YKpA--
