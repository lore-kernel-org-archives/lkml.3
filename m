Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab3FRKCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:02:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43975 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab3FRKCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:02:21 -0400
Date: Tue, 18 Jun 2013 13:00:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 2/9] usb: phy: omap-usb2: use the new generic PHY
 framework
Message-ID: <20130618100014.GD5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-3-git-send-email-kishon@ti.com>
 <20130618094058.GQ5461@arwen.pp.htv.fi>
 <51C02D0F.6010302@ti.com>
 <20130618095040.GZ5461@arwen.pp.htv.fi>
 <51C02EC7.7060908@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ViWwB84N1zFtNiVD"
Content-Disposition: inline
In-Reply-To: <51C02EC7.7060908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ViWwB84N1zFtNiVD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 03:26:23PM +0530, Kishon Vijay Abraham I wrote:
> >>>On Thu, Jun 13, 2013 at 02:13:52PM +0530, Kishon Vijay Abraham I wrote:
> >>>>@@ -159,6 +191,12 @@ static int omap_usb2_probe(struct platform_devic=
e *pdev)
> >>>>  	otg->start_srp		=3D omap_usb_start_srp;
> >>>>  	otg->phy		=3D &phy->phy;
> >>>>
> >>>>+	pm_runtime_enable(phy->dev);
> >>>
> >>>enabling pm_runtime here has the potential to cause a real big problem.
> >>>How have you tested this patch ?
> >>
> >>performed boot and enumeration testing. What issue do you expect here?
> >
> >hint: look at drvdata usage around the driver. Where is it initialized ?
> >Where is it used ?
>=20
> hmm.. since runtime_get calls weren't made very early, I think I dint
> see any issues. Thanks for pointing this.

right, no problem. BTW, you don't get to_platform_device() ->
platform_get_drvdata(). A simple dev_get_drvdata() is sufficient :-)

--=20
balbi

--ViWwB84N1zFtNiVD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwC+uAAoJEIaOsuA1yqRE4wYP/3cA1ypKeVPmu+0YO3soxwUj
DLxXtzi1oM/jQN1dxA08+HfWZuV/3pK3NWfhRNinuV66VKWLUV1FP+tnTgFuzSEd
+2u6KU+0z4p73T3FWcMOeMiSOADgNE/ak1sl6DZU85PAc8gs/STh9IRkYiUA/miF
FrCWA7VT5kqktDDZAL/K6ICA2W9cJqyCTZRUhl9T/vGXD/fUdLeo5wCadAP3nIuG
5mWJAZ+UDtHMeGkKye/2R3cOEzsbLsHmmvxNd4DSqJGe7Is4yvk3UI6RFnlhidgK
2zRY1ONwpOUDQB3KzF7CNTwXnrztkS8VRha2YD1C00YYnw1V3daWFFGqC5x9sFnQ
MFa9jRvw0euQy7t/5X6kuds9dYAZdS2h7bHMQmh6W3EwZqdLLl4h8HhETXUlyKSZ
hg5oM7Qhlmoez0Kpv57kGxmCyaGPXr94SluKmYIn5HN91wve9nKS0bQxNhfik7IU
ZXJ3YgqkkZoooRgoHm8BjniwnUDFQi7xwRY+5Oi8NlBvOPQwRERJnUJKHGA9gv3U
ZZ6jL6pnbGd9ckcAcdZd6MFZRbXDXG+9xSP9QWIrDZA/cULM3WjqjNhUoJlAQfch
J2vALVdIFZtO6l6nLMBd6QWBhXpDE7v81nnjZxg0pEZYVUO1gmt29382PYD/ICES
19vi1Sf62+PJusdyKuH7
=yPC/
-----END PGP SIGNATURE-----

--ViWwB84N1zFtNiVD--
