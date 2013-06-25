Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3FYNIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:08:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34957 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab3FYNH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:07:59 -0400
Date: Tue, 25 Jun 2013 16:07:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <balbi@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-arm@vger.kernel.org>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Message-ID: <20130625130749.GD20439@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
 <20130625111234.GJ15407@arwen.pp.htv.fi>
 <1372161370.18889.13.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zbGR4y+acU1DwHSi"
Content-Disposition: inline
In-Reply-To: <1372161370.18889.13.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 02:56:10PM +0300, Luciano Coelho wrote:
> On Tue, 2013-06-25 at 14:12 +0300, Felipe Balbi wrote:
> > On Tue, Jun 25, 2013 at 11:35:30AM +0300, Luciano Coelho wrote:
> > > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> > > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> > > +  following:
> > > +	0 =3D 19.200 MHz
> > > +	1 =3D 26.000 MHz
> > > +	2 =3D 38.400 MHz
> > > +	3 =3D 52.000 MHz
> > > +	4 =3D 16.368 MHz
> > > +	5 =3D 32.736 MHz
> > > +	6 =3D 16.800 MHz
> > > +	7 =3D 33.600 MHz
> >=20
> > DTS files are pre-processed, so you could add defines in a header and
> > share the header between DTS and driver. Could help you having:
> >=20
> > tcxoclock =3D WILINK_19_200MHz;
> >=20
> > instead of
> >=20
> > tcxoclock =3D 0;
>=20
> I don't see any .dts file really doing this.  There are some imx*.dtsi
> files that include imx*.h files, but I don't see these headers being
> included in any source code file.
>=20
> In fact, we already have all these values defined in
> include/linux/wl12xx.h, so it could be nice to reuse.  But the
> cross-directory includes would look "funny".  And I think it's a bit
> overkill.
>=20
> These values are actually used by the firmware itself, not only the
> driver, so they are also platform independent and not related to the OS.

fair enough, then there's no chance they'll change all of a sudden.

--=20
balbi

--zbGR4y+acU1DwHSi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyZYlAAoJEIaOsuA1yqREXv4QAJQRZgQEp8AuANEzstQimGI/
ck4ADV8V68nQMGI54PZJU31+rahn7sqp28rHGpQyp7K1AS3cZcDSsF45JgMb/7fx
qWwIh4wUiw+Tfv0VwrSmRAMaDMcyrtA8lo80YFn4N2j2BL4OCfy+cF9H88cp87ow
m/2WUrH9THWX1l3dhwzIZKY/IFo1wfaaxis8oQNCmESrTrVPCzT3Og0qsd5EqcI+
nGSuidU7tOVDEZCLZVWtQKTUOeaxUxWNYAG6J8OfYz/RUtkzl1sNPsvLbM0mCkad
DLasnzyJuC9LMhwnQpXxge6nkUvxmdFiTo4kdPqJ+U6PBtzsMC3XKmkvl7tVRx6D
OdbCMcQK0jzjZB2K5sTsMGUQLDyp3UdqLcuQZFpDu4RV0Px4vAnKFEfr+M+i28NF
DTPrzljtRuBUCJ7eHdyQZf4H3r2m0ai5mpbJW3ZG81is78QNwxG+GDItmltFmCnt
yBppoNV7f7Uy8VbknMMHXvMRk9WHfce6S9hlnuEebU3YhP0du3iGtrVFOWdM8MtQ
OszkpMQ1ue7LzKa/G31gQc+9Zq5tE40HkSboz5LVlfa9c2mKoI+yF9tXflrS8Yy+
9OT5uiHiKZ86u7rQmat8yAWrb5+pXAxO6jWyXNW0EGExdCBT+v+EpL4L+URX2Qgi
elgfMVdYh1R1K5aAvjMN
=9n0b
-----END PGP SIGNATURE-----

--zbGR4y+acU1DwHSi--
