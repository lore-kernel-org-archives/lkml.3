Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaCFP6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:58:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59934 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbaCFP6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:58:20 -0500
Date: Thu, 6 Mar 2014 09:56:14 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <balbi@ti.com>,
        <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2 01/13] phy: rename struct omap_control_usb to struct
 omap_control_phy
Message-ID: <20140306155614.GD25648@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394116729-28811-1-git-send-email-rogerq@ti.com>
 <1394116729-28811-2-git-send-email-rogerq@ti.com>
 <53189654.2090406@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tEFtbjk+mNEviIIX"
Content-Disposition: inline
In-Reply-To: <53189654.2090406@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tEFtbjk+mNEviIIX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 09:07:56PM +0530, Kishon Vijay Abraham I wrote:
> Felipe,
>=20
> On Thursday 06 March 2014 08:08 PM, Roger Quadros wrote:
> >From: Kishon Vijay Abraham I <kishon@ti.com>
> >
> >Rename struct omap_control_usb to struct omap_control_phy since it can
> >be used to control PHY of USB, SATA and PCIE. Also move the driver and
> >include files under *phy* and made the corresponding changes in the users
> >of phy-omap-control.
> >
> >Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >Signed-off-by: Roger Quadros <rogerq@ti.com>
> >---
> >  drivers/phy/Kconfig                                |  14 +-
> >  drivers/phy/Makefile                               |   1 +
> >  drivers/{usb =3D> }/phy/phy-omap-control.c           | 165 +++++++++++=
----------
> >  drivers/phy/phy-omap-usb2.c                        |   8 +-
> >  drivers/phy/phy-ti-pipe3.c                         |   8 +-
> >  drivers/usb/musb/omap2430.c                        |   2 +-
> >  drivers/usb/phy/Kconfig                            |  10 --
> >  drivers/usb/phy/Makefile                           |   1 -
>=20
> Hope you are fine with the changes in drivers/usb/? Can you give your
> Acked-by?

sure thing:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--tEFtbjk+mNEviIIX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTGJqeAAoJEIaOsuA1yqREn48QAIXCg8WaOfQIUWKgGt7b3R07
o4Tfx9oMFsrsV9THpNcwj10AJ4eZvlV9ttfn7FOrzSq2Gyri9SYtnYZ9hlad5JqL
ReFkejQGlnOxKY7pIFVjAny+hXRZ/fupUmRqasbPW03OvZN2Rmf0afcE1vIAMdlH
NS0Q4L8Hsd4nrxRweADeuSZWcsBsRxKLScmO5HFTajJWg+CGLjkmJtelhqzhkkOX
5o0h3AbBdUw/uDcYfhhE/EEFwqJO4B39nTkFH4dEn33HmJx666nzdNh9zeGbO6Rd
ENgD9s5g2Bc52FbnsyqdoquxjrUjSJFlkjowR6kl79Z+oFYkaAD3q71BLhHnk20p
8qHbcVrfdYFHo3SuDZ+28YWyBQuGQYP8vAlUo2mG9tKIYgAOiQqnGJpATskB+Xm1
jaDj8CwX8839JPB5SmfwfF8AJ9RHWE+tkHh6r9sNq6oFSYq6bKhWc+W9zx7R2Vzh
zR7O5CpD/Vjpali9JS6Rztt+02/+mROuzp9DMYekBLti9slJPTp6TFRo0beZFwZA
4qDzVm+uE6AWd068EecmGKAQNMWkl36ZkdtIhMOvXF5AHiodu1CSbTHh6UA9ONLg
fpO5pAJ06dizHHaP+dQ7T12VLBBFatNOe4BapYs7EvFS1rLrA29vsDfY0llKYZsF
4bijYWmWWWa6if2zrVZA
=V/iF
-----END PGP SIGNATURE-----

--tEFtbjk+mNEviIIX--
