Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaCGSKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:10:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45430 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCGSKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:10:04 -0500
Date: Fri, 7 Mar 2014 12:08:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v6] phy: omap-usb2: move omap_usb.h from linux/usb/ to
 linux/phy/
Message-ID: <20140307180828.GE23885@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393846695-14644-1-git-send-email-kishon@ti.com>
 <1394210888-1587-1-git-send-email-kishon@ti.com>
 <20140307165043.GC23885@saruman.home>
 <531A0436.3080201@ti.com>
 <20140307174059.GD23885@saruman.home>
 <531A05E2.8080706@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
Content-Disposition: inline
In-Reply-To: <531A05E2.8080706@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tVmo9FyGdCe4F4YN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 11:16:10PM +0530, Kishon Vijay Abraham I wrote:
> On Friday 07 March 2014 11:10 PM, Felipe Balbi wrote:
> >On Fri, Mar 07, 2014 at 11:09:02PM +0530, Kishon Vijay Abraham I wrote:
> >>On Friday 07 March 2014 10:20 PM, Felipe Balbi wrote:
> >>>On Fri, Mar 07, 2014 at 10:18:08PM +0530, Kishon Vijay Abraham I wrote:
> >>>>No functional change. Moved omap_usb.h from linux/usb/ to linux/phy/.
> >>>>Also removed the unused members of struct omap_usb (after phy-omap-pi=
pe3
> >>>>started using it's own header file)
> >>>
> >>>does this depend in any other patch ? I get the following when applying
> >>>*only* this patch on top of v3.14-rc5:
> >>
> >>yeah.. this is for linux-phy tree. I'll take this patch.
> >
> >looks like you're doing two things at once (renaming the header and
> >removing some unnecessary fields). At least mention the second thing.
>=20
> The second line of the commit message mentions just that ;-)

hmmm, my parser didn't read that, nevermind ;-)

--=20
balbi

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTGgscAAoJEIaOsuA1yqRED08QAKdEZtQXH6Y7Zv1v2XUiTyh7
dDsq6Gu7kVrvwwP940ATXLQ6WcxeDPsK0tVRrhfr6SXAy/FByzZx1Lr2NcqciB4B
SsZSAsv0DQT8auJgUr7f/w1TXa1dgWgW1fEo00vT3Byz758Whadr3ltXVvQfgmvP
w6LrBdx4w1YmBxJF3qSFcZPiWnCLjaxpz0bgYVhpPqyUWI5MMdZKVS+XXW9KuBBN
7JRWCmnZYcbDqtPLV/+zD2JVguUJpKy0f+TLgSDgPzzvrgch464lKiJ3+W2QZ92V
ITS2kzh8kn2tAPmXU6B9sbcByD7bL5oPDhrmBWJPhhU5Jl9jZh5yvu4o6AO2DyTe
0oRM2GzS0gokh7LWW1J7sb16tXuq0t3y+q7R5xk0oN3+fXOzXFj2Jl52Z0ZgoYPX
uoPNrEr32BzaP4FG1PkZMKKwjlmqajk/JYyO6VDZkwaHYux2C0mbaYcTPdeT7rWy
44AzzyrHfjyvovWfWG6Sgbkh7MR7VrbAoVdFMHCUGeRMdEyKQaqivBQjKYTDnsq8
HW+924KWc7hcM+dFFHSpt/JPISEshJj4er6KvpB31EWxyxmiljo5dKo6T47+2coQ
W2PP5F4I2qPD494jzOHCzXOiEyJiu7aA7t8tTyWUamlNOS23Av1wZkWeWnLfy2DQ
OGOd+z/0ZkOeGXsiKtFM
=zQ3L
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--
