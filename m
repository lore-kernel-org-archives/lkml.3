Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3HTNhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:37:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46202 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3HTNhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:37:52 -0400
Date: Tue, 20 Aug 2013 08:37:12 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <idos@codeaurora.org>, <mgautam@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>
Subject: Re: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
Message-ID: <20130820133712.GC26587@radagast>
Reply-To: <balbi@ti.com>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
 <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
 <20130820122907.GU26587@radagast>
 <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qa+qcrCtlQ17sJ4A"
Content-Disposition: inline
In-Reply-To: <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Qa+qcrCtlQ17sJ4A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 20, 2013 at 04:32:23PM +0300, Ivan T. Ivanov wrote:
> > On Tue, Aug 20, 2013 at 12:56:04PM +0300, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > >=20
> > > These drivers handles control and configuration of the HS
> > > and SS USB PHY transceivers. They are part of the driver
> > > which manage Synopsys DesignWare USB3 controller stack
> > > inside Qualcomm SoC's.
> > >=20
> > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > ---
> > >  drivers/usb/phy/Kconfig           |   11 ++
> > >  drivers/usb/phy/Makefile          |    2 +
> > >  drivers/usb/phy/phy-msm-dwc3-hs.c |  327 +++++++++++++++++++++++++++=
+++++
> > >  drivers/usb/phy/phy-msm-dwc3-ss.c |  374 +++++++++++++++++++++++++++=
++++++++++
> >=20
> > please rename these PHY drivers, they have nothing to do with DWC3. PHYs
> > don't care about the USB controller.
>=20
> I think they are SNPS DesignWare PHY's, additionally
> wrapped with Qualcomm logic. I could substitute "dwc3"
> with just "dw", which will be more correct.

alright, thank you. Let's add Paul to the loop since he might have very
good insight in the synopsys PHYs.

mental note: if any other platform shows up with Synopsys PHY, ask them
to use this driver instead :-)

--=20
balbi

--Qa+qcrCtlQ17sJ4A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSE3EIAAoJEIaOsuA1yqRE0PEP/1SjdrdmjKOE8528sQWorSXY
7afWwXTnne8L0bQ7Y23FhtCWLOZdoxRQx25U6dn/1SkT8svYkyHLKbXpHw3AZxrD
MOQMd2rLtQBbpJw9RP7xxW6LOH2+u7es3vmTITtt7KlTfBAUJg3hbG7D0YFA0Uwx
wmAqsQSAzUoC86b8NIDflEXplLrzctU3GCdxADVg51zZ6/sj8W/57w3ZZL7xE9BF
Ha4z9DDCgXcnaLqZ2yMU11EVFoaxOQgPjQ0Cd+LKhUqIT6Oazfh9R8t2OQF3MQRW
xW5CQ6EMkJs5CQ00aH746gu6ajF/n6i3iZ0qhC3o7wdSIjJkS5Zc3m2t11XVPQL2
uzOsPctO5CA3Bf/qXEyTt0ZY61EoNcmXZKZUPn2QYf/ZoDDFlnNimbKFjj2aXbZm
018r7Ods2NFXMPeKR4eluY6nJTrpSoDu/FENsHPKBTBH8oL1IU3y7vnWRo5iYDBc
c8GXXIkDb/fRZ5uji/h6yGjoRSntho2OQtjwHaWZ2WiStzd4kBPkEoyOMWnkb7Jh
u/DXZjwa8OCaEWnmi1kL4Kb4i3otwAp19A3jIjBjkFze+wtj0SJpn4FVCd2AbdqY
eaRKS6dKpBsOgEPn3KsHjYoeSxhzdDwavIFu8XiMB7vBidU+AXOZv/4IV+b6ZLs1
ELGqmsIKxf25K7T4KC4a
=2cSe
-----END PGP SIGNATURE-----

--Qa+qcrCtlQ17sJ4A--
