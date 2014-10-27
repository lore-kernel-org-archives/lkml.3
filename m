Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaJ0Rbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:31:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34941 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaJ0Rbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:31:36 -0400
Date: Mon, 27 Oct 2014 12:30:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Romain Perier <romain.perier@gmail.com>,
        <heiko@sntech.de>, <devicetree@vger.kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh@kernel.org>, <mark.rutland@arm.com>, <johan@kernel.org>,
        <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v1 02/10] dt-bindings: Document the standard property
 "system-power-controller"
Message-ID: <20141027173025.GA16005@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-2-git-send-email-romain.perier@gmail.com>
 <20141027163918.GB14253@saruman>
 <20141027172636.GZ18557@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20141027172636.GZ18557@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 05:26:36PM +0000, Mark Brown wrote:
> On Mon, Oct 27, 2014 at 11:39:18AM -0500, Felipe Balbi wrote:
> > On Mon, Oct 27, 2014 at 04:26:47PM +0000, Romain Perier wrote:
>=20
> > > +act8846: act8846@5 {
> > > +	 compatible =3D "active-semi,act8846";
> > > +	 status =3D "okay";
> > > +	 system-power-controller;
> > > +}
>=20
> > there is no mention here that system-power-controller superseeds
> > poweroff-source and deprecates that.
>=20
> Given that poweroff-source hasn't made it into a released kernel yet we
> can probably just kill it off completely can't we?

please do, then we will never have that commit in Linus' tree to give us
nightmares.

--=20
balbi

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUToExAAoJEIaOsuA1yqRE8lEQAJSBOEnbUNdYcqNo7k08faOa
9gNfcmn4vOFXqZPw9O1Br65QbMjMsuAZqo5CvR02e0MLBMJJbQHvRj0IoxLVGxDy
9M35aHMgv1Fi2oHgGaDuKJnKGfS6VoEyMTdxopkrCDwDNQvZD/G4KgENodwYZtC9
N0bPoQhEwynrcIknxyEZeDNOhaHHARsrPCMwPCdGMQkbmS+yPZbFyJiySR6pziOS
DNIFoAxLMYCfznbpRh6sXSiMNINSZcKrExgRPrYkeLzroMxm5FisMWpw2hAh2nem
zn73/0KVJJX6w4PDTThHNx/BUUDcBf7MmtEt6DPHrj+Ley+khS/pgic5YwiTAuMm
YZKgXrX/01rN5Mst8xE9Q4NA+HuQgc091JjYq7dvXRlOycYe4nHLnTzZcNIDSb31
Bz75vuZ/HKkUdHlgBYLPKyOiYeohtMgwuP81T6q9f/fbgMgAfYlvs8PKPxT6SHv2
DYa9Atgl9/ybgZNUKHntTLXVon1+uLPzgmSpEYxtnyxt2L0c8qokR7c2F6e7DguH
4BgvJkFW42lB8eiIiSQg0ROTkAeG36BdVSD8el2QvgvEC5bvseImtswVQxMTcf/J
Ulmixlmdng9U7WyFE27gflIZTinrAGFUOj6QnF1qzAAx5d8o/8g2zbGWrvn57zwY
S/NKQf8VGhKpV4odHmSL
=XBwX
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
