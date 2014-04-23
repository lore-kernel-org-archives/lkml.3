Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaDWNjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:39:19 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:43041 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbaDWNjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:39:13 -0400
Date: Wed, 23 Apr 2014 15:37:53 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [RFC 4/5] drm: Introduce drm_set_unique()
Message-ID: <20140423133751.GA28031@ulmo>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
 <1398179373-29966-5-git-send-email-thierry.reding@gmail.com>
 <20140422154807.GT10722@phenom.ffwll.local>
 <20140423071714.GB31226@ulmo>
 <20140423084057.GY10722@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20140423084057.GY10722@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 10:40:57AM +0200, Daniel Vetter wrote:
> On Wed, Apr 23, 2014 at 09:17:16AM +0200, Thierry Reding wrote:
> > On Tue, Apr 22, 2014 at 05:48:07PM +0200, Daniel Vetter wrote:
> > > On Tue, Apr 22, 2014 at 05:09:32PM +0200, Thierry Reding wrote:
> > > > From: Thierry Reding <treding@nvidia.com>
> > > >=20
> > > > Add a helper function that allows drivers to statically set the uni=
que
> > > > name of the device. This will allow platform and USB drivers to get=
 rid
> > > > of their DRM bus implementations and directly use drm_dev_alloc() a=
nd
> > > > drm_dev_register().
> > > >=20
> > > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > > ---
> > > >  drivers/gpu/drm/drm_ioctl.c | 37 +++++++++++++++++++++++++++++++--=
----
> > > >  drivers/gpu/drm/drm_stub.c  |  1 +
> > > >  include/drm/drmP.h          |  3 +++
> > > >  3 files changed, 35 insertions(+), 6 deletions(-)
> > > >=20
> > > > diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioct=
l.c
> > > > index 2dd3a6d8382b..371db3bef60c 100644
> > > > --- a/drivers/gpu/drm/drm_ioctl.c
> > > > +++ b/drivers/gpu/drm/drm_ioctl.c
> > > > @@ -42,6 +42,20 @@
> > > >  #include <asm/mtrr.h>
> > > >  #endif
> > > > =20
> > > > +int drm_set_unique(struct drm_device *dev, const char *fmt, ...)
> > >=20
> > > Can you please add a bit of kerneldoc for this? drm_ioctl.c isn't yet
> > > pulled into the drm reference docbook, but better to have it there
> > > already.
> >=20
> > On second thought, wouldn't this be better located in drm_stub.c? It
> > isn't really related to the IOCTL code except that one of the IOCTLs now
> > uses the information set by this function. Logically I think it belongs
> > with the likes of drm_dev_alloc() and drm_dev_register().
>=20
> Yeah makes sense. Tbh the entire split-up of these core drm functions is
> still a bit messy, so I don't mind if it's a bit inconsistent really. We
> can do the suffling when someone bothers with the kerneldoc for all of
> them and pulls it into the drm docbook.

I ended up doing exactly that when I wrote the drm_set_unique() docbook
pieces and I've sent out patches based on top of v2 of this patch just
now.

Thierry

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV8IvAAoJEN0jrNd/PrOhgc8QAIIzvoPVJoHUsdSf040OrFUV
PQ8sxQ4O3QkgGOOrfMzu3RtsmvuyBzMKKg5X61U+5PD3lc9YEiAUcLQxLUO6XDrY
hxTurd4clqu69LxwlQe8nRPRJd02aYbaHI+N5IVEsrSuNGN4+Clp0MrnTfe7Tb9R
sA3ZJc5CuSD2HaTsVCyGDbkiN183SN+A2wExcsWBXhEfMTfsdTMrGNNqaQnFHYbl
XVFeeJGzSHosycWr1285qZI+5NDwonxNiGEPo9bN5eh7Xb/vOEDu0OsFiu6e1kkq
Oychp5pYAkFrOo7ZJcnayj1UHsLvmYrXWR9X+1l9DD7MQe20Q4RTCUho665juR9O
KHiwWN37pbtdGx+xPXWedPr8Rynmi8iM6N1qVwgHLNTErYsrE7GP/hAJpSF1jU7Y
zZk3GkXQODVg1M4eix/TYTt2frOAPLhYfalk1ymaLOR6dH2cQryRFQitJaT7Cba+
UPAL9Bhi+80HZGPVxJ1u+lYqX9YP22qFsBM61sCDTD6Hsia5zJ36aasbsYCcX4Wv
pPYDrJ9yj/6wlyQwvtzsIC/8ST5NKv56vNZ8VsD1iJSTEYBAowbcPVUQcUn7T9nA
gK45SpBsXYffv2j4yL70pG3XKni+EjtDoAX8RnaNX/59uK+iCKUbH0vE8z/QwCvP
b2tAEOFO1aiHkJMVpWqG
=9ZtZ
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
