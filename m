Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3IQP57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:57:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44413 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3IQP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:57:57 -0400
Date: Tue, 17 Sep 2013 10:56:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tomasz Figa <t.figa@samsung.com>
CC: <balbi@ti.com>, Julius Werner <jwerner@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register
 handling
Message-ID: <20130917155648.GN15645@radagast>
Reply-To: <balbi@ti.com>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
 <CAODwPW8KG2ZxOFf936H233g35KVPjDp+f8e3qgkd4Z7NN9RAtQ@mail.gmail.com>
 <20130917153616.GG15645@radagast>
 <2133285.Y3nsFRsUq0@amdc1227>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUrluEZVXmx7ezWQ"
Content-Disposition: inline
In-Reply-To: <2133285.Y3nsFRsUq0@amdc1227>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CUrluEZVXmx7ezWQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2013 at 05:53:31PM +0200, Tomasz Figa wrote:
> Hi Felipe,
>=20
> On Tuesday 17 of September 2013 10:36:16 Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Aug 27, 2013 at 01:27:48PM -0700, Julius Werner wrote:
> > > *Ping!*
> > >=20
> > > Are there still unanswered concerns left with this patch? I hope my
> > > prior mails could clear up why I think that the PMU register
> > > description in the device tree for a specific PHY is represents the
> > > hardware more accurately after my patch, and my analysis of the
> > > Exynos4 situation currently not being implemented (and therefore not
> > > needing to be addressed by this patch) was correct. Please let me know
> > > if you have further objections... and if not, could we agree to have
> > > this picked up somewhere?
> >=20
> > I need acks for DTS part...
>=20
> This patch breaks Exynos 4, so it's a NAK from me.
>=20
> Anyway, a new, completely redesigned PHY driver supporting most of the PH=
Y=20
> features (as opposed to only the basic subset currently) developed by Kam=
il=20
> Debski should show up soon, so I don't think there is any reason to apply=
=20
> any patches to this old driver.

awesome, then I espect to see a patch deleting the old driver shortly
:-)

cheers

--=20
balbi

--CUrluEZVXmx7ezWQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHu+AAoJEIaOsuA1yqREXOIP/it9cJA/Tt+XMDMF5hGv6RoP
VTjiJl15j7XSF45cgzD/8GD4Mv+vOUqqv44x0mppYR09Bvh/dcpvbBBDDLh4iiS9
qd4BmxmRFHsZjft8cgdoudfritSaObDNIgelMlJkNv7iu5vlj1FzQICtRysZYx8h
aXSzwlCgHcGfXcTXx6qiejZd8lvxRCBK1g+liTqCYbbbtaxuh04glMMamwAcCSh0
f3my8J0buHZTpoUKUa7zf/KLXx5N0XnmQ3ej1x5iX2zMBkvOx3+NYPelAL9X9AFv
8sWZWUACVMI+JDVC93IvLWHKgo/RZGgDWZBw6xussWDt0cSRdDLUPXqLLa/Hj3kq
O5pV/5Ak9pLiLu8I3K5D0J1Qt+M22VVGJjpDruf5LNd6GuoYCtr8FEvxNHeMXQIt
W+qgt3Ny40SkNCgvnuLcQKH6v2ZVSxnll+0ghSgaoty74aYZjTDEZAtbZ6cNI2AD
Hpp+2rkvnaZaduaH/hNmApFMpCaCiJ2lKgDMz6WHSQPY9wqhu1ZJVSvJL0zCbueY
lhfXYlUV00LpALQ7AoBfF1gfocRdIfYUNxkUTyJ6aeo55wPTfOKMWGUGz+CKqypU
oTZ/DN6KOGfir0oeVJq74y1cOMQ2bI/FEbRXpTDN1XE0KkPW1nnfqPX3oW6G++yR
ig9mj3hSMGgEv7juRZ9G
=Zb+P
-----END PGP SIGNATURE-----

--CUrluEZVXmx7ezWQ--
