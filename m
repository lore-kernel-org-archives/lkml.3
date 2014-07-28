Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaG1PKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:10:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40194 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752332AbaG1PKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:10:03 -0400
Date: Mon, 28 Jul 2014 17:09:11 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] dmaengine: sun6i: Add driver for the Allwinner
 A31 DMA controller
Message-ID: <20140728150911.GN3952@lukather>
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404134454-25513-3-git-send-email-maxime.ripard@free-electrons.com>
 <20140630142054.GA8756@leverpostej>
 <20140630151906.GG28647@lukather>
 <20140630153305.GA28740@leverpostej>
 <20140701072119.GH28647@lukather>
 <20140701124852.GB6064@leverpostej>
 <20140727184942.GL17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zbynv6TNPa9FrOf6"
Content-Disposition: inline
In-Reply-To: <20140727184942.GL17528@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zbynv6TNPa9FrOf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Sun, Jul 27, 2014 at 07:49:42PM +0100, Mark Brown wrote:
> On Tue, Jul 01, 2014 at 01:48:52PM +0100, Mark Rutland wrote:
> > On Tue, Jul 01, 2014 at 08:21:19AM +0100, Maxime Ripard wrote:
>=20
> > > > It feels a little fragile to rely on the organisation of the clock =
tree
> > > > and the naming thereof. If the IP block is ever reused on an SoC wi=
th a
> > > > different clock tree layout then we have to handle things different=
ly.
> > >=20
> > > What do you suggest then?
> >=20
> > I will admit that I don't have a better suggestion.
> >=20
> > Without knowing which particular constraint on the mux parent clock we
> > care about it's difficult to suggest anything useful.
>=20
> There's supposed to be facilities appearing in the generic clock code
> for specifying default clock tree configurations via the DT - it's quite
> a common requirement after all.  It sounds like that should be able to
> do the job here.  Not sure if these have gone in yet or not but there's
> quite a bit of demand.

As far as I'm aware, it's not been merged yet.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Zbynv6TNPa9FrOf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1meXAAoJEBx+YmzsjxAgE8AP/jHzeQqjUobfQhKIxRC/i6ws
k2t1b8lKQB4IZkA8I4oGp0QUYIVrGrKKFFyqViafEZnsiMXiRsjQO4u9j/1dY8ux
QHJp7BUQx9BfbJjNBTI3ZCN3nhg/QR4Idg10ZFmewsrvQFQRG8YO56MHcf80KP6j
tGao4FImRLwYlqmB04QUxPA/W1+kAlv2nJ0rxmV3O4voR4WXa6l3xLAqtiw+Miwj
QDMsDBf176gHvqC4k9hRVcDdHC4lbcW5b8OeTZJDIoKgUBNLXXFcIGXsZWczn/R4
e3HVmIDHIniZRc7/E91/Axn1wYFHx9DE15WcHWoXuNftyPjYobBjUuDEY3EXEqok
Tl43C8yY5MtLzBW1NvopM5HdB+FNQeK4DBy2K0SXljQMZ+1Zgv62ApPizyBbA1D5
8/Y5Uw7m78ptSvcPITedt+uUAKDlyjnjvkZfPRd5ByboskkHDEg1vzUCy98lu6V8
fmbaSA33WKr+O7tAcJtnMUVKQiWwMbOPiV+a08dWuOrqV93IqW+uH+DrVTIPR2Pp
x6QhrCQWooGsgNPQRnikvJ4QJ3GTCb1telOoBhGUvRJJLak5INJF6Kc4a5Cu8gMI
rfMRwGTFYcw9/H6Lc0mS6WCpmepUTc65gfGwtwCqb3b4DWb4UoMZSYThvOH8OSMl
znp89Hy4WdFzKe385cdn
=P4sQ
-----END PGP SIGNATURE-----

--Zbynv6TNPa9FrOf6--
