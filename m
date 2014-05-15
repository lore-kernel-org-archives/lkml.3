Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaEOJVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:21:49 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64669 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaEOJVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:21:46 -0400
Date: Thu, 15 May 2014 11:19:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 06/10] usb: xhci: Add Tegra XHCI host-controller
 driver
Message-ID: <20140515091938.GD6434@ulmo>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
 <1400113986-339-7-git-send-email-abrestic@chromium.org>
 <15599140.PsD4j7x3tZ@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Content-Disposition: inline
In-Reply-To: <15599140.PsD4j7x3tZ@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 10:17:10AM +0200, Arnd Bergmann wrote:
> On Wednesday 14 May 2014 17:33:02 Andrew Bresticker wrote:
[...]
> > +	/* Create child xhci-plat device */
> > +	memset(xhci_resources, 0, sizeof(xhci_resources));
> > +	res =3D platform_get_resource(to_platform_device(dev), IORESOURCE_IRQ=
, 0);
> > +	if (!res) {
> > +		dev_err(dev, "Missing XHCI IRQ\n");
> > +		ret =3D -ENODEV;
> > +		goto out;
> > +	}
> > +	xhci_resources[0].start =3D res->start;
> > +	xhci_resources[0].end =3D res->end;
> > +	xhci_resources[0].flags =3D res->flags;
> > +	xhci_resources[0].name =3D res->name;
> > +	res =3D platform_get_resource(to_platform_device(dev), IORESOURCE_MEM=
, 0);
> > +	if (!res) {
> > +		dev_err(dev, "Missing XHCI registers\n");
> > +		ret =3D -ENODEV;
> > +		goto out;
> > +	}
> > +	xhci_resources[1].start =3D res->start;
> > +	xhci_resources[1].end =3D res->end;
> > +	xhci_resources[1].flags =3D res->flags;
> > +	xhci_resources[1].name =3D res->name;
> > +
> > +	xhci =3D platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
> > +	if (!xhci) {
> > +		dev_err(dev, "Failed to allocate XHCI host\n");
> > +		ret =3D -ENOMEM;
> > +		goto out;
> > +	}
>=20
> This does not feel appropriate at all: Rather than creating a child devic=
e,
> you should have a specific driver that hooks into functions exported
> by the xhci core. See Documentation/driver-model/design-patterns.txt

I don't think Documentation/driver-model/design-patterns.txt documents
this. Perhaps this is what you had in mind?

	http://lwn.net/Articles/336262/

Thierry

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdIaqAAoJEN0jrNd/PrOhBUIQAKd1nXshSupjAjeGsNlkQyez
GH8FCmraBgDc4Kf5v7+l03kYBgpI8rB1itwjnslS59CxSz6E6BVzAI6sFQvZ8kpQ
K7v/OAju6QNevxHHwrqWeyeiQtXE81Il0Q0w/14ca1uoD+64PoN+ztVVkwsegcZy
LtXV5+8WfwUCiaB9IS8ASerm2o17LzUzPTs0qKETwsq7Hy6l17y45uqPYVcFfPR8
tsp6FU+lNEtF9oylXDpjD2I6p4r7MlCClSrSwWURgIeD/Gzq3OjjPf47g/nTMuop
J5UAWrF8XiSgOO03PM5tiK40oHUWmSsDQtvOnaXE1KKyBoKGzhHrYz69lD/4ahps
jzseFt2wimbjXXlVQdydhJthD/nWv62V5yooST1ON6VBUBtmLx37JXhZwU9fTDXF
jxS9aEzCcpDVpWqbe4nT7azZIAywCfle/noJ3qILW+S9a5yF6jqYTv8WBroW2sTt
k3p1ItSxEbIDKfM10FRTlRYGVI49w6W4aTjUvnAzj1rwe0nfr4pxFQD/TM9qpLE1
23f1ebQRRwDJp3Hh8/5VduH7+5JmAc4PMG3do/Lu3bGKH3ahm6OBZPafUd3LYsKR
ThnPd3Cywg2C9eRgez8anuZGsnRREOMmsbRwe+zFLqDB18u/cm2E4b+KlNQNVFZu
1MtdbHv1Ur8/6oBue1vj
=1JJ4
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
