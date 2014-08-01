Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaHAJKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:10:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42146 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750716AbaHAJKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:10:05 -0400
Date: Fri, 1 Aug 2014 10:57:07 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140801085707.GI3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <53DA3A48.8070900@metafoo.de>
 <20140731161331.GD3952@lukather>
 <53DA74B3.6060502@metafoo.de>
 <20140731173730.GH3952@lukather>
 <53DB490A.5040709@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwX5Nmi7feudBrEr"
Content-Disposition: inline
In-Reply-To: <53DB490A.5040709@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwX5Nmi7feudBrEr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 10:00:10AM +0200, Lars-Peter Clausen wrote:
> On 07/31/2014 07:37 PM, Maxime Ripard wrote:
> >On Thu, Jul 31, 2014 at 06:54:11PM +0200, Lars-Peter Clausen wrote:
> >>On 07/31/2014 06:13 PM, Maxime Ripard wrote:
> >>[...]
> >>> From what you're saying, and judging from the drivers that already
> >>>implement it, can't it be moved directly to the framework itself ?
> >>>
> >>
> >>What exactly do you mean by moving it directly to the framework? The
> >>slave_caps API is part of the DMAengine framework.
> >
> >Not its implementation, which is defined by each and every driver,
> >while the behaviour of device_slave_caps is rather generic.
> >
>=20
> Do you mean something like adding a dma_slave_caps struct field to
> the DMA channel that gets initialized when the channel is created
> and then remove the callback? That makes some sense.

I was rather thinking into something like:
  - Splitting device_control into independant functions
  - Then, knowing if you support pause/resume/terminate is trivial:
    either you implement the callback, or you don't
  - Putting the supported width and direction into fields of struct
    dma_device, which can eventually be used by the framework to
    filter out invalid configurations before calling the relevant
    callbacks
  - That would then be trivial to get from the framework, without
    calling any callback

> I think the main reason why we use a callback right now is that in
> earlier revisions of the API it was possible to pass a slave_config
> and the result would be the capabilities of the DMA channel for this
> particular config. But this was dropped before the final version was
> merged upstream.

Ah, that would explain yes.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wwX5Nmi7feudBrEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT21ZjAAoJEBx+YmzsjxAgEp4P/3vgw8nQcWo1zYmYGS2XhrQA
SXwaQXcUCUswqb19Yp6P+fbx7yTzwEwgEaWHYG2F0ka3vp84kgf+DJ9z2CGqz355
kZye6wRGYzXtvr+nxEJzW209C5z5TrmLjuZW+M7MC/+nEpyngZHRC3cx4tUZxTUl
AOaGcGC2MHK501Qgr8UTHUXzE3ONozhjkLvE1vxxXsp4bUO+SEJXvPtuyWVeWEGo
2Xb8ZTtHtB4YzCrWh24NtsQMbFZkakpS7P0R81jROXdcuPZKReMHckfVrMEWHKY+
LCQa0Cp5r+Uk9I10c2CAGkw4BglZvSiJ+gn9/Lj8CV7wqiyM7XpFkdtI7+s5RS5n
iGrWZguObW7+4SzQ6WznD8BYMy95pTKHRT4qA25oGoo3905pLbppSGgLUCqA95Mp
RfWBsRaH2Q/fAEY7EzJ/U0Ffc3wz5BLGnUoqQ7hhmYDdxi1rEsxCUPQ1DTFMoPP6
oM27Obk9IrofxA9KP+WWV+Ln36IbqI6sfjCsXxg5HW7e1VO5uO+NMrE8a5903x79
nlVUgmCEzXvuo0kij3i1a6sbggMG90oghO4BxQnSnlzhugv47juXE5rjL/Td6ymM
DHX8KM4A+5ym0bNNZGjf5+FJnyr7EzcYLehkBS0ZRVpJegrbVLbYK70/ABDiq4ym
ktUWOchzZb0wk57zlQAB
=dzmo
-----END PGP SIGNATURE-----

--wwX5Nmi7feudBrEr--
