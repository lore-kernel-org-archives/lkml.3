Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaKMCoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:44:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51200 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaKMCoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:44:03 -0500
Date: Wed, 12 Nov 2014 20:44:14 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Robert Baldyga <r.baldyga@samsung.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>, <m.szyprowski@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH v4] usb: gadget: f_fs: add "no_disconnect" mode
Message-ID: <20141113024414.GA19072@saruman>
Reply-To: <balbi@ti.com>
References: <1412860911-23985-1-git-send-email-r.baldyga@samsung.com>
 <20141103161102.GM27425@saruman>
 <20141105194321.GS6548@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20141105194321.GS6548@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Wed, Nov 05, 2014 at 01:43:21PM -0600, Felipe Balbi wrote:
> On Mon, Nov 03, 2014 at 10:11:02AM -0600, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Oct 09, 2014 at 03:21:51PM +0200, Robert Baldyga wrote:
> > > Since we can compose gadgets from many functions, there is the problem
> > > related to gadget breakage while FunctionFS daemon being closed. FFS
> > > function is userspace code so there is no way to know when it will cl=
ose
> > > files (it doesn't matter what is the reason of this situation, it can
> > > be daemon logic, program breakage, process kill or any other). So when
> > > we have another function in gadget which, for example, sends some amo=
unt
> > > of data, does some software update or implements some real-time funct=
ionality,
> > > we may want to keep the gadget connected despite FFS function is no l=
onger
> > > functional.
> > >=20
> > > We can't just remove one of functions from gadget since it has been
> > > enumerated, so the only way to keep entire gadget working is to make
> > > broken FFS function deactivated but still visible to host. For this
> > > purpose this patch introduces "no_disconnect" mode. It can be enabled
> > > by setting mount option "no_disconnect=3D1", and results with defering
> > > function disconnect to the moment of reopen ep0 file or filesystem
> > > unmount. After closing all endpoint files, FunctionFS is set to state
> > > FFS_DEACTIVATED.
> > >=20
> > > When ffs->state =3D=3D FFS_DEACTIVATED:
> > > - function is still bound and visible to host,
> > > - setup requests are automatically stalled,
> > > - transfers on other endpoints are refused,
> > > - epfiles, except ep0, are deleted from the filesystem,
> > > - opening ep0 causes the function to be closes, and then FunctionFS
> > >   is ready for descriptors and string write,
> > > - unmounting of the FunctionFS instance causes the function to be clo=
sed.
> > >=20
> > > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> >=20
> > David, you have been messing with ffs lately, can I get a Tested-by from
> > you on this patch ?
>=20
> ping. David ? Any chance you can test this one out ?

a reminder on this request, it's getting close to tree lockdown
(probably another 2 to 3 weeks).

--=20
balbi

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZBr+AAoJEIaOsuA1yqRE+3EP/1KObGJDDSy2/NTS0cSpfNDC
o7YCRk6j4TmvDP41VjLh83aQPeWQLTViSOyh1T/yjCYOWDP5JHywzxbH8zlccX1d
L4MJskk/EFHPB+0PlBe6ksLjK3/TghKP1YrCbLUUph374LUnBpRVJqXdeR/m4C4f
5DzjzC5DQBiVscN1Fshehu/BhB1r1+X8TNJjkYobJTPxD8+qVTu23xtBf1L0ucb1
P2U8/FNExIWigVAOmU4mTszYJRNWBy2tv3bAxGY0MgOT+zWUAhmeIVM1rphcX4rm
f7Dv5k6GEKxTB2xTL8mTIMWgtkiT6AfGn7tWKa5gBoftIuXHwpJVNuya1jTT2+Ff
aRJp3WSX6r3HxT3HnhPXDuFs5KFw7/MoQAMg89rGmlioke0ESJTM2FUTahV9EaZI
l68QKJIV6ynsJmphk9iFIFhX5QVjU5nWvTppvUfFt+HlMCnWp4AFRBvdKjOJKFGN
MJTgrS/2T+By3B7qUgn+NJR5id+H13WYOJxdCj/XYM7gRMbgFGX6134QeiEqxozL
i6sJrbYnKQ6NoyfNmdRK0QdzccbPNotkQM9oby8MQiwSRuoO4+f3UUlZmeZyHONL
fM1gaiCqgUdkJ0rWKnbUd1UUGHO3eZ47wSOGFHH1ZBnGWqajNKcG1Z7aH0zTabBb
nRc+X+PEHfB78fFVXlpW
=m8ol
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
