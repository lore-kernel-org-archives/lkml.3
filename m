Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3G2Hb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:31:28 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46272 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752861Ab3G2Hb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:31:26 -0400
Date: Mon, 29 Jul 2013 09:31:23 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Arend van Spriel <arend@broadcom.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130729073123.GB1441@lukather>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1441731.8CGUI1tUxh@flatron>
 <20130728085650.GA4683@netboy>
 <1416484.XDfk5G56BI@flatron>
 <20130728131901.GA8864@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20130728131901.GA8864@netboy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jul 28, 2013 at 03:19:03PM +0200, Richard Cochran wrote:
> On Sun, Jul 28, 2013 at 11:12:53AM +0200, Tomasz Figa wrote:
>=20
> > I'm not really sure what effect on users this has. Maybe you should def=
ine=20
> > "users".
>=20
> ...
>=20
> > Care to explain this reasoning?
>=20
> Use Case
> ~~~~~~~~
>=20
> User acquires a machine running ARM Linux version 3.x, with u-boot
> and dtb in a read only flash partition. The board boots and works just
> fine. However, for his application, the user requires a new kernel
> feature that appeared in version 3.y where y > x. He compiles the new
> kernel, and it also works.

I'm afraid this kind of use case will never be properly supported, DT
stable ABI or not.

Think about this: what kernel will actually be shipped in that board?
Most likely, it will be a BSP kernel from the vendor. Does the vendor
will have made that commitment to have a stable ABI for the DT? Will it
use the same bindings than mainline? Do we want to support all the crazy
bindings every vendor will come up with?

I'm afraid the answer to these three questions will most of the time be
"no.".

That doesn't mean we shouldn't aim for *mainline* having a stable DT
ABI, but that kind of use case doesn't seem very realistic to me.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9hpLAAoJEBx+YmzsjxAgFBIP/2DfiQyJXDnvqyXEgO3yzLzO
gRFRGAK+4XzmBmWFkSu0UYm6P1Oe3kcJhn3lsW4GyiT5iQiKl86+dRCfGH/Zn88k
8EtM+EwObDvShBpdjcEFd42hgTr0STn1vX+rW8T8jct3TNW40c2FCy8v5XoFbpIC
Od+SRnPpe6SWC/M0X/C34WFSKgvY4ywp7cAbWX2DLjEB8qqms1IxD0dZQJsFDLLC
mgPC3UdJCHCnwcaixIkYQbkMpIe4QXGW5eZ1KecHBsjmFgNLZjIZtOhguWpCxqBY
+oAoJTdMfA4SyJ0MhUwPVid4WnLpUGATN68KaneFR50VnE9V41tBAZYZw616K+Li
jHs8itaRS7rRDs32T2p27wZ0gPhnbzizazNfm6+dCgHlIceZkuQw6l6gUyOhSqcE
MXGhd6OfK0GabBvSId8PtbovZ0+Nsg803rx6kIzjFmeB8hmcz3D1eHtuXxzp+V4u
Iz6Xra7Ugnm2rKamxZm+/yUmslUi7te7LhmGE4Cc7Vw81+0LSHkGk8tw5D96Bbux
Vjnn1EVvOu3pY+4Ia5f80QRBaWwhotS4RelGqqWMuIwM4BCgPt3t4WkWHI65kTBW
YUsNl67du+iShyvJuFVgMqXWumY4kB7WmCmrd+UHfLrSEX4XOKMp7p1+whQTj3MC
NuI164D4ColZiyBR9ZnO
=P2Cy
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
