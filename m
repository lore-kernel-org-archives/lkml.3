Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaJPHz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:55:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:61230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPHz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:55:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,730,1406617200"; 
   d="asc'?scan'208";a="590004656"
Message-ID: <1413446067.2412.51.camel@jtkirshe-mobl>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Oct 2014 00:54:27 -0700
In-Reply-To: <20141016074827.GD23154@mwanda>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
	 <1413378213.2412.13.camel@jtkirshe-mobl>
	 <1413389496.7484.3.camel@perches.com> <20141015195345.GQ26918@mwanda>
	 <1413403429.7484.13.camel@perches.com> <20141016074827.GD23154@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ItTEJn99PdJLlwtd5fsG"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ItTEJn99PdJLlwtd5fsG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-10-16 at 10:48 +0300, Dan Carpenter wrote:
> On Wed, Oct 15, 2014 at 01:03:49PM -0700, Joe Perches wrote:
> > On Wed, 2014-10-15 at 22:53 +0300, Dan Carpenter wrote:
> > > On Wed, Oct 15, 2014 at 09:11:36AM -0700, Joe Perches wrote:
> > > > On Wed, 2014-10-15 at 06:03 -0700, Jeff Kirsher wrote:
> > > > []
> > > > > I thought I remember Greg saying something about getting rid of t=
his
> > > > > driver anyway, but I could be wrong.  If Greg decides to keep thi=
s
> > > > > driver around, then I think we should something like your suggest=
ion
> > > > > above.
> > > >=20
> > > > Or maybe just make the Kconfig depend on X86_32
> > >=20
> > > What I like about your patches is that they are pure theoretical work
> > > and I don't have to think about them like regular proper patches with=
 a
> > > signed off by etc.  All the fun, none of the responsibility.
> >=20
> > I've sent a lot of signed-off patches.
> > These are simple suggestions.
> >=20
> > I think COMPILE_TEST isn't useful here.
>=20
> I don't understand...  COMPILE_TEST means runing a static checker on
> the driver.  Why would we not want to do QA?

I think we can drop this patch altogether since I have submitted another
patch to remove this driver from the kernel completely, since Matthias
Beyer (and Greg KH in earlier discussions) suggested we do so.

--=-ItTEJn99PdJLlwtd5fsG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUP3mzAAoJEOVv75VaS+3O/iAP/3f7dt5wKveqaHQwXh+KyVVR
R7mZ31+8el3RZh350qj0V4LQJ/QEKyO8QUynOmqsdJbJLrmOXy8ialF6w8MsnZCv
nKIolKquuEMkWKDN8CBi9DRgRzI7iJ5OWy0e634UND0UjA80QtW8hcmNHUOdAuXw
KagRYd53K4cI9vJhox/OU+PRUtmDcxUHgzDBCB0FCGnEFxXG3CVsuj9ukCAd2TZX
ODvVjvygre3KDIO3YNEXQOSmcKLVfcQc8tsIs/XOC/7SGS1lhPzCdyN1od2GJFR/
Sz/IOIilAK7Ew5l8b0K4V6G40tFol4/HZN0vBEdiW6GPE76iYLKbe6Clwby6CJAg
tfn2X83BEVCVtvvdhNoXHFoMvs+3+qMeCU6fFaBcMMGyqaEVtcb2r4h/AML37vhR
r51ZiRdzPAbouY9TlkehbCuqf8f5ZUeXH2lDOA+ehbLf363Vli4brISMVfWhHbtb
6Q6E8bPVa+2A4DxTD0LgU3cMEjiereTGj/Uyw8b2f1YLFjfJb/2hxZ2yAUY/c0ny
XhmxiQ9bNFMI8q/yOT8HiAj+IIaXwHDfs/T3roZ5XCCN3PHRmoP84kltNGK3jZBM
uePZDB7VSH4TdY34Vdx8Li32ovC+JPPQafV85hjxadEJ0r4ddavoicgSJL0NGZ2N
MEyGsrbS6dm7ADsxq/gj
=bAoF
-----END PGP SIGNATURE-----

--=-ItTEJn99PdJLlwtd5fsG--

