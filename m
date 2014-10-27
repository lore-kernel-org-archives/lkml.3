Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaJ0Qsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:48:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46008 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaJ0Qsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:48:52 -0400
Date: Mon, 27 Oct 2014 11:47:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Romain Perier <romain.perier@gmail.com>,
        <heiko@sntech.de>, <devicetree@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v1 01/10] of: Rename "poweroff-source" property to
 "system-power-controller"
Message-ID: <20141027164741.GJ14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <20141027163840.GA14253@saruman>
 <20141027164103.GD2006@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CxDuMX1Cv2n9FQfo"
Content-Disposition: inline
In-Reply-To: <20141027164103.GD2006@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CxDuMX1Cv2n9FQfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 05:41:03PM +0100, Johan Hovold wrote:
> On Mon, Oct 27, 2014 at 11:38:40AM -0500, Felipe Balbi wrote:
> > On Mon, Oct 27, 2014 at 04:26:46PM +0000, Romain Perier wrote:
> > > As discussed on the mailing list, it makes more sense to rename this =
property
> > > to "system-power-controller". Problem being that the word "source" us=
ually tends
> > > to be used for inputs and that is out of control of the OS. The power=
off
> > > capability is an output which simply turns the system-power off. Also=
, this
> > > property might be used by drivers which power-off the system and powe=
r back on
> > > subsequent RTC alarms. This seems to suggest to remove "poweroff" fro=
m the
> > > property name and to choose "system-power-controller" as the more gen=
eric name.
> > > This patchs adds the required renaming changes and defines an helper =
function
> > > which is compatible with both properties, the old one prefixed by a v=
endor name
> > > and the new one without any prefix.
>=20
> > I think you still need to support poweroff-source since it has been
> > released on a stable kernel. Perhaps add a warning message telling users
> > it's deprecated and asking them to switch over to
> > system-power-controller ? Still, simply removing it isn't very nice.
>=20
> No, Romain sent a patch that replaced "<vendor>,system-power-controller"
> with "poweroff-source". It's now in Mark's tree (for v3.19), and this
> series "reverts" to the old name minus the vendor-prefix.

oh, so poweroff-source isn't in Linus' tree yet ? (/me goes grep)

Then it should be fine. My bad.

Many of the other comments are still valid because even though
poweroff-source isn't in mainline yet, this series still creates
bisection points which are broken. The best solution would be to drop
all those patches from Mark's tree. Read, not revert, drop.

--=20
balbi

--CxDuMX1Cv2n9FQfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnctAAoJEIaOsuA1yqREsJkQALJ3aXbosR8yYYtnJFpbgj95
vPH6TxKswvvyVXgqVXY4qhkO2iUVZVeFXO5HZmrBW7Xy9Sclr539L+df97s30rpG
4/HbvH/VS3QI5FB4ZLh5z+yvYQ3mBd2In/6jB6RQV4HC1xvnnfchC2bHtSuEoB88
Es4giJh/xgOst0eaMWfC+oo3pk8gjWXWGzi6O323I+2npzDv41IBNJpEdNErSSaW
lCRNTS6BhqyGNCDs41lti5ylLaDZaBecSR5WkYdw55yM2yuXyPlBtk1LnnN0+VVA
zijfIQ0WF7eU0MhATOeHmV3v5+jYSKAM0pHldqYCBwmp+ObeMxzP13UGGgfG/xqn
7gh00ZqJeXccC1gjRd/KWM0onyBvilqv5tZ1XRgvyLjdxf4z3dx6WoNjv+HoRc9y
e43iRbPx1C3nTK33E3XT9a83ZURDgMNZuYrxoeQyd17deL6OdolUzI5VocTHSO6T
cbaLwAo5mj+/Yplj0JgmZf1Fqg9gKK1WJOoJ2nR4Jt12hWqJSD4+twe46Y2KmHmh
cdiTYCBFrGP/9HU4AGRTfz4QE82WrBQQ8RLt4gHjISgbaFjtAszpxl0tTNkJ7hD3
cSfus/RtT9cV5tC/JSfz149IXmVZHvw+HRBYzBCU2v7CrTD+u6aa/FHX64bBOyP+
5Vd07CyjRSk5pYwy/FSe
=gpvh
-----END PGP SIGNATURE-----

--CxDuMX1Cv2n9FQfo--
