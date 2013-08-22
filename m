Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3HVUmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:42:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38814 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab3HVUmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:42:16 -0400
Date: Thu, 22 Aug 2013 15:41:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kumar Gala <galak@codeaurora.org>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Pawel Moll <pawel.moll@arm.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "idos@codeaurora.org" <idos@codeaurora.org>,
        "mgautam@codeaurora.org" <mgautam@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>
Subject: Re: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
Message-ID: <20130822204130.GP28420@radagast>
Reply-To: <balbi@ti.com>
References: <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
 <20130820133712.GC26587@radagast>
 <1377007751.26268.27.camel@iivanov-dev.int.mm-sol.com>
 <20130820143319.GG26587@radagast>
 <1377010458.26268.30.camel@iivanov-dev.int.mm-sol.com>
 <8691FDFE-326E-4198-838A-202D9EC988E1@codeaurora.org>
 <1377011163.31445.30.camel@hornet>
 <1377018092.31445.42.camel@hornet>
 <1377090364.15070.13.camel@iivanov-dev.int.mm-sol.com>
 <68B25A45-443C-4CC0-9933-80A3D290B557@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pzbqGaOtRNiVr7w4"
Content-Disposition: inline
In-Reply-To: <68B25A45-443C-4CC0-9933-80A3D290B557@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pzbqGaOtRNiVr7w4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2013 at 10:13:28AM -0500, Kumar Gala wrote:
>=20
> On Aug 21, 2013, at 8:06 AM, Ivan T. Ivanov wrote:
>=20
> > On Tue, 2013-08-20 at 18:01 +0100, Pawel Moll wrote:=20
> >> On Tue, 2013-08-20 at 16:06 +0100, Pawel Moll wrote:
> >>> On Tue, 2013-08-20 at 16:01 +0100, Kumar Gala wrote:
> >>>> On Aug 20, 2013, at 9:54 AM, Ivan T. Ivanov wrote:
> >>>>=20
> >>>>>=20
> >>>>> Hi,=20
> >>>>>=20
> >>>>> On Tue, 2013-08-20 at 09:33 -0500, Felipe Balbi wrote:=20
> >>>>>> On Tue, Aug 20, 2013 at 05:09:11PM +0300, Ivan T. Ivanov wrote:
> >>>>>>> Hi,
> >>>>>>>=20
> >>>>>>> On Tue, 2013-08-20 at 08:37 -0500, Felipe Balbi wrote:=20
> >>>>>>>> Hi,
> >>>>>>>>=20
> >>>>>>>> On Tue, Aug 20, 2013 at 04:32:23PM +0300, Ivan T. Ivanov wrote:
> >>>>>>>>>> On Tue, Aug 20, 2013 at 12:56:04PM +0300, Ivan T. Ivanov wrote:
> >>>>>>>>>>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >>>>>>>>>>>=20
> >>>>>>>>>>> These drivers handles control and configuration of the HS
> >>>>>>>>>>> and SS USB PHY transceivers. They are part of the driver
> >>>>>>>>>>> which manage Synopsys DesignWare USB3 controller stack
> >>>>>>>>>>> inside Qualcomm SoC's.
> >>>>>>>>>>>=20
> >>>>>>>>>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> >>>>>>>>>>> ---
> >>>>>>>>>>> drivers/usb/phy/Kconfig           |   11 ++
> >>>>>>>>>>> drivers/usb/phy/Makefile          |    2 +
> >>>>>>>>>>> drivers/usb/phy/phy-msm-dwc3-hs.c |  327 ++++++++++++++++++++=
++++++++++++
> >>>>>>>>>>> drivers/usb/phy/phy-msm-dwc3-ss.c |  374 ++++++++++++++++++++=
+++++++++++++++++
> >>>>>>>>>>=20
> >>>>>>>>>> please rename these PHY drivers, they have nothing to do with =
DWC3. PHYs
> >>>>>>>>>> don't care about the USB controller.
> >>>>>>>>>=20
> >>>>>>>>> I think they are SNPS DesignWare PHY's, additionally
> >>>>>>>>> wrapped with Qualcomm logic. I could substitute "dwc3"
> >>>>>>>>> with just "dw", which will be more correct.
> >>>>>>>>=20
> >>>>>>>> alright, thank you. Let's add Paul to the loop since he might ha=
ve very
> >>>>>>>> good insight in the synopsys PHYs.
> >>>>>>>>=20
> >>>>>>>> mental note: if any other platform shows up with Synopsys PHY, a=
sk them
> >>>>>>>> to use this driver instead :-)
> >>>>>>>=20
> >>>>>>> I really doubt that this will bi possible. Control of the PHY's is
> >>>>>>> not directly trough ULPI, UTMI or PIPE3 interfaces, but trough
> >>>>>>> QSCRATCH registers, which of course is highly Qualcomm specific.
> >>>>>>=20
> >>>>>> isn't it a memory mapped IP ? doesn't synopsys provide their own s=
et of
> >>>>>> registers ?
> >>>>>=20
> >>>>> From what I see it is not directly mapped. How QSCRATCH write and
> >>>>> reads transactions are translated to DW IP is unclear to me.
> >>>>=20
> >>>>=20
> >>>> I think the question is how does SW access them?
> >>>=20
> >>> I afraid the answer may be: "it depends on the SOC". In my past I had=
 to
> >>> initialize a (SATA) PHY by implementing a software JTAG state machine,
> >>> as the PHY's registers were not memory mapped *at all*. And the IP
> >>> itself came from Synopsys, Cadence or yet another EDA company...
> >>=20
> >> Having said all that... If the PHY's spec at least defined layout of t=
he
> >> registers in question and driver was using regmap API to talk to the
> >> device (initially regmap-mmio), it has some chances to become universa=
l.
> >> The SOCs designed like "my" one would have to provide a custom regmap
> >> implementation.
> >=20
> > Sound reasonable. Unfortunately I don't have PHY's IP spec.=20
>=20
> Looking into this it appears that the register wrapper around the IP
> is most likely highly specific to qualcomm as I'm not seeing a
> register interface around the DWC HS PHY.

Then it's set, we'll go with this driver :-)

--=20
balbi

--pzbqGaOtRNiVr7w4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSFnd6AAoJEIaOsuA1yqRELxkQAIy2huhKZMMuoua7XhQVV2LD
3yCZDPLNBsmdbKFRNcnI0pv7m1flJjy4cjCG33Yu38pv1JKC4f17wC32a5rWMtec
VcEAQwUU6jJYF+BALvKkntu4bxMIlwIrw6G1ZGhzdOvfpBt305CtfbSu/A0DUcFh
gZJHbiDe+SOH2kdY9O+TL1qbUXBAX04TdAvzA2IQ+cfyG0o/5f39sHoQ/oXiLja1
JXcEvXg0xNcYYEZTMft+CeaJ0F0q8F1lFpE89+NkRaSiJIESFQimStxb9BDN3BTe
Nnt1ypQLDKZq8LtmRVEwsBr4UOyTnzMSisLrPnnV28B8XVfYxwkvRCVU/xJrkQXe
ucZbq77Vp4B0YHkZyglSrtRnn8wAdlc2HPXVtdUftYKQtGo5iDgHlKt/mI9xDzCM
ynOYN/UN7UhOqAS/SUoTa8Z3Q+N/RUypGfwLTy7WoTHlyMG/Xc9yHzZphHqK0SgE
851NhpGpbMFGz6sm7l/R+pwUYbW/pZhaqVsm7qWigacFvpgdNOkQuuU8gpSn862F
VLlgRE0gKV051eXfjhSQXTHM2Gc05uTWXywYv+b2sIU/IL8yMTBT6ANYbQS9uK3t
f78SqvbEf8FZQcXGj7KzSatOEqwSnkrI1PIOIvQNxSJLVWgNXHaQmWx827r8ufTv
AIfEwOsdw4kPVuKSXI4j
=WR9r
-----END PGP SIGNATURE-----

--pzbqGaOtRNiVr7w4--
