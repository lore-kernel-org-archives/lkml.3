Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3BFTfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:35:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3BFTfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:35:37 -0500
Date: Wed, 6 Feb 2013 20:35:21 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-tegra@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/14] ARM: pci: Keep pci_common_init() around after init
Message-ID: <20130206193521.GA455@avionic-0098.mockup.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-7-git-send-email-thierry.reding@avionic-design.de>
 <20130205204147.GA29726@avionic-0098.mockup.avionic-design.de>
 <20130206163041.GG17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20130206163041.GG17833@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:bydOoAA2xZ+AIzCs8ZYh5e+QHoCJCTaSCkVJrXhM89q
 K7MIUs9AE7PamhVupo1czzagldp2htvRU/rz9eVLuYMxC4LHi0
 VYYnUaVUGG2CeQHjzJkV/ZLJcP4onuy7Z1IqGo3OeSMDgFpQSU
 +xrIvh0ty0uJPWVmpYSp00rRREXsL3T9pqdwu3Ekh4qKGoyZuI
 10lBqyE2MfiSdvnKZ3RH1VPs9cYx+R3ZYy+35ot9GuDaN5CoFU
 LUOsrnS99sZU3KZaNyOT7HpCIDmtVayvTdIifz5H37gHiIzvEE
 rSWl9MRyEfK4oHi6b2+4xLn7yMcblWs762kcAFuEsMyQlO7x5U
 20f6w+izh+tj+bKe5cLBpsQWUr3vbNOrF/Xo3Y9GOvbMhvFxds
 IovPTLt8KZSLpFd1U8rMsRfshANTigSrXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 04:30:41PM +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 05, 2013 at 09:41:48PM +0100, Thierry Reding wrote:
> > On Wed, Jan 09, 2013 at 09:43:06PM +0100, Thierry Reding wrote:
> > > When using deferred driver probing, PCI host controller drivers may
> > > actually require this function after the init stage.
> > >=20
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > ---
> > >  arch/arm/kernel/bios32.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > Russell,
> >=20
> > Can this patch and patch 7 (ARM: pci: Allow passing per-controller
> > private data) of this series be applied for 3.9? Thomas uses them in his
> > Marvell PCIe series as well and it would allow to reduce the complexity
> > of the dependencies.
>=20
> It'll need to go into the patch system in that case...

Alright, I'll submit them to the patch system. Thanks.

Thierry

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRErB5AAoJEN0jrNd/PrOhlQYP/274urM3pDA6Rp0viIJuGCB2
rClDIKcja8RxeRkJJ47MxIVo5HaXEXreMeptf6NYr2IBEacU0hAqadkq95BzWT0d
w/j/eDOmXgulhON+6nn7x7gCCZpZVzAnGVZFoiFdfa60gOwUZPk76wD6lBGXNtsL
1ocaEXhE3HvgTaGwQNAQi56+JVhPywSs56OHZk0LZiF9mCzA03POHZJzHYV2yLk4
6ZkfnDIfj6y54SNkL9vA5daCxipqPLmEERALSQTBh9nClUYwfz+Qb8LNzPJ4Jrsl
AMMwqOP3OgSADUquKgn3a8RoSvcSLwue/EvYXvaoXlHFxgBbp1kv4/czqwQrj9/U
37Pvi/Rm+NNfv4wocwFv4CHi1o4zBV3gT7VIDdhX2yXqw/El3pJpVMP1itjC6mwv
CvqZCiyiHoJ2QnQ+JeOZeSJxQAcTEHJXpgu/7hYDWDk/jjN+ATPZdTpNDXUgWJYU
IceYAvNniKWRmfjpHV/qaqyO3tbMrC6BoYOsk1PjECFOMWhevn8ISLp6AUjcQ2Fe
QcdP1wGVi1lNSWzYArngKGQ3+3ifK42+1hw5s07UMBG2QUtHO31fBjEXcq6KdbC3
reNP0igpRjgRRE9z5XOjCkkHdCiNoPrd7GTbyDtVqFZXF/cMcvU4g0x7J9uzoHBx
0RMBCojsf7zv2HLDGSRi
=WH1T
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
