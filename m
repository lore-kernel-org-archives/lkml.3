Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab3FMSXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:23:36 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63278 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3FMSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:23:35 -0400
Date: Thu, 13 Jun 2013 20:23:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] pwm: Fill in missing .owner fields
Message-ID: <20130613182330.GA32574@mithrandir>
References: <1371036553-32263-1-git-send-email-thierry.reding@gmail.com>
 <CAK9yfHyUT7KUkY3g2WJ7XiisLL5mvJuenv=UEK_9OqwfF7s4Zg@mail.gmail.com>
 <20130612195917.GA31835@mithrandir>
 <51B8F729.7030907@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <51B8F729.7030907@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 12:33:13AM +0200, Lars-Peter Clausen wrote:
> On 06/12/2013 09:59 PM, Thierry Reding wrote:
> > On Wed, Jun 12, 2013 at 05:05:18PM +0530, Sachin Kamat wrote:
> >> Hi Thierry,
> >>
> >> On 12 June 2013 16:59, Thierry Reding <thierry.reding@gmail.com> wrote:
> >>> Some drivers don't set the .owner fields of the struct device_driver =
or
> >>> struct pwm_ops, which causes the module usage count to become wrong.
> >>
> >>
> >> Recently a patch [1] was added to solve this issue of missing .owner
> >> fileds in struct platform_driver.
> >=20
> > Yes I saw that, but thought it might be good to initialize them anyway.
> > Especially since a couple of the drivers are I2C and I believe there's
> > no similar patch for those. It shouldn't be difficult to come up with
> > the corresponding patch, though.
>=20
> I2C had the same actually for quite some time now.

I wasn't aware of that. Thanks for educating me. =3D)

Thierry

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRug4iAAoJEN0jrNd/PrOhHQEP/AovgWaYRMuDq7ODJQJDtIhv
HFUyMVKDTeiwka0WksEO9UytNhHlv2+tV1XlMmhAF+0mtzyeY7j7vo3Qh1FeN5Uk
Fkyz3poLAMRLIQhnq/TjEJwjBadKhjsVsxbLOSA+S7EW9mzpsa6q9c3Xo9AOevbW
T48OsWW3pPSwnVgKIqfOVhtK5G5/SNolj7wuYAvbTMxEcB4WggZu7VV4VDOb/b8N
poUnecSF7hHHUsHwljL2jAn4oVaklzqMypORqeaNQKhA9LToq9yG4pPbPQuyN5zm
jhYi5PJGHYHuhNsZLf3GHFz3GW0WYlDYL/i6s46UbzMlDN7iICryQrP1xoJi0S1W
gm8jBNyDOcsPNV6xliRA7bd/mXCgbY9hq3DsMwC0X2gVucvhRh5oExXrQazEZQ9E
KhCYKIexcIoRESlV+vB/SgH5+lRk+Por3vJ4BPppmZZlGVp8c7Zwv0hoU+ZenyWU
FhAWE87nhxW6I/rECFF/00AanQLbD6DjiKisSRCyuj8pR012ouz175IzN+5ommCp
VgAFcor339Ro/hEwi+Gy7UGwc21JPFv8YAKEKkl9dKNEHE4KBndTyRR6DpN3+VQF
YvufhMG3bUKYPVLH/ibGRLw6ZTtgZ8pgBtfpvPKwcuwiwk4s44OlxtxxSb6iZo4D
KJiJiZDjzZdDui0PG1Py
=/18E
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
