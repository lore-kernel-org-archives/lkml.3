Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaIWOwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:52:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43304 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbaIWOwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:52:31 -0400
Date: Tue, 23 Sep 2014 09:52:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Felipe Balbi <balbi@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 2/4] ACPI / platform: provide default DMA mask
Message-ID: <20140923145221.GC28592@saruman>
Reply-To: <balbi@ti.com>
References: <1408535728-10518-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408535728-10518-3-git-send-email-heikki.krogerus@linux.intel.com>
 <20140923121712.GD18814@xps8300>
 <1487657.QLes1WRKBI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <1487657.QLes1WRKBI@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2014 at 04:52:01PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 23, 2014 03:17:12 PM Heikki Krogerus wrote:
> > On Wed, Aug 20, 2014 at 02:55:26PM +0300, Heikki Krogerus wrote:
> > > Most devices are configured for 32-bit DMA addresses.
> > > Setting the mask to 32-bit here removes the need for the
> > > drivers to do it separately.
> >=20
> > Rafael, is this OK?
>=20
> Fine by me, but it should go in via dwc3 I think.

huh ? Seems like there's no direct dependency.

--=20
balbi

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIYklAAoJEIaOsuA1yqREUrwP/ja40yNX+TPE6j4qKTTd+vQA
NLG2ieiriRWKpk0Qw0mtrUnAqaGxAXFatan2inF1N66NGuPboAqLxLqqQ8cNY7zH
ZreS7ut28m2hHllYS08XPivV6NOpBNDftn0t4CLH3RVE7HjZEGchYxvN0gxwPiyW
PLEOuMM2vWxLlYBUGUhlOwXu9ICau9NAOHEXRt44VbnPa6b8ShCTO8JouVHYUYbD
R6VQnSJ47CRW8puIwcVE7gU7VuTaWN3YLGhaIKI/H/9rk2fASVCY8hpsILKQwGoJ
ZSiMjuWb+vlge1T2hq74twVP/y1GRBMa+veUW98fpHyVFC1rCpYQBq6zqaRgvkH0
R1rTB1tDvQRHtg2+VQaQJTuKIVFgPkpAtP1uD+nBmGh0wMzJIodh8NAXTwmTlPep
kclHvWu2i1ZE2ujpjqwE5i9OtD/td0ZrGMHmdiRMnmBipq0QfYHYWFjx3QKaM8HC
veFAU8lJF0UgVki7w4bQJ+EeqnTh+jdhjZhxME1vIOis8Da5hvDOT6nOYF/YiSqF
8d0uu+hA/WEPo5rgfIgD0cLTgLfHU/YzqQovuQGql+UODLUSKMR682Xrnun1H7QM
VEGeL6T4iQ6ZoUVzsZQMt5agmHCiCVlz9IYNuGGEehvsSNer3exJWkyWwYZPqP2W
kX6fkfboke72UIquMVCb
=ng59
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
