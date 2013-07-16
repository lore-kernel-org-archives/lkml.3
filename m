Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3GPMkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:40:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48879 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3GPMkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:40:43 -0400
Date: Tue, 16 Jul 2013 15:40:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Federico Vaga <federico.vaga@gmail.com>
CC: <balbi@ti.com>, Paul Zimmerman <paul.zimmerman@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <giancarlo.asnaghi@st.com>
Subject: Re: DWC2 and/or S3C-HSOTG for STA2X11 board
Message-ID: <20130716124012.GB15036@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <38175373.Cq6zxae9tO@harkonnen>
 <20130716120425.GA32038@arwen.pp.htv.fi>
 <2703444.NGzofRFyoM@harkonnen>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
In-Reply-To: <2703444.NGzofRFyoM@harkonnen>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2013 at 02:27:43PM +0200, Federico Vaga wrote:
> Thank you Felipe
>=20
> [add CC Giancarlo from ST]
>=20
> On Tuesday 16 July 2013 15:04:25 Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Jul 16, 2013 at 02:01:33PM +0200, Federico Vaga wrote:
> > > Hello,
> > >=20
> > > I have an x86 board made by STMicroelectronics (STA2X11) with the Syn=
opsis
> > > USB-OTG DesignWare 2 on it and connected through the PCI-e bus.
> > >=20
> > > I know that there are two drivers for the same controller:
> > >    (host)   drivers/staging/dwc2/*
> > >    (device) drivers/usb/gadget/s3c-hsotg.{c|h}
> > >=20
> > > So, at the moment I cannot have a board with both host/device working=
 at
> > > the same time. I have to choose to use the block as device or host,
> > > right?
> > >=20
> > > I know that the plan is to merge the s3c-hsotg in the dwc2 driver
> > > (https://lwn.net/Articles/540283/). Are still accepted patch to s3c-h=
sotg?
> > > Or it is work in progress right now (soon), so it is better to wait a=
fter
> > > the merge?
> > >=20
> > > In order to use the s3c-hsotg I must implement a PCI wrapper that uses
> > > this
> > > driver. It will be accepted in the kernel even if it will be removed
> > > sooner or later because of the driver merge?
> >=20
> > currently s3c-hsotg has too much knowledge of the Samsung platform. My
> > suggestion would be to help dwc2 get in better shape. It should be
> > rather easy to support your board since that already has a PCI wrapper
> > driver.
> >=20
> > So, stick to host only for now, help clean up dwc2 and move it out of
> > staging, then later it should be fairly simple to merge the device side
> > in it.
>=20
> Is there something like a TODO list of dwc2 known problems?

Paul should be the best to answer that :-s

sorry

--=20
balbi

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5T8sAAoJEIaOsuA1yqREhboP/inagDUGMf8wyUHxyEUtLmGk
N1UEaHIZngvaapsbNdUagiaQyHxJEsXWCzac2+GCcGu8RygHgGMiGogcODXIu7j7
NPoY4qyD1jv3RJFa74xvDbVUVX2raTMmiNAV4H9kOGP+zR4xQnUYoJM/QRCDQAZF
L6tRBNCJExFbTQihqJ3EN8D2sRcJdBlu2ZPA3cTBZpOiE/ZbYySFJ5YPyjal6wEJ
bcKWBg9lLkj+bD7xo661CliYJXAKPVC89KXF4e66hcJAFHJh7kVJ1q7hMzNwBnkd
yE1UvHXyeaNWBnM0N4P+yZIgZFjoN70LSN4Ct8NzdfF9y45SeOoYngxZZMyvr2c9
2A8hSSZD1SUtKpKYuuk29oV70COIRN/Z56R5jLL3Egv/v4FK78Aoe/ymGm0sbiB0
oG9XpYKSavHAv8R21JnyPU8xMWFW5z3r7cfiqWPZoPKnTrVyJPeZ+DpZY30FrQQK
70uiiRJrLoR531HZ63BsqFgjitmRqQqlnlWDDDNb7b+x1cfANXT/tvdo509J5oH0
QXrETz1Lp3auaeFh1sKk46IE/X3XtJ+8cLkbVX64yOdkWs+GdoJ9BwsyzEuYV3Et
rFYOJffc7T8kX4DToto1hAyya0UTaKueAPXkO760CEHy49YDA+dGRuuFnetakJWJ
Hp/fI7Zf5Cz1GQ6rPasy
=/zrk
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
