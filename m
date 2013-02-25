Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab3BYO4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:56:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59517 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758314Ab3BYO4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:56:37 -0500
Date: Mon, 25 Feb 2013 16:56:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Felipe Balbi <balbi@ti.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: i915 not working on Dell e6410
Message-ID: <20130225145622.GI15499@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130225142411.GD15499@arwen.pp.htv.fi>
 <20130225143918.GA19874@cantiga.alporthouse.com>
 <20130225144312.GG15499@arwen.pp.htv.fi>
 <20130225144906.GB19874@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+WOirvrtTKur1pg"
Content-Disposition: inline
In-Reply-To: <20130225144906.GB19874@cantiga.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x+WOirvrtTKur1pg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 25, 2013 at 02:49:07PM +0000, Chris Wilson wrote:
> On Mon, Feb 25, 2013 at 04:43:12PM +0200, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Feb 25, 2013 at 02:39:18PM +0000, Chris Wilson wrote:
> > > On Mon, Feb 25, 2013 at 04:24:11PM +0200, Felipe Balbi wrote:
> > > > Hi folks,
> > > >=20
> > > > I have a Dell e6410 whose framebuffer gets corrupted with v3.7.9 and
> > > > v3.8.0 but works fine with v3.6.11.
> > > >=20
> > > > Below you can find lspci and my .config, maybe I'm missing somethin=
g ?
>=20
> That looks like https://bugzilla.freedesktop.org/show_bug.cgi?id=3D60391
> which is fixed by
>=20
> commit da88a5f7f7d434e2cde1b3e19d952e6d84533662
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Wed Feb 13 09:31:53 2013 +0000
>=20
>     drm/i915: Disable WC PTE updates to w/a buggy IOMMU on ILK
>=20
> or by passing intel_iommu=3Doff on the commandline.

and so it does, thanks. That's going to be merged on v3.9 right ? Hope
there's a stable tag in it, thanks

cheers

--=20
balbi

--x+WOirvrtTKur1pg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRK3uWAAoJEIaOsuA1yqRE0oMQAINCTXKKyECUWxsiuJn+0QPt
xXOpbJUtWzsvhjfSRmIeEYA1u+eYaJOz/rf9dLxBIChfrk4OIdtiqbTfN1pJ7VEe
ryoFZCPZulLA3DEHDeeC1bFWV/ZR9WcGsb1muWLT66MyAfXQKX3S6KuyQNAByrcV
nY6NF4RLJmmwHd6RMrz8uF2/1zLAASvByURAAVY/8c4u4njnM56yx28O5gxBs8JT
XsCdY/Q0+F4FhteNZxSlEikjvbMDS11bgPYJkMIT/7RvMh6Ir3Jj0S6gBXfJs72R
HH/83eVTBwkmivqOimc7D6PoEsppSt2Y8t+/V3AiMExwvzNUMiAqLekZxgvtQlKv
Ul9r3RoVZNh0bWosg3+2dwyJIXwZswiPBe9iYJRmiGijIM8ysSsR/g9T8zZtNpFP
VvDSuFnwAJE8lOcE2U2VltwXRM8O9XJf1hilJoI0E7ua9jzNM4yAKtLd5iQ5H0ml
dHkwPv6dabDHp1bkngi7gfu8IwoxbQvWXZh5+2actFP1keRJQzbuPqGXgnAklCSV
LHyq8Msm4vsVi6GjhEXanhQ/05hN/FEz6OEjPuQYPwxB/nyHXwwhQO42iWqxErho
lcNefKFxANADuyTXiZwisoTz2I+vlKxIt8LLAw7vtR73TNjYXZDSt66HxeDaX4G8
/naeWvsyUWTRo7bY7TtI
=PhRc
-----END PGP SIGNATURE-----

--x+WOirvrtTKur1pg--
