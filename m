Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaF0GNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:13:55 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:51467 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaF0GNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:13:53 -0400
Date: Fri, 27 Jun 2014 08:13:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH] pwm-backlight: use devm_gpiod_get_optional()
Message-ID: <20140627061349.GE9258@ulmo>
References: <1403687898-26881-1-git-send-email-acourbot@nvidia.com>
 <20140625095447.GT13803@lee--X1>
 <20140625111346.GB21208@ulmo>
 <20140625120331.GE13518@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Content-Disposition: inline
In-Reply-To: <20140625120331.GE13518@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 01:03:31PM +0100, Lee Jones wrote:
> On Wed, 25 Jun 2014, Thierry Reding wrote:
> > On Wed, Jun 25, 2014 at 10:54:47AM +0100, Lee Jones wrote:
> > > > Make use of the new devm_gpiod_get_optional() to simplify the probe
> > > > code.
> > > >=20
> > > > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > > > ---
> > > >  drivers/video/backlight/pwm_bl.c | 7 ++-----
> > > >  1 file changed, 2 insertions(+), 5 deletions(-)
> > >=20
> > > Looks good.  Applied, thanks.
> >=20
> > Technically pwm_bl.c is my turf. However I only adopted it way back when
> > the backlight subsystem was orphaned, but it seems Jingoo, Bryan and you
> > are taking good care of it these days, so perhaps it would be a good
> > idea to move it back to your custody?
>=20
> Yeah, the whole 'driver maintainer' sketch could get pretty complex.
> It's pretty clean-cut in the PWM subsystem as only one exists, but
> Backlight and MFD have a whole bunch, and I don't usually wait for
> them to Ack/Nack before applying or providing review comments.
>=20
> I'm happy to play it however you like really.  I'm sure the boys and I
> can handle it if you so wish.  Even better if you would say in the
> MAINTAINERS file and provide review comments when patches are
> submitted.  I do think all 'drivers/video/backlight' changes should go
> in via the Backlight tree though.

Okay, that works for me.

Thierry

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrQudAAoJEN0jrNd/PrOh3qcP/0HAB0YfMos6D/uMlSOU4Dto
ft79uF12FwctgIfEGNaXNbbb7mqiXhuP5FoP3A/HGqMqjkaspKe/u9zJBKAhkSzV
Z0LKsar4BBbHBa3Z/LjYw2qQ2YEiSmToV3d0NesoSL90R3TyVYh8krsM7qraRVRB
uMogoWF4LC5CQcf13IzUnIYct0DBi+G32T1oGWpqUxLOoo4vL7HLv4zWnQmTCF+J
iyB7T14pmDCZSR63jqFDdyn5VAsS1/yf54dwKbCsHf7izxqgxlgyHvr/IrhPFwuK
kxwUSnK/iVPwjxYTwRdeBcKFzwawqtFbIuNVY8iKBUFibKAfXeZTHPKF1shDEXFL
uuzAXTqGPgYfqTV6ID2RMAnLW3tQAZMz4KDX8599xPVAWMlmZnWSKUCbHI1Tbmm/
WDFZKpj9UC8T0/shFOhFRI4nNSAZHOr1CRoTfzH8URI1unBP905KoAZyIfsGoucB
2WCUCXiAgNOdMtNmJ7TYquEQmStBj1AxV0R4JFWlXW9ciHfAWvFlJkDDptqa0jUU
r0E8+n2/8dmp+fgvNUGjvmSKXz4gKzAgXYFcJHChjc+lzrPWnGaIM/uUujxSdMPt
MptiL/dEWCk1xS/2fvhphAU6vfSwyRsXFdCxNtp7QXCAD1+6YaGJnGTBMqIrwVf1
wrzTYarbLlEauQwamC+x
=N5OM
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
