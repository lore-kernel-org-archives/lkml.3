Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab3HTOd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:33:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36392 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab3HTOd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:33:57 -0400
Date: Tue, 20 Aug 2013 09:33:19 -0500
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
Message-ID: <20130820143319.GG26587@radagast>
Reply-To: <balbi@ti.com>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
 <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
 <20130820122907.GU26587@radagast>
 <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
 <20130820133712.GC26587@radagast>
 <1377007751.26268.27.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CRtNIOhYBPVBLkTX"
Content-Disposition: inline
In-Reply-To: <1377007751.26268.27.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CRtNIOhYBPVBLkTX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2013 at 05:09:11PM +0300, Ivan T. Ivanov wrote:
> Hi,
>=20
> On Tue, 2013-08-20 at 08:37 -0500, Felipe Balbi wrote:=20
> > Hi,
> >=20
> > On Tue, Aug 20, 2013 at 04:32:23PM +0300, Ivan T. Ivanov wrote:
> > > > On Tue, Aug 20, 2013 at 12:56:04PM +0300, Ivan T. Ivanov wrote:
> > > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > > >=20
> > > > > These drivers handles control and configuration of the HS
> > > > > and SS USB PHY transceivers. They are part of the driver
> > > > > which manage Synopsys DesignWare USB3 controller stack
> > > > > inside Qualcomm SoC's.
> > > > >=20
> > > > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > > > ---
> > > > >  drivers/usb/phy/Kconfig           |   11 ++
> > > > >  drivers/usb/phy/Makefile          |    2 +
> > > > >  drivers/usb/phy/phy-msm-dwc3-hs.c |  327 +++++++++++++++++++++++=
+++++++++
> > > > >  drivers/usb/phy/phy-msm-dwc3-ss.c |  374 +++++++++++++++++++++++=
++++++++++++++
> > > >=20
> > > > please rename these PHY drivers, they have nothing to do with DWC3.=
 PHYs
> > > > don't care about the USB controller.
> > >=20
> > > I think they are SNPS DesignWare PHY's, additionally
> > > wrapped with Qualcomm logic. I could substitute "dwc3"
> > > with just "dw", which will be more correct.
> >=20
> > alright, thank you. Let's add Paul to the loop since he might have very
> > good insight in the synopsys PHYs.
> >=20
> > mental note: if any other platform shows up with Synopsys PHY, ask them
> > to use this driver instead :-)
>=20
> I really doubt that this will bi possible. Control of the PHY's is
> not directly trough ULPI, UTMI or PIPE3 interfaces, but trough
> QSCRATCH registers, which of course is highly Qualcomm specific.

isn't it a memory mapped IP ? doesn't synopsys provide their own set of
registers ?

--=20
balbi

--CRtNIOhYBPVBLkTX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSE34vAAoJEIaOsuA1yqRErggQALQNYc3skZqHD7zDhRoK6eww
eNgZ+iOCmmrLREmrhLgW8sYBZN6Ies6UkxKyfA9P2vihsBAP2zSlkJ+JpsjRT4Hk
jJCktwUlwf0ASn4kF459dBFTyciVtHuQviIxfCUSA3qM7xVrxUA7sbFwBD2y766h
sxSLcpG1JYf/bElJvEFcljIMmQG33rvhdZvcVKFejJViYlPyrTgaV5IK1pCjMHNf
qyzjqDsGHzkGaNpUuL9WRgFcS4ZyR5JXDwC9bU709GAO8V4sh9osek03ijqdELv0
wOYgnXXffmpYi7TASwLVteGCz2hGa9wOopP2puq+Us8PHAC5S3xyzg44myk2bh+f
xdY+cAalUHXaTN3xSz40hO+tvc7cFTw0oRBG+IQ2CVtPS7xefHUbqJsPVqcnuOdj
bJJACFgX8iJcMHrTiFF4lkTEKKc+eAFW+9a64erW5IX3QwAR2irqf4ZuvrTL6OoJ
MxXXJ1C7ZXqWsCiymJzjpwYLdCdOa8gaKPJXR6YzmVPx1GVnfsMQ6V+flJnlmuf7
+KbrUrW60rB5guUFlAMX/k33dUhECzz50bvVOiNwwjWV4czWnVFxps9+7Zw900E0
GIkgGw8vDJ4kp9qve7lkWsz8eVBhS3G2MQYrmAH8ZQYPqoG2c9o+Dw3ks4c+dLVG
z6ARsGenDiMoNfY6EVzt
=HbGL
-----END PGP SIGNATURE-----

--CRtNIOhYBPVBLkTX--
