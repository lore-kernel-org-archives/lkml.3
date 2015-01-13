Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbbAMSg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:36:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58400 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbbAMSg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:36:56 -0500
Date: Tue, 13 Jan 2015 12:35:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 05/11] usb: gadget: at91_udc: Remove non-DT handling code
Message-ID: <20150113183529.GO16533@saruman>
Reply-To: <balbi@ti.com>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
 <1417606330-17753-6-git-send-email-boris.brezillon@free-electrons.com>
 <20150112213905.GI2858@saruman>
 <20150112225330.GQ2447@piout.net>
 <20150113163654.GI16533@saruman>
 <20150113180526.GE3843@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8G1nIWD3RY794FAy"
Content-Disposition: inline
In-Reply-To: <20150113180526.GE3843@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8G1nIWD3RY794FAy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2015 at 07:05:26PM +0100, Alexandre Belloni wrote:
> Hi,
>=20
> On 13/01/2015 at 10:36:54 -0600, Felipe Balbi wrote :
> > > I've rebased that patch series but it depends on another one (the mfd:
> > > syscon: part of "memory: add Atmel EBI (External Bus Interface)
> > > driver") that is not taken yet so applying it now will break the
> > > build. I still hope to get it merged for 3.20 and I'll resend it as
> > > soon as possible.
> >=20
> > In that case, we either take the entire series through MFD (including
> > the gadget patches) or we delay the gadget patches until all
> > dependencies have been sorted out.
>=20
> I would prefer not to miss 3.20, can I resend the patches now so you can
> review and ack them? Then they could go through the mfd tree.

Sure, please do

--=20
balbi

--8G1nIWD3RY794FAy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtWVxAAoJEIaOsuA1yqRExT8P/jAjzG2Wd+U9o87kTVNSUxh+
3cWfHrBmgOBRzsD25lzwUF+7fJBncSrvrj9M4tFwW8Ef9CFcTxEUO507JznAQ59n
M+03cVbuftoczFmjixf33qe72ZRxfJYcPuL2ueUi5MqVtpVSKnAPuagndSAXifzW
mNZytFGaMKpcqf+SOZYFmbQhkLMbiKyzYXq6502zpnfqN1bcz56sZyDVAdTUw8Al
c9yVlxF7E75730qhY6m/L82udyHIroxjH7Q+5kC2xDAbbEiZfP+uuIj0yFByf6i9
9KR0QaIXMUnjuslbu7/R72BKQ2uCtWLoWK4aGMLP1g55YQkhaCF15kagJbg7LZt3
QMwq5pgGim//Dxshm56xmDx1vQkfRRka95yD1Bdsf0SpzVQHOMQuD28CV2WKr/S+
fyc6vYRpOR6438E2ntIpRS1IlZu0TP7R6GvwcmVr9Gdqx2D2EZNQmoebRgeP2AlK
/ux3gSLi96VHv+SVMMvqrOSMJQo5tHiK+8aok7iNaYYCzZvcaGXCtxVyQga2RZFt
HUJnOxlEkUPLrHPMC6AH62zb/+Hr7i4WJr6WXTd3Gg3lPIgHa7djrygjobHhOXiu
L8WlLDQR2WIxeAhxhbUf4A2AbxBTaFHXXF7KqzG+QhneTZM6qmECmJIPZfq1tLBo
4rpy2PZ95Ln8MJdBUhMp
=APUJ
-----END PGP SIGNATURE-----

--8G1nIWD3RY794FAy--
