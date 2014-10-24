Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaJXPan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:30:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50105 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbaJXPak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:30:40 -0400
Date: Fri, 24 Oct 2014 10:30:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/16] usb: dwc3: add support for AMD NL SoC
Message-ID: <20141024153017.GG26941@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <20141017151026.GN26260@saruman>
 <20141020153822.GF24357@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
Content-Disposition: inline
In-Reply-To: <20141020153822.GF24357@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 11:38:23PM +0800, Huang Rui wrote:
> On Fri, Oct 17, 2014 at 10:10:26AM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Oct 17, 2014 at 04:53:25PM +0800, Huang Rui wrote:
> > > The series of patches add AMD NL SoC support for DesignWare USB3 OTG
> > > IP with PCI bus glue layer. This controller supported hibernation, LPM
> > > erratum and used the 2.80a IP version and amd own phy. Current
> > > implementation support both simulation and SoC platform. And already
> > > tested with gadget zero and msc tool.  It works well on file storage
> > > gadget.
> >=20
> > patches look much, much nicer there are still a few things to fix. A
> > global set of issues which I see:
> >=20
> > 1) Let's get confirmation that all those quirks will be needed in
> > production as well, I have a feeling quite a few of them won't be.
> >=20
> > 2) All quirks should become 1-bit fields insteads of single-bits on a
> > 32-bit variable.
> >=20
> > 3) All quirks should have DeviceTree counterparts. They should all
> > become boolean properties should we can:
> >=20
> > 	dwc->tx_deemphasis_quirk =3D of_property_read_bool(node,
> > 		"snps,tx_deemphasis_quirk");
> >=20
>=20
> Thanks to summarize them. Will update in V3.

hey, no problem.

> > > These patches are generated on balbi/testing/next
> > >=20
> > > Changes from v1 -> v2
> > > - remove dual role function temporarily
> > > - add pci quirk to avoid to bind with xhci driver
> > > - distinguish between simulation board and soc
> > > - break down all the special quirks
> > >=20
> > >=20
> > > Patch 1:
> > > - add PCI device id into pci bus glue
> >=20
> > this guy should be the last in the series, with all AMD quirks being
> > enabled at once. This will avoid bisection points where AMD's platforms
> > don't work.
> >=20
>=20
> So all the AMD special configuration and device id should be in one
> patch, right?

correct :-)

--=20
balbi

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSnCJAAoJEIaOsuA1yqREvaoP/0FM+lLi3r5SnXjR0GWdfYqW
SAFTFp0+Uq+LuRGJx5j+bvjSA+4R/F3GGNyvMuOSSI2Q1LlJ6rm41BxvvqOvrm5B
DuDBu01ZhC0BFGo3qYOUbpDWTXArwdeVDf8JQ+7iiTnnPx+89meSJuumYUOJcbkU
SeaSTCWH5z8VfajHKImNO4hoVyHRvwx/XeSRZHi0/Cqr13GPW3wkI0nxcld/MNt9
H+y89+WvHBd058IpGPjGYq22jJeg1G9FB5K8vT93Qhh/d7FvOTHRIPFL83ISmN/9
XpbMxlGsm100+Re64DUqQ44ErGT2cNbdycrR7Twd4spbWInRHGLOOqtwfdfaBl6s
z4IFRkaW3KoTEuXnu1s1XB0ayf0dtl5dIPWSZbxDXSz9O6uiAV+lNMFt3XxKgcYb
b6LK2m6SGmb/TTd+mhhu7IOckWuEcryl7d5esPqAf2DCqGVK1jRTyHlFfgYhW23k
jvV5YtphWkPEcuNkK+W0j/sVYVkS6BtbvOgRyDScC7ks9lS1v/cnl3UATUJmmoTd
hHgOJtqBuluMYjx9DBEsrKsCbi4KpQm1xmZg85G1rXshmS8ytBqeZH1Rp9LGtAih
UXtAOniEDj2eY34QdYhWPwGXyylq2wI58A4DRBr3YZxndl0HMR8ZhWjjSzvb88yy
+XdGUHLbeXDj16v9NRKy
=hpVq
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
