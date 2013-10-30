Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3J3I0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 04:26:30 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45268 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3J3I01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 04:26:27 -0400
Date: Wed, 30 Oct 2013 09:26:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH 0/2] DT match helpers for initcalls and platform
 devices
Message-ID: <20131030082621.GA22787@ulmo.nvidia.com>
References: <1383113571-13029-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1383113571-13029-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2013 at 01:12:49AM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>=20
> This series adds a couple of boilerplate helpers to match with DT for
> initcalls and platform device creation and probe. The goal here is to=20
> remove more platform code out of arch/arm and eventually the machine
> descriptors.

I fear that this is a step backwards because it makes it easier for
people to do the wrong thing. We've been doing the same with interrupt
controllers and clocks. With those there's at least the argument that
they need to be available really early and therefore cannot use the
regular driver model. But for everything else, shouldn't we enforce
proper drivers to be written?

Perhaps if you can point me to some examples I could get more context
why and where this would be useful.

Thierry

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJScMKtAAoJEN0jrNd/PrOhC2AP/jIkBR1yucY/zoJYPpC2TMKx
rb9uy+zqVjI5j4BRIxQNLLyDMZBfaGGNsy9AOkNYCiLE9Zs+mb7o27A8FkbmPSrn
aW1j8x0Xz8TWHDVRTHVT+08b4Q3vPQG9nRZwe6/Xx4T7wJvbnVH0B+kp6I69IsPf
g3yU4oufbMrWI4usbvljacSPFVvEYERrkLcxYdpKDPIX9CQIaptr2w+ZFXS9mwPW
vRt2epO8+0ZqhkkcjxXL65u9G9kyyVS2VwmyNFnpVwVBCrlK9GlLCGMiuqtbGL8p
tS0hlF93Cy2DIAqo7NKUYwQyDZlibUTK3YQnpzGtwBu1rWihQAcCxdReQO7UFiUW
hUhmdXRATmyZpvkik3hAYumql7mlKv5Ar8bTpdideRdYnux+Gi+Mq4WKEbvL0dPq
WGuMkBqJYFcxufrMqvgPCsheUiHbYUhF9nEbD3elK0+TTDKgjxMMkch1E0b1Lxr1
QzzhTTuOOJCPVTa5lu7D3HwGDmVECjxvRFi8yVn8AudloZx6kfVcQj1j4Zv49OVC
xszJyiXKa+42BI+drdf+7PxF8TXa6NYkrb3yX5yd+8rKKYY3+zFdZvMLhZNXhFyw
NkEBlReiw0fcWsBWC5RUD1AdHUX3Tsux9ml3L3RJGA5H5fTd5xOc2Os7WXTUvyI5
pRKGEUHHRsBuH3+SOhxi
=I2Tz
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
