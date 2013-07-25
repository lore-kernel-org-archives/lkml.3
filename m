Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3GYOzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:55:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53784 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab3GYOzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:55:01 -0400
Date: Thu, 25 Jul 2013 17:54:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <george.cherian@ti.com>
Subject: Re: [PATCH 02/16] usb: phy: phy-nop: add support for am335x PHY
Message-ID: <20130725145454.GL16106@radagast>
Reply-To: <balbi@ti.com>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-3-git-send-email-bigeasy@linutronix.de>
 <20130725143330.GK16106@radagast>
 <20130725144529.GB5412@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JKGvNdIvrY8Ovf7Z"
Content-Disposition: inline
In-Reply-To: <20130725144529.GB5412@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JKGvNdIvrY8Ovf7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2013 at 04:45:29PM +0200, Sebastian Andrzej Siewior wrote:
> * Felipe Balbi | 2013-07-25 17:33:30 [+0300]:
>=20
> >On Mon, Jul 22, 2013 at 08:09:53PM +0200, Sebastian Andrzej Siewior wrot=
e:
> >right, I replied to the wrong series, please add a patch renaming file
> >and functions to phy-generic.c/usb_phy_gen_
>=20
> Sorry, I can't parse that.
> You want to rename phy-nop.c to phy-generic.c and add the additional
> functions in usb_phy_gen.c?

$ git mv drivers/usb/phy/phy-nop.c drivers/usb/phy/phy-generic.c
$ sed -i 's/\<nop_/usb_phy_gen_/g' drivers/usb/phy/phy-generic.c

--=20
balbi

--JKGvNdIvrY8Ovf7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8Tw+AAoJEIaOsuA1yqREEPwQALTE0hXrLO2vvcUoHTdfoPOO
HwEfNUhy7K8zrRkrRVFaF0TzASUxxRhBBL3tvz79eUY1bKyBJaoBlJYQlga5uev9
Jo3pOH+o4OYad7Q/z2eo0CFQfQEJ5qp5+Sh1Hws5dAvH11RzdOEMrheDIYpO3bwL
28/uDu+vYbGPVC7GR4e3dNMpKvI2YJvCxolgTui36UVko2XY9RDOLXpXQBXk4pJx
Orh2yiAtHO4568rMkFw+9LUml4veZM1Don8obEGPCknsGHbDPd7VXZUaCGP4hbmU
2Bj7zN9xV5YhTmk80AAZELLtonCAMh+SaUnfPex9um0voEjkwRzpGfCp5xcbqhBg
KN+9pCWCFzIByKS6iV8OxzldQ3CXP3ydx7Y6oj1eOj+37ETqXLM2U/OSb5uGo3x1
0/VCxf6Vvos8Gxw8FeqPvDzQVvWTyfL9k1ywIXDSmndv9vMsOL7U3YlhqpvKuoXy
e0WEaBI5ediB9PKofaR+pwkhRSNkIh7QwKyrOB+NuIf1EgllmVEM7rLIIspA7OPC
zwXvcHyL3sLhGM06K2bxHwY866qLa/X0+WjLBUfugbbOn3FJgZwX+yNOhANKt2LH
bvQgWelf92Fg+DTujhFyQG+V3O33MIVsnlh5nCVwyNjWEWQw1pdd3JEJP11cq97V
38Rhy8+PBwub7r3DmQPN
=8gGV
-----END PGP SIGNATURE-----

--JKGvNdIvrY8Ovf7Z--
