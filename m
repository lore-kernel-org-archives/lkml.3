Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaHBPPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 11:15:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754547AbaHBPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 11:15:05 -0400
Date: Sat, 2 Aug 2014 17:13:52 +0200
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
Message-ID: <20140802151352.GL3952@lukather>
References: <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <53DA3A48.8070900@metafoo.de>
 <20140731161331.GD3952@lukather>
 <53DA74B3.6060502@metafoo.de>
 <20140731173730.GH3952@lukather>
 <53DB490A.5040709@metafoo.de>
 <20140801085707.GI3952@lukather>
 <20140801171551.GG8181@intel.com>
 <53DBD7CD.3030103@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GviraxgP0A7vmYdC"
Content-Disposition: inline
In-Reply-To: <53DBD7CD.3030103@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GviraxgP0A7vmYdC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 08:09:17PM +0200, Lars-Peter Clausen wrote:
> On 08/01/2014 07:15 PM, Vinod Koul wrote:
> >On Fri, Aug 01, 2014 at 10:57:07AM +0200, Maxime Ripard wrote:
> >>On Fri, Aug 01, 2014 at 10:00:10AM +0200, Lars-Peter Clausen wrote:
> >>>On 07/31/2014 07:37 PM, Maxime Ripard wrote:
> >>>>On Thu, Jul 31, 2014 at 06:54:11PM +0200, Lars-Peter Clausen wrote:
> >>>>>On 07/31/2014 06:13 PM, Maxime Ripard wrote:
> >>>>>[...]
> >>>>>> From what you're saying, and judging from the drivers that already
> >>>>>>implement it, can't it be moved directly to the framework itself ?
> >>>>>>
> >>>>>
> >>>>>What exactly do you mean by moving it directly to the framework? The
> >>>>>slave_caps API is part of the DMAengine framework.
> >>>>
> >>>>Not its implementation, which is defined by each and every driver,
> >>>>while the behaviour of device_slave_caps is rather generic.
> >>>>
> >>>
> >>>Do you mean something like adding a dma_slave_caps struct field to
> >>>the DMA channel that gets initialized when the channel is created
> >>>and then remove the callback? That makes some sense.
> >>
> >>I was rather thinking into something like:
> >>   - Splitting device_control into independant functions
> >I like this part :)
>=20
> I started working on this a while ago by splitting out the
> slave_config functionality into its own callback. Haven't managed to
> finalize it since it wasn't really top priority.

He, I've done the same yesterday... Do you plan on submitting it soon,
or should I keep going?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--GviraxgP0A7vmYdC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT3QAwAAoJEBx+YmzsjxAgYEAP/0ReQ/p2VR18DRjRQRbO1sgt
2FC9fQjThwMzqpnj0AsKCQs5DQ5twE7fkSceg7E7Hv25gixQKbI3RGx/qcxYcig8
R8NzGxzWfhk95NsdkSketsXD7qly8hOktc/IHtY+H/pJorF57DUQ0OecenwEM/zg
qGjrZHUO0udIqi0ea3rGx5tp4iWr1kONWy6DKXFyFIKzaRlsqAqjf/XTBTK/OIz+
v25eCK5B3aU1zDtNFSTJ90FasbeE7OplYzEjSTg1r5wzXseTTUxm1xMYnnSBQANS
q5iq4xKzVcF3/FDCabtpjl7yF3ixLuDJ2kB2BNmmwIPHz6roViOpAwjknWYER6Su
/98gvPVrf4uaLuDplDs5sETQDDucLXU60GwD8kUoZk6xHSJ5pOxSN991P8wcf0zF
c35RxpGRlzwBtYWiD4/ke5gwPrHNLEl/4efzBrmrhwDudr6SkXtUqRR7rZZ89Y3S
lc3AZvt1pNV5NuxNA+5aYCa72pAgRVtPpAawaP/uypJSBHrtgKMG1yM+nhLHcQct
UtwKfAQvEoppzoSEnTVhMB2W50hRaj94AxD6zB4RBfEytXaWXIQaiGmsn/qmlT3L
amrNM+WBYZKbu9whP5eZ2kIEs2fDqltiM42XnCEtVDldxax3by/r2raR+rvvE3tb
UCf/gI4ZmkSSGV7WaAe4
=fBfo
-----END PGP SIGNATURE-----

--GviraxgP0A7vmYdC--
