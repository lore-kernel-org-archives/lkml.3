Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaG3NYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:24:02 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50737 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaG3NX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:23:58 -0400
Date: Wed, 30 Jul 2014 15:23:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140730132348.GM29590@ulmo>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730110425.GI12239@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JlJsEFsx9RQyiX4C"
Content-Disposition: inline
In-Reply-To: <20140730110425.GI12239@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JlJsEFsx9RQyiX4C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 12:04:25PM +0100, Will Deacon wrote:
> Hi all,
>=20
> On Fri, Jul 04, 2014 at 04:29:17PM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > This commit introduces a generic device tree binding for IOMMU devices.
> > Only a very minimal subset is described here, but it is enough to cover
> > the requirements of both the Exynos System MMU and Tegra SMMU as
> > discussed here:
> >=20
> >     https://lkml.org/lkml/2014/4/27/346
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Changes in v4:
> > - clarify that disabling an IOMMU DT node may not disable translation
> > - be more explicit that examples are only examples
> > - add multi-ID master example
> >=20
> > Changes in v3:
> > - use #iommu-cells instead of #address-cells/#size-cells
> > - drop optional iommu-names property
> >=20
> > Changes in v2:
> > - add notes about "dma-ranges" property (drop note from commit message)
> > - document priorities of "iommus" property vs. "dma-ranges" property
> > - drop #iommu-cells in favour of #address-cells and #size-cells
> > - remove multiple-master device example
> >=20
> >  Documentation/devicetree/bindings/iommu/iommu.txt | 172 ++++++++++++++=
++++++++
> >  1 file changed, 172 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
>=20
> I'm concerned that this patch hasn't been picked up for 3.17 (I can't see=
 it
> in -next). If we want to move the ARM SMMU driver over to this new bindin=
g,
> we can't keep dragging our feet for much longer as I *really* don't plan =
to
> support two bindings in parallel (one is complicated enough already).
>=20
> Any chance we can see this merged, please?

I think there weren't any comments left for me to address and I've
mostly been waiting for Joerg to pick it up.

Joerg, can you take this through the iommu tree for 3.17? Will acked
this, but perhaps you were waiting for an ACK from the device tree
bindings maintainers?

Will, perhaps you can get Pawel or Mark to look at this?

Arnd, I'm sure if we had your Acked-by that would go a long way too.

Thierry

--JlJsEFsx9RQyiX4C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2PHkAAoJEN0jrNd/PrOhEXsP/1njba0aCMArPnhItjmpLgVN
G3sMtFCbgOSD0tM1mGDkyMyEv3k/RxeuxKISGUAvjRkod+0YkDYpUlxIDZEdHo35
cDRBXNDjaNn9dLuwJnXaaohieMQi3esaVJ3/32T/DVu9QdQP60Vmxmd+DQEcw/XF
0rpUEMsAWT+2FhXDXyjgmdM+LZQsJkoe+Mt3Gb8qXio2yq9XdbWQjWvhT8XE8lHM
m1FXrl9bxBIj9Z4zqskvBdlJRrmRkYJ3rAvAITuO4rD9T9bbHPx/jrWO+aGVApYU
ptzgtg6t0341Mu+FK8MNSh9N0GV7X4CfQn/CMYdebs/0dpcusOuXa0uc4DuuCgmJ
hJK5tAAPvF8WhrJYino2ry7r2T8cVGsNuUAMsfB4U2pZXiVOlzww9oEG9vyEz+0N
5UCz7sl50cLP/raEXw0GgB4IJkVqTjqANfPtIBvkXweMjkxXM6TlrdW1Os6j/Zxf
v7qwx9jRmDRdM1aUVkz0biSOZ+cvlBVWxPY+fUFdbGOV8b/6KehsfCbsAsq6CRl7
uXqhT5fB7Q36sNKGtgAXYWjqkFt2KY2jYx2RTABQ0R3tFwowfDAXMrif7SJWsrO4
7a3KXaKoKdtfN6nzpSP8IuC5XboNvGXuoHXMMuP+MBcCsnMxzP+PVjogScxiOv8c
COjKVqLqrX2DnhplB9KC
=i/nQ
-----END PGP SIGNATURE-----

--JlJsEFsx9RQyiX4C--
