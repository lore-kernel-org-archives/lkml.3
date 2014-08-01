Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaHARZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:25:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:5926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHARY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,780,1400050800"; 
   d="asc'?scan'208";a="552444145"
Date: Fri, 1 Aug 2014 22:45:52 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20140801171551.GG8181@intel.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <53DA3A48.8070900@metafoo.de>
 <20140731161331.GD3952@lukather>
 <53DA74B3.6060502@metafoo.de>
 <20140731173730.GH3952@lukather>
 <53DB490A.5040709@metafoo.de>
 <20140801085707.GI3952@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X+8siUETKMkW99st"
Content-Disposition: inline
In-Reply-To: <20140801085707.GI3952@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X+8siUETKMkW99st
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 10:57:07AM +0200, Maxime Ripard wrote:
> On Fri, Aug 01, 2014 at 10:00:10AM +0200, Lars-Peter Clausen wrote:
> > On 07/31/2014 07:37 PM, Maxime Ripard wrote:
> > >On Thu, Jul 31, 2014 at 06:54:11PM +0200, Lars-Peter Clausen wrote:
> > >>On 07/31/2014 06:13 PM, Maxime Ripard wrote:
> > >>[...]
> > >>> From what you're saying, and judging from the drivers that already
> > >>>implement it, can't it be moved directly to the framework itself ?
> > >>>
> > >>
> > >>What exactly do you mean by moving it directly to the framework? The
> > >>slave_caps API is part of the DMAengine framework.
> > >
> > >Not its implementation, which is defined by each and every driver,
> > >while the behaviour of device_slave_caps is rather generic.
> > >
> >=20
> > Do you mean something like adding a dma_slave_caps struct field to
> > the DMA channel that gets initialized when the channel is created
> > and then remove the callback? That makes some sense.
>=20
> I was rather thinking into something like:
>   - Splitting device_control into independant functions
I like this part :)

>   - Then, knowing if you support pause/resume/terminate is trivial:
>     either you implement the callback, or you don't
>   - Putting the supported width and direction into fields of struct
>     dma_device, which can eventually be used by the framework to
>     filter out invalid configurations before calling the relevant
>     callbacks
thats is a good idea
>   - That would then be trivial to get from the framework, without
>     calling any callback
Yes please

--=20
~Vinod

--X+8siUETKMkW99st
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT28tHAAoJEHwUBw8lI4NHtJwP/0iNkXarMvsXF+r5nQAG5w2s
7veZbqGR2Rh55QQZ8Ncv9z2lQXhCe4ss9bMLzcWX+nVBbqnx78QjA8C5QzDMlxVG
FOM+v+NtTpyTdx7l1/B78YLQyj2hKeLirEUz1SAEgn/+uaxMeKpMFoUvoWWFGE5t
BWuyDnTHhtiZqsptUQ1Y9/MD0E2eXpKkhGcnvjOqmI0/PdGbfea8jPD6BDeoWZRg
GWVKl+G83rPW9C1fjrqwi89fXzCKJHztncqiFd9E4RtucrR9NQuccqZ9+yN/EU69
He0Ywlao4zlqnGUlwItuuG/la/Tw6vNBAwJoOUb3+AuEXeoxA6YzAH0WdVOJ9gJk
7ykDkI21rifrmvQqv6SC7SvmnE5fRzComa2qGOGpz8GZkGSe5BZ8aYFyM8pfpcAv
FFfrTvJhu/pQ8lPM4Jl9hoAYCQ2N2S0Y2oRZBAk9vsSskh2tO98s3YSCTUoKIpEw
i6NY/RHuqzKxruoGJVwM59L5zFwkuuGNb0vEbHa7Hz9gGBMdJal4sC259b2AMwq6
wStfEHOMbjHb1KNWknS9IAwBd1yknC3QHbUCgayaeGGbqXki2UCC4kxkIgeakN55
yfzTCj1iYwehT0n7j+oIuh1CU3R6cxyojL9ASepy1l2l0WczfdARwRk4RdsniHSM
eijE3o8jCGdhEc3JAaeN
=ipMn
-----END PGP SIGNATURE-----

--X+8siUETKMkW99st--
