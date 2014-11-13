Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaKMPfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:35:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:9290 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaKMPfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:35:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="416036056"
Date: Thu, 13 Nov 2014 21:00:55 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v4 00/58] dmaengine: Implement generic slave
 capabilities retrieval
Message-ID: <20141113153055.GN24582@intel.com>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141106143349.GL2989@lukather>
 <20141112112529.GK24582@intel.com>
 <20141112131502.GN14919@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <20141112131502.GN14919@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 02:15:02PM +0100, Maxime Ripard wrote:
> Hi,
>=20
> On Wed, Nov 12, 2014 at 04:55:29PM +0530, Vinod Koul wrote:
> > On Thu, Nov 06, 2014 at 03:33:49PM +0100, Maxime Ripard wrote:
> > > Hi Vinod,
> > >=20
> > > On Tue, Oct 28, 2014 at 10:25:15PM +0100, Maxime Ripard wrote:
> > > > Hi,
> > > >=20
> > > > As we discussed a couple of weeks ago, this is the third attempt at
> > > > creating a generic behaviour for slave capabilities retrieval so th=
at
> > > > generic layers using dmaengine can actually rely on that.
> > > >=20
> > > > That has been done mostly through two steps: by moving out the
> > > > sub-commands of the device_control callback, so that the dmaengine
> > > > core can then infer from that wether a sub-command is implemented, =
and
> > > > then by moving the slave properties, such as the supported buswidth,
> > > > to the structure dma_device itself.
> > > >=20
> > > > Comments are as usual appreciated!
> > >=20
> > > How can we move forward on this?
> > >=20
> > > I didn't have any comments on this version, and gathered quite a lot
> > > of Acked-by already.
> > >=20
> > > Do you want me to rebase on top of your current next branch and send
> > > you a pull request?
> >=20
> > Hi Maxime,
> >=20
> > Thanks for the huge cleanup work
> >=20
> > I quickly looked thru the series and looks okay. I will do a detailed r=
eview
> > in next couple of days and then host it on a topic branch so that Feng's
> > robot can test it before merging it.
>=20
> I know that it will break, because of the Atmel's XDMAC driver that
> has been merged since. This is why I mentionned rebasing it ;)
Okay then pls resend :)
I will keep couple of days reserved next week for it so that we merge it
quickly

>=20
> FWIW, the branch I was using for this serie has been published like 3
> weeks ago, and my git repo is built by Feng's bot, so there shouldn't
> be any compiling issues.
Thats good indeed :)

--=20
~Vinod


--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJUZM6vAAoJEHwUBw8lI4NHzL8P/1q/qMoeiPnf94sQ7XlvcPrH
xjh64OoOVdVGv4ynvXQB8nL4Yp01n5W34pKGCBVV8bHJo0sa6I0zSDXNqtLBFNv5
fYH9F1wUTETLLNr/9+h1S+YsXQnKwaGJPgd5LX2Tuiwo0pMMimgKTP2X95R20nCh
bEHzCJGJ9YAJoT2OZebkMw72IoF7372UmAORInyATgst7fqROMm2xU2dUQLVPrEv
CCwVQEKVbMDgfpBrwDc2aciKR65IMUUzCe+AtAZZsUTPK0v78wD/OUepsv0H850z
7H9MEIC03GHi0YD6fHXIbaz1KXzi3Zj8fXNSu+MFBZegpi1xrTE1Z6uIZl0oBezz
i7OsfDG6H8kjyZdoV0q3YYeuw19x1eJryj5xLks2+Yex1FC7Hb4QRdAW8boKJ0Jq
iivIDXDnvLYJScB6O/jzl5tzGMddX5Ad17qjI2et+H4A0KqG22rgwgC7tXHM7KFf
TSTymszQLzDB/8OEGVoCb2zTiTpWE8FwaMeEL7P6VajXgpbizmyEXDooVEXNv0t/
owalIXIHalDWvOevWUoHE3kncqJhQ+x8/f6XDHOJHQrmecs9so8mCdckBpGJGlxo
nnRQtRuoSNgG6J9qY8KorcHqwlXdzaWQk7MLyIPBZC4TvCZcZ8d9kG0SIkTNaSUS
PVISQN8JD5S3mouHdCFZ
=y6Pq
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
