Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3AaPjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:39:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47947 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3AaPjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:39:10 -0500
Date: Thu, 31 Jan 2013 17:38:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, kishon <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt
 node.
Message-ID: <20130131153836.GF4064@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
 <510A56BF.3040804@ti.com>
 <CAFp+6iFkb=U0CJA=3zmQvd5XfMwbROuRJjXoJG7zvvq4_upzNw@mail.gmail.com>
 <20130131152527.GE4064@arwen.pp.htv.fi>
 <CAFp+6iHvKYiF_neANRq5roAEJwhvcaLk7pAd7Dy94Z5XiDkhgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wb5NtZlyOqqy58h0"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHvKYiF_neANRq5roAEJwhvcaLk7pAd7Dy94Z5XiDkhgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Wb5NtZlyOqqy58h0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 09:00:37PM +0530, Vivek Gautam wrote:
> Hi Felipe,
>=20
>=20
> On Thu, Jan 31, 2013 at 8:55 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Thu, Jan 31, 2013 at 08:53:27PM +0530, Vivek Gautam wrote:
> >> >> Moreover, SoCs having multiple dwc3 controllers will have multiple
> >> >> PHYs, which eventually be added using usb_add_phy_dev(), and not
> >> >> using usb_add_phy(). So each dwc3 controller won't be able to
> >> >> get PHYs by simply calling devm_usb_get_phy() also.
> >> >
> >> > No. We have added usb_get_phy_dev() for that purpose in the case of =
non-dt.
> >> > I think, instead you can have a patch to use devm_usb_get_phy_dev() =
here and
> >> > in exynos platform specific code use usb_bind_phy() to bind the phy =
and
> >> > controller till you change it to dt.
> >> >
> >>
> >> We have dt support for dwc3-exynos, in such case we should go ahead wi=
th
> >> of_platform_populate(), right ?
> >> But if when i use of_platform_populate() i will not be able to set
> >> dma_mask to dwc3->dev. :-(
> >
> > do you have a special need for dma_mask because OF already sets it.
> >
> If i am not wrong of_platform_device_create_pdata() will set
> "dev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32)"
> and not dma_mask.
> I fact we had some discussion sometime back when we needed the same
> for dwc3-exynos in the thread:
> [PATCH v2 1/2] USB: dwc3-exynos: Add support for device tree
>=20
> But couldn't get final node on it.
> So suggestions here please. :-)

hmm.. you're right there. Grant, Rob ? Any hints ?

--=20
balbi

--Wb5NtZlyOqqy58h0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCo/8AAoJEIaOsuA1yqREvg4P/itRRSrXkp2YjvxVzI+1iSCa
/AZ2ojmw5JnBQiSd9kANnWwhTbuE5iSPjPEZA2N/i9AxdicJDM8lGEml4EMe6oNj
XRU/5SAxjTNvIAVOue+jtBNCpzWQcriKqBnvHMMkAbMPBM83ie6xmvppWXU5Wyz6
DrmREzEq1GWDfN84/AEhb4ClXvGsJMY4V6OM24yihSPaI5N/fsIYjpYAegqOth9V
6H7egg+Z0/nEKihmm8Vbt1/iBh1ElVVKKDaScWvbjqXZxrRlvYxesUzAPUOQxi9Q
gZNyRw1Axn6xv2UGjqLVhukWg0UbeATLp1MSgZqoPkGB1ybxjPsBdAdSfmBF8RrB
9qJbxvhJJXSCaiJ6uDvxdHqLIVWtG36kWIEEpeAvQMpOQ/fNdV8sF8hL8fmxoYMu
6SHCHY+hR7P6Egw0OkuERW4KoiTWoFXHA6kN7pXVtMScUTlItUvlSoy4Z7gPhVSm
k5papQ93O1BgSjxH1Ff12rr9hinrFeAqh75enUGuWToBJnsG7UzJ/Lktd2HUZ+oT
/fIjBb3Nj5XmUIxrXbQoTa4vhj+WGoWuu8RngX9Sti+JVWwleR/pC8QVdbglwmQo
ccfhBNJdHQTifLOVNs0dKBtyy+BnIbHJKzPX7NLcGMQnPqzr6UxBggn6QrGSAUdW
a/YDP1RkMqEGLfV+0wDQ
=RShY
-----END PGP SIGNATURE-----

--Wb5NtZlyOqqy58h0--
