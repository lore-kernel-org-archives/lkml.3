Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaIWP35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:29:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37145 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbaIWP3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:29:55 -0400
Date: Tue, 23 Sep 2014 10:29:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <balbi@ti.com>, Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 2/4] ACPI / platform: provide default DMA mask
Message-ID: <20140923152945.GE28592@saruman>
Reply-To: <balbi@ti.com>
References: <1408535728-10518-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1487657.QLes1WRKBI@vostro.rjw.lan>
 <20140923145221.GC28592@saruman>
 <2422219.EN0C5cKd3e@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <2422219.EN0C5cKd3e@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2014 at 05:17:03PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 23, 2014 09:52:21 AM Felipe Balbi wrote:
> > On Tue, Sep 23, 2014 at 04:52:01PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, September 23, 2014 03:17:12 PM Heikki Krogerus wrote:
> > > > On Wed, Aug 20, 2014 at 02:55:26PM +0300, Heikki Krogerus wrote:
> > > > > Most devices are configured for 32-bit DMA addresses.
> > > > > Setting the mask to 32-bit here removes the need for the
> > > > > drivers to do it separately.
> > > >=20
> > > > Rafael, is this OK?
> > >=20
> > > Fine by me, but it should go in via dwc3 I think.
> >=20
> > huh ? Seems like there's no direct dependency.
>=20
> Well, it's part of a series where all of the other patches touch dwc3.
> Doesn't anything in that series depend on this patch?

dunno, I haven't received anything.

--=20
balbi

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIZHpAAoJEIaOsuA1yqREHMIQAKUzy5waHyI72sEal92KklRX
jsyZPv/qYxo4JJVoOxqtowpXvI1gx95FlFEbtIkM/lHbg3J8Vc+ENacERx2qpqvK
OAAfQbbmOtg8U7NN4n+DtmMTNt3MbZ4R2SpgrxXg4wLeKmAvehG1UB5emmrk2bwK
1Ts9yzz7/XIzFXHYBAlowcaVx7KFDoiCpveU3VN+g9Zbp6Xta7un91yxOCFMhS/A
dCC67ht/6FfgHVLgCus1PXCz2x28SyC4ba5zfyeg0nQsjhcputYCJWHm19ZIKDKA
9RGDXdDkKvkOB4F2PYlAA/laN/AAu8g//VR9EaHO9de3c28Yi1QhakDenLrzuiQB
rTo+itXRxLTeW/N0aDC5uMAGMa9+8j0lj+nqpYxnGnBE81xSt/zyJqv/i4gu9mT6
/qIsZTOigGzA6tUqh6AM/zLq6IGmz0ifvZGNZxcn1bEAkFe0mT2QnmcQDFpMxVHn
Fsy7gC18ZhZYOSAVlXtqVtEN2MHQ2HwBgb2AOgorjcT00ts4wRBXL31B6J0lZT1a
IAWESXB3+vgTnbZjHZz/lnBJBWs/8FxnVGIJ6UDvR2NxwHe6IsoH9E3iReIAIBYT
JgAKvK+lhjGiUOGHePKKf2HNuhRS6s1WU1iFP0ahI2UuTnFiRi+761TcZQK8hB1q
vqghEGn9RtyMaYlggU36
=kxSv
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
