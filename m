Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaHTQUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:20:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60526 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaHTQUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:20:14 -0400
Date: Wed, 20 Aug 2014 11:20:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, "Chen, Alvin" <alvin.chen@intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: pch_udc: USB gadget device support for Intel Quark
 X1000
Message-ID: <20140820162008.GK24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1407172974-22485-1-git-send-email-alvin.chen@intel.com>
 <20140820145446.GB24500@saruman.home>
 <20140820161505.GB17908@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RVlUGXxwBj5SDcM9"
Content-Disposition: inline
In-Reply-To: <20140820161505.GB17908@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RVlUGXxwBj5SDcM9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 11:15:05AM -0500, Greg KH wrote:
> On Wed, Aug 20, 2014 at 09:54:46AM -0500, Felipe Balbi wrote:
> > Hi Greg,
> >=20
> > On Mon, Aug 04, 2014 at 10:22:54AM -0700, Chen, Alvin wrote:
> > > From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > >=20
> > > This patch is to enable the USB gadget device for Intel Quark X1000
> > >=20
> > > Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > > Signed-off-by: Bing Niu <bing.niu@intel.com>
> > > Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> >=20
> > this patch is basically just a new device ID being added to an existing
> > driver, do you mind if I add it to the -rc or you prefer to wait for
> > v3.18 merge window ?
>=20
> New ids are fine for -rc and stable kernels, don't wait for 3.18.

it does a little more than that as it needs to select the proper PCI
BAR for Quark, I guess that's still fine ?

Original patch here:

http://marc.info/?l=3Dlinux-kernel&m=3D140714448511662&w=3D2

--=20
balbi

--RVlUGXxwBj5SDcM9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9Mq4AAoJEIaOsuA1yqRECsgP+wZhOZ4TLl+EQ4pfoEkQt40a
R+w+JNAiulReYP4RXDNDCG70cdTx2isU7hqWN1vJuvrXBkJGUxZvHVR8Hj1B+VWK
B4x8L853PgJXzhjkifFuj6P2EdpEP+/6KCPHcFFdqBmDMGDAK6k7CNUyCcH81meY
IWpYLZucvQwH+xij5wLNAKrrL0XmCOd4xjVnWoHyTarJgb3jBiuSsvokCR7t9dpL
BF9j3TAPvRjz7lVKHfxN4Dbonmvn05rUea1Zt9AJXnw7gPrjQk3p/JX/jP6IuUqF
74/B6+xF7D60kjdnQIduNueuLqx0e9xCKrG/WK9HwC/E52TFP2a06gWlg5F3zXkQ
qi+1mrUqbYSuexmainSSyHniY4ZoU4t8OaCw54qeAoDX4sr+CDf+VKYHjEHdkpZc
AC7yzyg8C2Vkh2PPNtwuG//WLp1HaM7C+j2c6mpCrvU6hO+OYAU9B2kiNx2v4L62
FNE8ck6G4+6APKmIoJnu17bJhftvu3TaPNvbw9zD0besNj5ZosRuZRc2rHEWcFun
6vLutJ08TjyHYzEKOUdAa0/95CCIB62IIjhzmLO738LcHlew6Rjo2H1nthmtYOIu
YRd98mMzNgQw7i/scKv8kGW/jvJrp1bdA8LoCT41p107GbUAZTvjCkOyWal3hc7k
IYCHt6y47nly8xqW++lU
=je7C
-----END PGP SIGNATURE-----

--RVlUGXxwBj5SDcM9--
