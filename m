Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab3BMOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:25:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57591 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab3BMOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:25:28 -0500
Date: Wed, 13 Feb 2013 15:25:22 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Murray <andrew.murray@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130213142521.GA6223@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
 <511949C7.7070604@gmail.com>
 <20130212064523.GA28850@avionic-0098.mockup.avionic-design.de>
 <511BA1E0.9000404@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <511BA1E0.9000404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:t1Ur/Ic95WBkLImwXGpXlH7TyrOZvETh3h4WYew7nNp
 DgAXRkHsgEIJfPlEvon3FxlP7aYm47f3zwAMfFPIM+QaRBWOqo
 4RVJ7iipIbUIxZ0Y+CsZyxStrR76oyc3j+ylqSSChRkve1nmxY
 70x1xEECPmwLUXE19UO9BHWzj/OWd5XnHZHXHfvpXpCTy3ycAi
 kKh+d+YS9e85HvyUfqEXfYY4pbYTjBPel0VIUsObpO2LkJ5CG0
 s2kekTdVsxW4yklzLf+uwQj68EwJQode1tIm/DdGlqiDq/IDtT
 ev0dhbxBAufwm8OK0xEH+Mv3/Rm+InrLj6l0pLSZwM5eQfjbg8
 AUzL8oEpD4irHz8vB1YT/OMfom6tpF4RYCPQ5QjjKGoNPPyXHQ
 zL+rjJSk9oCBTnAFJNZZNLYCruEQ8/mxKE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 13, 2013 at 08:23:28AM -0600, Rob Herring wrote:
> On 02/12/2013 12:45 AM, Thierry Reding wrote:
> > On Mon, Feb 11, 2013 at 01:43:03PM -0600, Rob Herring wrote:
> >> On 02/11/2013 02:22 AM, Thierry Reding wrote:
> >>> From: Andrew Murray <andrew.murray@arm.com>
>=20
> >>> @@ -13,6 +13,7 @@
> >>>  #define OF_CHECK_COUNTS(na, ns)	(OF_CHECK_ADDR_COUNT(na) && (ns) > 0)
> >>> =20
> >>>  static struct of_bus *of_match_bus(struct device_node *np);
> >>> +static struct of_bus *of_find_bus(const char *name);
> >>
> >> Can you move this function up to avoid the forward declaration.
> >=20
> > It needs to be defined after the of_busses structure, which is defined
> > below the CONFIG_PCI block where of_pci_process_ranges() is defined. I'd
> > have to move that one as well and add another #ifdef CONFIG_PCI section.
> > If you prefer that I can do that.
>=20
> Okay, it's fine as is.
>=20
> >>> +static struct of_bus *of_find_bus(const char *name)
> >>> +{
> >>> +	unsigned int i;
> >>> +
> >>> +	for (i =3D 0; i < ARRAY_SIZE(of_busses); i++)
> >>> +		if (strcmp(name, of_busses[i].name) =3D=3D 0)
> >>                                               ^
> >> space needed.
> >=20
> > I don't understand. Do you want the space to go between '.' and "name"?
>=20
> Must have been some dirt on my screen... Never mind.
>=20
> I'll apply these for 3.9.

Great, thanks!

Thierry

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRG6JRAAoJEN0jrNd/PrOhJYsQALAVVLz+8rPIJ79Ncz9y4hKj
lKG4wpOc+CAVCoiZ+XCOm/zZojDD05Ly9J8seCnP/ssOkgSv2G0c/Kf8MqieB1kK
mHn5x5lLWlCYJ31k1s9r39KnWYxptLzvd0mrvTi9ntD1ekA7bATsDBU/QUS0LUEY
8TmwNrOLPxCuEvHh6gandYObEkofCe9CSpunTjnxhn+J69UD9n7ycXn3zGBDyxBZ
2zVq2xKE0SG6HPpg6+NGWcRNxR/hLrbWHVZN1txDQp5TJBfyeXwsjonmh0s8iv77
4aae7guvqoN6OgUjlvpI2SDQOhH1iizD0cHXBm6VC5EGQ1X83mtjBB+dEbFA4eoK
CF6KrXPrYp9SvFnXfbrLna4/54UfJW/qQvMwn0jGMMqetKdy1SwsdBB7IpH5ue+m
qU2rflXqnjGeu1f7bet1/tJz3F2ODs9CR+rD8K0yrRxDOL/jUfPFLFe8ryy03L8c
K8QjziE4Vd7XxGIr23datbsSIRjoIFsJbvg63LsI7jG+Y8JAI2jjke3BndglXg+5
MhPpGi14McQf3B6tePThXdxQW9v4tfjI6V/BNiHSK2hpG+BWW5b0rc38YA2XSDoh
SRNetvVKcpcvVymXp7mAvTkWz6Wjwj0KkFIyKF81DQYkE0lOEJW3dEOtotFyjRds
EyWmvsh/X5kUbjRFEH5k
=7xLs
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
