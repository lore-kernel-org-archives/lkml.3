Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3CDPDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:03:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39283 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758154Ab3CDPDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:03:22 -0500
Date: Mon, 4 Mar 2013 17:02:52 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Vivek Gautam <gautamvivek1987@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, kishon <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt
 node.
Message-ID: <20130304150252.GP3397@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
 <510A56BF.3040804@ti.com>
 <CAFp+6iFkb=U0CJA=3zmQvd5XfMwbROuRJjXoJG7zvvq4_upzNw@mail.gmail.com>
 <20130131152527.GE4064@arwen.pp.htv.fi>
 <CAFp+6iHvKYiF_neANRq5roAEJwhvcaLk7pAd7Dy94Z5XiDkhgA@mail.gmail.com>
 <20130131153836.GF4064@arwen.pp.htv.fi>
 <CAFp+6iGTqZY=+crcYyu9o5uEP9Nv2=haSqB+nCuqA2_iUand6A@mail.gmail.com>
 <20130301064129.GF3120@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SlnaBQtdWG0gYnqZ"
Content-Disposition: inline
In-Reply-To: <20130301064129.GF3120@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SlnaBQtdWG0gYnqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 01, 2013 at 08:41:29AM +0200, Felipe Balbi wrote:
> > >> >> >> Moreover, SoCs having multiple dwc3 controllers will have mult=
iple
> > >> >> >> PHYs, which eventually be added using usb_add_phy_dev(), and n=
ot
> > >> >> >> using usb_add_phy(). So each dwc3 controller won't be able to
> > >> >> >> get PHYs by simply calling devm_usb_get_phy() also.
> > >> >> >
> > >> >> > No. We have added usb_get_phy_dev() for that purpose in the cas=
e of non-dt.
> > >> >> > I think, instead you can have a patch to use devm_usb_get_phy_d=
ev() here and
> > >> >> > in exynos platform specific code use usb_bind_phy() to bind the=
 phy and
> > >> >> > controller till you change it to dt.
> > >> >> >
> > >> >>
> > >> >> We have dt support for dwc3-exynos, in such case we should go ahe=
ad with
> > >> >> of_platform_populate(), right ?
> > >> >> But if when i use of_platform_populate() i will not be able to set
> > >> >> dma_mask to dwc3->dev. :-(
> > >> >
> > >> > do you have a special need for dma_mask because OF already sets it.
> > >> >
> > >> If i am not wrong of_platform_device_create_pdata() will set
> > >> "dev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32)"
> > >> and not dma_mask.
> > >> I fact we had some discussion sometime back when we needed the same
> > >> for dwc3-exynos in the thread:
> > >> [PATCH v2 1/2] USB: dwc3-exynos: Add support for device tree
> > >>
> > >> But couldn't get final node on it.
> > >> So suggestions here please. :-)
> > >
> > > hmm.. you're right there. Grant, Rob ? Any hints ?
> > >
> >=20
> > Any suggestions on this ?
>=20
> anyone ?

ping ?

--=20
balbi

--SlnaBQtdWG0gYnqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNLecAAoJEIaOsuA1yqRElskP/0tbqXGQqNSsaboaaLXCEKL/
wOdn6btvDw32bniDijHphIGrw/zwouf2Jsqh8R1Be7ai6xUfqugy1Z097Qo8AlNa
Ig8QxVSTPonqsTVZjGqHfucbH2sFkS951TdVTV4vGN0P0Ml7h3YhTg4bMfjXoFe/
DYzDzmuOOPC5msfN6dOpaFq+8rJo3vsZSi6yQ5+ijLCCy5S7ucSGfQ/J8d2zK+Cv
wSwlje2QRKRuSg/zL8xZxxFGXdJfoL1MVQIrZctWXjUrdxJ7etXqGgHKpbRdfGP2
e4DGqsG34JmvxgKjmu3QXSejJjkIy0eXFR3Ai+r0sHo1zLtnh0wvlpNT0tEhkwgB
Q3kzfL3FZIMXDItvS3zDp1JR3oAEViWWgKxINKEqjZJXdtYN0IQLlSB/kwQU8K26
++Fbae1Wgwoft5lNvRv/Lr9HmZwcRIObxMM+Am6s8sNFxusqHJhrTfhgKxsfciLG
EKsW2synQjaZHfPvShwLe1DgCRt6S/WcF7DgJfa6f9WSOTo5dArNJ3Pz7WqVym0f
Wi16IwOL+OAM/PYbkoOPcdAwWFPhZZJqDJ7iMa4g9t9oFl/NF9I4Jm2TfviYGmlC
iEc0pVz1D4FVBQ+kyRIsUzL5B3fxdC4ItXdyBlLa2D3PURiMaGWHehAZrdPCT4Fy
nsnjPQbl/kROIsbPfeqD
=CM64
-----END PGP SIGNATURE-----

--SlnaBQtdWG0gYnqZ--
