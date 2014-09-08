Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaIHNZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:25:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55783 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbaIHNZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:25:05 -0400
Date: Mon, 8 Sep 2014 08:24:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Lifshitz <lifshitz@compulab.co.il>
CC: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 2/2] ARM: dts: omap5: Add dr_mode for dwc3
Message-ID: <20140908132403.GA22409@saruman.home>
Reply-To: <balbi@ti.com>
References: <1381402195-29257-1-git-send-email-kishon@ti.com>
 <1381402195-29257-2-git-send-email-kishon@ti.com>
 <52580F34.8030809@ti.com>
 <20140416161619.GH28035@saruman.home>
 <540D9449.3090008@compulab.co.il>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <540D9449.3090008@compulab.co.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 08, 2014 at 02:34:33PM +0300, Dmitry Lifshitz wrote:
> Hi Felipe, Roger
>=20
> On 04/16/2014 07:16 PM, Felipe Balbi wrote:
> >On Fri, Oct 11, 2013 at 05:46:12PM +0300, Roger Quadros wrote:
> >>Hi,
> >>
> >>On 10/10/2013 01:49 PM, Kishon Vijay Abraham I wrote:
> >>>From: George Cherian <george.cherian@ti.com>
> >>>
> >>>Added dr_mode property in dwc3 and set its default mode to device.
> >>
> >>If there is a specific reason why this is not set to "otg", we need
> >>to explain it here.
> >>
> >>AFAIK the port is meant to be used as OTG port.
> >
> >we still don't have the workaround for dual role ports, I've been
> >working on it but still need to retest and make sure it's working fine
> >before merging upstream.
> >
>=20
>=20
> Does the OTG port suppose to work with OMAP5? I mean role switching
> mechanism?
>=20
> I'm testing kernel v3.16 with OMAP5 based board (CM-T54).
>=20
> If I set CONFIG_USB_DWC3_DUAL_ROLE, than nothing is going on when I plug
> some device/host cable into micro USB3.0 port (VBUS/ID detection with ext=
con
> events works fine).

Dual role does not work. We allow the driver to the built with both Host
and Peripheral support because some platforms have more than one port
and building the driver with dual role allows us to make one port host
and one peripheral.

--=20
balbi

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDa3zAAoJEIaOsuA1yqRETcEP/3CLT8qv5OGckVMRFLfVpt54
PBYlPHoEiEZoKKzgsnSAcxI4+RI3J9uFvUcOUMuM9jGIchGIub8WL41SbzAfJ6Ti
6DIPkdWlPhiJReb0lMWbwAQgqAYknxpiFX1acXA8I175gb4HE/px24qnX4NThR+W
wnKWMHLDwY3EH0mYgacpZBP+oseV43qmcqfuuyRPHULEjKqj9j+dyIiPwOQ+RxXA
idVX0vm6SrFip5gVtUDhUM6Z7CIDELreBTR5jmBdCclVskVz91rFMbSjFvLsO/Ua
DEDG0LAkG4YBydtwdRLmrElS37jYJC0UA/ysPFCI7DMbFlFtLT75qvvf60Q8SecG
MAs8sm7PQmB1Qz0xcKsIfjZdLARxl0xXMs5iCPYgzG8Naen3gPhFyyFxDok7N4oU
nY3JR4REcAerKIFfAbF6HR1PMIUk63LjfWj8wY9bz4cFfsAwbfi6hx+GSm2DLAH2
S4tT47VYeV9Ye4Q0uXX/kLfP3Vbl/J7EqCrrzJBz6xgy1lAMNqO7ssqCu0MRMwo0
ALe9uS3KIifqh4CQspoKz49hO0MOs1r2ca8ioWqVl9bVxqaFRCapUlxGdPpfFkuC
s0Jcl9o9VpCuY30nSILr5bekCCbVxA8g6XGzG/ElnRpkOcS2wLcvow9d3JMDZvp6
gQC3qtWmN7JQU0yk/NDG
=O4nw
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
