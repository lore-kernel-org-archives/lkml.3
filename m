Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaIROlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:41:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47913 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbaIROlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:41:15 -0400
Date: Thu, 18 Sep 2014 09:41:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB changes for v3.18 merge window
Message-ID: <20140918144113.GB4537@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410976602-1536-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <1410976602-1536-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2014 at 12:56:42PM -0500, Felipe Balbi wrote:
> Hi Greg,
>=20
> Here's my pull request for v3.18. Now I'll ignore linux-usb for a while a=
nd get
> a beer or two.
>=20
> Anyway, let me know if you want anything to be changed, but I tested these
> patches with beaglebone black and am437x SK.

Wait a second on this one...

[...]

> Li Jun (1):
>       usb: gadget: composite: dequeue cdev->req before free its buffer

I need to revert this commit too.

--=20
balbi

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUGu8JAAoJEIaOsuA1yqREa8cP/0TCgehkkUsAWHTcMvQvxHVv
rNPs9BhdukCUoYm3WulNzlxhb00qBRCaBBxoJumUPcJSUtvRs32+mVXMSu/zid6s
ghXPM2TVXngGp7qb/ZYwceL1om+1Yg9vzJJoA+p4URmEE3O9fv+8FuIIVm+Kxlb8
9mSG1PpwKWaYL+uNc9Z1qIi9BDc3DM1eKdeFgjEtXbP/dj12j197UM/6nvbpys1G
gs41pIG55PObk3GgvutxhV4vamSqjJy7UUIgrR3ndQl6NjNeoxAmxKcgkNJstpSW
ifFtDJObZAcOz19YvWy8CftIVl2m2o4OgS4ChVlw3z+xbEACGE7hKn2h9jCYOA+6
EQ2YgmDmlTTrQhPKliL/IJHgUubNretxsuHjqDHpoT0jw8MVijepMeFJW2wR9msj
k3JVajhUFCQTJJ0Z1Fk66U4EtjZpjywQ40DWy44O4HulSOPovADo3jrSrpHXifMF
JOym5tHCt7tZ2/xqqYGs/Ui/3Eg9cfILTJXwkkBU9o2ao/B4NkjnZNZO6KK/O/Ea
DnVMj7xvPKVk3+6IZgovO5R1mbK9yIKooaw/VPlxoP/KdHjpDk8mFWlg5Bu9oY6W
AZvhKfcBk/YfFHEOSLcAYZr4F3AWDaQw+yMUCK2gAmaK+XHQwBbbsgDGUFhV4rvG
QqcXGXVPbCUvE337opxH
=I8m2
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
