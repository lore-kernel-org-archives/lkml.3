Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbaJ3QpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:45:11 -0400
Received: from down.free-electrons.com ([37.187.137.238]:52310 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760330AbaJ3QpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:45:03 -0400
Date: Thu, 30 Oct 2014 17:40:15 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Roman Byshko <rbyshko@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/5] phy: sun4i: add support for USB phy0
Message-ID: <20141030164015.GN21251@lukather>
References: <cover.1414444953.git.rbyshko@gmail.com>
 <668c1b5541fc0175957573bd5f8d40dd2eaccae1.1414444953.git.rbyshko@gmail.com>
 <20141028214756.GF9255@lukather>
 <CAGb2v65gSq+kMnVZMAvXkF6+ARiFE1qRpQ9SFDThfXCg_kERsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qa0ccP92Gc0Ko3P8"
Content-Disposition: inline
In-Reply-To: <CAGb2v65gSq+kMnVZMAvXkF6+ARiFE1qRpQ9SFDThfXCg_kERsQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qa0ccP92Gc0Ko3P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 29, 2014 at 10:24:12AM +0800, Chen-Yu Tsai wrote:
> On Wed, Oct 29, 2014 at 5:47 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi Roman,
> >
> > Thanks for your patches
> >
> > On Mon, Oct 27, 2014 at 10:43:01PM +0100, Roman Byshko wrote:
> >> The driver for sun4i USB phys currently supports
> >> only phy1 and phy2 which are used for USB host
> >> controllers. This patch adds support for USB phy0,
> >> which is used by the musb hdrc USB controller.
> >
> > Like Andreas already pointed out, your signed-off-by is missing from
> > all your patches.
> >
> >> ---
> >>  drivers/phy/phy-sun4i-usb.c | 9 ++++++---
> >>  1 file changed, 6 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
> >> index 0baf5ef..a24728b 100644
> >> --- a/drivers/phy/phy-sun4i-usb.c
> >> +++ b/drivers/phy/phy-sun4i-usb.c
> >> @@ -157,6 +157,10 @@ static int sun4i_usb_phy_init(struct phy *_phy)
> >>               return ret;
> >>       }
> >>
> >> +     /* Regulation 45 ohms */
> >> +     if (phy->index =3D=3D 0)
> >> +             sun4i_usb_phy_write(phy, PHY_RES45_CAL_EN, 0x01, 1);
> >
> > What is this code supposed to do?
> >
> > Some define for this bit and/or a better comment would be nice.
>=20
> From Allwinner's sources: "Enable/Disable USB res45 Calibration"
>=20
> which I think refers to the internal 45 ohm termination resistors
> for the USB data lines. But I'm not an expert on USB hardware.

That would make a great comment ;)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Qa0ccP92Gc0Ko3P8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUmnvAAoJEBx+YmzsjxAg7B0P/RiC0pJ3lqLrjcltetVFDkAL
h6wIgkmi4lRi0z5n+zpCMuAR2rW/kMEMTuwDKO6lLEajdq+9ISho/Rh932ih3aLt
Bf/GE3HWa6McV6eGiGMyDKz9pvsr/HxkSqfq276PGhPE1UDDBp0FIBDDkq/bwwYQ
w5H+BdjIyGLn7rFIStZz9BEEItNlezS34Niutp9oTulyH0bdF2hLlINaClhWtLY+
gS2ZerKCpUq7tZShEv6Vv0wr1MyLpGEApRfFLH0lw1lroTLwO1YTFUqROBGfoA8u
PN0D1eAQ2xrdIjsryp3ioCPN6K5QEX3MMrITICXI+78lPGAqXtjVJU+jYjHuE/gf
jPaYiTx2Ykbfiuxlf1sMlorypmsBTOa46HX4t3uU/tuY0V9g6uatXRFsSvIWRxWc
LN5j735Dmb9tFWxW+d9/Wv28vg30NhU0kODuY1pD9CaJkjGC2qTEMDVNWqdM5XLm
KaMw5vPDx0JO2+PGoWFKSwpauWPdXK2BPVjitUfm4L5k19zqoQjqmWY2mvfWlDsv
3UFzjmZ6viR2CA8R26HMv1sAA8eNIx/3LIMilXswulWroVsD0CPDzKfSs1x82M5v
8yRjTJkXCVJ/PkK1REIcnn6SY5yagFhs1yHNmKBMN1wr6tlUnnpTBtYzzHijFsak
GsaXbCeeDtvmWYU/cEW+
=O5Zv
-----END PGP SIGNATURE-----

--Qa0ccP92Gc0Ko3P8--
