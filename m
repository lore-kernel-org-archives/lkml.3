Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaGNGPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:15:49 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52835 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaGNGPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:15:39 -0400
Date: Mon, 14 Jul 2014 08:15:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Clark <robdclark@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joerg Roedel <joro@8bytes.org>,
        Olav Haugan <ohaugan@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140714061532.GB2081@ulmo>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140712093917.GD18601@arm.com>
 <CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
 <201407121422.02078.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <201407121422.02078.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2014 at 02:22:01PM +0200, Arnd Bergmann wrote:
> On Saturday 12 July 2014, Rob Clark wrote:
> > >> Was there actually a good reason for having the device link to the
> > >> iommu rather than the other way around?  How much would people hate =
it
> > >> if I just ignore the generic bindings and use something that works f=
or
> > >> me instead.  I mean, it isn't exactly like there is going to be .dts
> > >> re-use across different SoC's..  and at least with current IOMMU API
> > >> some sort of of_get_named_iommu() API doesn't really make sense.
> > >
> > > The thing is, if you end up ignoring the generic binding then we have=
 two
> > > IOMMUs using the same (ARM SMMU) binding and it begs the question as =
to
> > > which is the more generic! I know we're keen to get this merged, but =
merging
> > > something that people won't use and calling it generic doesn't seem i=
deal
> > > either. We do, however, desperately need a generic binding.
> >=20
> > yeah, ignoring the generic binding is not my first choice.  I'd rather
> > have something that works well for everyone.  But I wasn't really sure
> > if the current proposal was arbitrary, or if there are some
> > conflicting requirements between different platforms.
>=20
> The common case that needs to be simple is attaching one (master) device
> to an IOMMU using the shared global context for the purposes of implement=
ing
> the dma-mapping API.
>=20
> The way that Thierry's binding does that is the obvious solution to this,
> and it mirrors what we do in practically every other subsystem.

That wasn't really the intention, though. We shouldn't be designing
bindings to work well in one use-case or another. My motivation for
doing it this way was that I think it naturally models the flow of
master IDs. They originate within the masters and flow towards the
IOMMU device. In other words, they are a property of the masters so
quite literally should be described in the device tree nodes of the
masters.

Thierry

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw3WEAAoJEN0jrNd/PrOhHGAP/AzH2L/CVL+Uf3BzQaRUACjI
RcOA/2w0xGFby9hK6W5ICP/ydx4lU5DR8leHItL4EEVG+ajBtF16zjcDVNwLksoS
55xd19mF5rq5FeBiKtNiUGPElaMGGJZA+RpXHmDjl17CZtCCmlhlLqte2+eoHykf
ajbXRqdsdcpSpoUUpLsynfgGd8jSzbizLsPj37oo/kcX9b7SRU5OFpwsJMvrABNB
TYAhrK/GLCsX9uJnlmHLaFOtYsqgcY+xqSIe4cFfIL6s1xNKTRUtL1tCYHcMEgQE
vq5JxxElmwHi889N2B5so1WDqFM0HPM84ghOfZAOiZAKzmlzoGHAb1g1Ji4cGhUK
3ExzQSI2i0/FQ44DjlKklX0HZ2IF5jc5HfDACdpFcnQBIJiWhAhnWiW8zFZg9QuW
DzGBmzqMeWStriARF5ccJg4MFZIDsg95vBQ4Fv8FbdNL5Gte1RrJF0mplMOjSnnd
GswtGX+Jv6tpG7xXV00jZATim6bhek89qJUoPasKjkPXGQh10fro59/tVk32KEi5
O2hA+fFiu9/ry/Mtsg5RlhFimJSF1Vlj6VoOAJ5Kul467BHPZngg5JxI/t9kNXi3
Kc7zwekrBgTAZYBiov3njJx3NDUo6/BZE1SrCgCz+JLYRpSpVRPXXhuHVP8OXRa+
btZucwSpMRFnyQcoPswy
=L72K
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
