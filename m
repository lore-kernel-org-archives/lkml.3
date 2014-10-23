Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaJWNuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:50:07 -0400
Received: from down.free-electrons.com ([37.187.137.238]:60784 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755968AbaJWNuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:50:04 -0400
Date: Thu, 23 Oct 2014 15:46:51 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 58/59] dmaengine: Add a warning for drivers not using
 the generic slave caps retrieval
Message-ID: <20141023134651.GQ7893@lukather>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
 <2006617.Jsn4xl9O1U@avalon>
 <20141023131933.GO7893@lukather>
 <4793064.0sBqs1vkQS@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3sseE1tnmEs+TkKq"
Content-Disposition: inline
In-Reply-To: <4793064.0sBqs1vkQS@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3sseE1tnmEs+TkKq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 04:38:39PM +0300, Laurent Pinchart wrote:
> Hi Maxime,
>=20
> On Thursday 23 October 2014 15:19:33 Maxime Ripard wrote:
> > On Thu, Oct 23, 2014 at 12:21:31AM +0300, Laurent Pinchart wrote:
> > > Hi Maxime,
> > >=20
> > > Thank you for the patch.
> > >=20
> > > On Wednesday 22 October 2014 17:44:12 Maxime Ripard wrote:
> > > > For the slave caps retrieval to be really useful, most drivers need=
 to
> > > > implement it.
> > > >=20
> > > > Hence, we need to be slightly more aggressive, and trigger a warnin=
g at
> > > > registration time for drivers that don't fill their caps infos in o=
rder
> > > > to
> > > > encourage them to implement it.
> > > >=20
> > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > ---
> > > >=20
> > > >  drivers/dma/dmaengine.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >=20
> > > > diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> > > > index 98e9431f85ec..4e18981b16bd 100644
> > > > --- a/drivers/dma/dmaengine.c
> > > > +++ b/drivers/dma/dmaengine.c
> > > > @@ -827,6 +827,9 @@ int dma_async_device_register(struct dma_device
> > > > *device) BUG_ON(!device->device_issue_pending);
> > > >=20
> > > >  	BUG_ON(!device->dev);
> > > >=20
> > > > +	WARN(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> > > > !device->generic_slave_caps,
> > > > +	     "this driver doesn't support generic slave capabilities
> > > > reporting\n");
> > > > +
> > >=20
> > > This might be slightly too aggressive.
> >=20
> > I disagree with that. If we want at some point to have the drivers
> > implement it, we should be aggressive (and note that we don't break
> > anything, the driver will still work as it used to).
>=20
> I meant too aggressive given the possibility that a driver might need its=
 own=20
> implementation if not all channels have the same capability.

Then we'll remove this warning, or rework it, when we will need it,
and hopefully by then, a lot of drivers will have fixed theirs :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3sseE1tnmEs+TkKq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSQbLAAoJEBx+YmzsjxAgPcQQAIpgTuu3prSa/Ka+Na15bmvB
IgkF4k8rhmo7/65lyWkOv6GkKiMn284otJBiq/GbYS7nl9epJSpILxw+TGwnuNHG
wpx1H2BoF6s2lthuM10Pq+qok1DoaFd3HASB14+qGD+Dy3Ef/CFP3sBUAfMlBaYx
W52LS4fUhPbhTsZyt6oZG92fslS8oi02holrJ+hseVp0LhhsJ0nUOMEFW8MVXub3
B1/K3IZRTOSdM4fveARuau7J9ivaw21Om8AKjQUuX8RoMNeCzI1acamVQKn0M9G/
0WD8RaPtLjGccwmjC6ZBp2rbMyVrqvEfs0Ig5x1z2TZKZw/L2T0Dzd1yIVqq7KQg
X0xCWBX2eITRzqanUCaQytKuSly5hIXPFfC5U7gsAvoSzBkaUt4Rluv0yTBQj/ts
Q2b3LFkUTW/E25XIJun76N3pEv2Q+dE0zh5A7KdGT4P7Gn+JtsjiVIf9tfLl/TEJ
GHfv5L+EtB+qrafIHl394yGS/FeiWEs0JSunEZAeVcJsD9t7lTgV69PMeQ+QakL7
nlspxxn2PUPA46w6YGdVkRnCWHCVwa+/20XRqvCmvUNyrK1rv+cVjb1BQN7ziywW
iSYv5zBwKhTHLNnYvCMFk0q86iTwRI0Dt3S4ufExYZzYQk/hsM/n/cJzQg5DztW8
qtdIeE+rPmK/uRSKV/JB
=a5I8
-----END PGP SIGNATURE-----

--3sseE1tnmEs+TkKq--
