Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaKLNUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:20:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59267 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752337AbaKLNUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:20:04 -0500
Date: Wed, 12 Nov 2014 14:15:02 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v4 00/58] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141112131502.GN14919@lukather>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141106143349.GL2989@lukather>
 <20141112112529.GK24582@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WU3I8Do+sziGY3UL"
Content-Disposition: inline
In-Reply-To: <20141112112529.GK24582@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WU3I8Do+sziGY3UL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 12, 2014 at 04:55:29PM +0530, Vinod Koul wrote:
> On Thu, Nov 06, 2014 at 03:33:49PM +0100, Maxime Ripard wrote:
> > Hi Vinod,
> >=20
> > On Tue, Oct 28, 2014 at 10:25:15PM +0100, Maxime Ripard wrote:
> > > Hi,
> > >=20
> > > As we discussed a couple of weeks ago, this is the third attempt at
> > > creating a generic behaviour for slave capabilities retrieval so that
> > > generic layers using dmaengine can actually rely on that.
> > >=20
> > > That has been done mostly through two steps: by moving out the
> > > sub-commands of the device_control callback, so that the dmaengine
> > > core can then infer from that wether a sub-command is implemented, and
> > > then by moving the slave properties, such as the supported buswidth,
> > > to the structure dma_device itself.
> > >=20
> > > Comments are as usual appreciated!
> >=20
> > How can we move forward on this?
> >=20
> > I didn't have any comments on this version, and gathered quite a lot
> > of Acked-by already.
> >=20
> > Do you want me to rebase on top of your current next branch and send
> > you a pull request?
>=20
> Hi Maxime,
>=20
> Thanks for the huge cleanup work
>=20
> I quickly looked thru the series and looks okay. I will do a detailed rev=
iew
> in next couple of days and then host it on a topic branch so that Feng's
> robot can test it before merging it.

I know that it will break, because of the Atmel's XDMAC driver that
has been merged since. This is why I mentionned rebasing it ;)

FWIW, the branch I was using for this serie has been published like 3
weeks ago, and my git repo is built by Feng's bot, so there shouldn't
be any compiling issues.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WU3I8Do+sziGY3UL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY11WAAoJEBx+YmzsjxAgcREQAKk/HWLt8//eQvNUcUg8xHqD
eAMYC8RunOcuDz5ukAceQSTnTAN660xAqNcTmWKkAH9FMOKK1+v5Yrj5KvY7xl5p
wVDp2PSUjhmP795Tj8AaZ/5jBFWuW63dIlu2aiC+pxEW1GVT8wQznp+XiiCm6gGs
BD2/8zfyf2v+ZdnL0q6MWCsO/C1uxEhC9/p8hg8WAvWomohwAZus0TcV9H7HayVY
hPgsCarFwRB75p/GImxhFZeRQzTgNVtzZPFtsJZpBqZKnvX1a6R69zUcxWjkuBCJ
ci6jOsfLmwn3w+hHD8VGHY1vZZX+159SoPqmtCN4BhYaoFplzt4JNv8G0Xb/I4l4
oHfcxXl4cp7w3bNUSkw+PmPAqcgLjKHf83T2SnSPZdcdnjg6SveTPZ5QelvzLtFt
wEN+41LND8ulohR4oucM8x6mB7MDDqSKBetE/Kuahlll7cb2JJe02ufZnN4U68kw
dHOEQhGMGHr4mQ00dESqvc0pGan+phuko1QQVR9LgwR71agVElNnUJbr4rzl8koD
6Tbmha9z08YdA/D2a/1FwNWahLHZi8INVy2fAl+VTUwd7TXjge8S7xEhF2jCwNce
PIweNHEPB8IAvpSK5ixYOVLkT5u2rz+YCqJ6ncup4JHSQT/9aBolXGp1uNq+Vz/r
nAjPwl7VLxEf2yYuBoU9
=R4tt
-----END PGP SIGNATURE-----

--WU3I8Do+sziGY3UL--
