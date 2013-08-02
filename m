Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3HBHvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:51:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52333 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab3HBHvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:51:40 -0400
Date: Fri, 2 Aug 2013 10:51:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Julius Werner <jwerner@chromium.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 1/3] usb: phy-samsung-usb: Simplify PMU register handling
Message-ID: <20130802075122.GK24465@radagast>
Reply-To: <balbi@ti.com>
References: <1375404726-26264-1-git-send-email-jwerner@chromium.org>
 <1375404726-26264-2-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVcIhgQsEzAXu06J"
Content-Disposition: inline
In-Reply-To: <1375404726-26264-2-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EVcIhgQsEzAXu06J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 01, 2013 at 05:52:04PM -0700, Julius Werner wrote:
> This patch simplifies the way the phy-samsung-usb code finds the correct
> power management register to enable PHY clock gating. Previously, the
> code would calculate the register address from a device tree supplied
> base address and add an offset based on the PHY type.
>=20
> Since every PHY has its own device tree entry and needs only one
> register, we can just encode the address itself in the device tree and
> remove the diffentiation in the code. The bitmask needed to specify the
> bit within that register stays in place, allowing support for platforms
> like s3c64xx that use different bits within the same register.
>=20
> Signed-off-by: Julius Werner <jwerner@chromium.org>

I need an Acked-by for the dtsi part. Ideally from Exynos 5 maintainer
and at least one of the DT maintainers.

--=20
balbi

--EVcIhgQsEzAXu06J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+2T6AAoJEIaOsuA1yqREKGYQAI2EWPYDjwuIC6wWFnWbpYW4
p+J0+zepF36v5zK1T8iEuYO91Fi/ByyD2s1cQHj7E90spg3hHtXOjs1ml7KzL6gL
ftmXNJp2T4VD1YHvHSF8y0JP9D6nc8/aVViHTxmZZoVE4PzfgD5/fAz7EhGXtiK/
5mXZdPI7TuRlhrxPfQL/juPpQY9bIQWI6Qp2aWLGqY5uydQD7e4PhfO9ZHTF0cfE
SrQmiR1b3JOhHXd41hfYvQRtONoQ5MRKPwCb94zmeE1pdNiRDIBdKPES2En+eRS6
AKLeB0wdDlMIvtfi1zjtVooz4fM0sf69oEmKSTh4iNVkKYx8IsqMTd/0wX+PRYZ3
fYGStuDM12NfFdxrbGVF1nnitFd0pvmxKx/IiRdV6XUxwlukcItrsoRallJ4Mcqd
MwbVSDu5TWgz3drxZQA2dWw5wYS8/S+LKEVwAkWC9qtPUJhCRpXxGHFKdTOoizmd
v12vPXsyncpUuWWg20a9UnQbADbeFwuGT0sbVdJZoR9DuAafZUh/H018aU2xRaM/
TwqM7XGsztuXTECwGl1xvJWB7VOmwlrXoGpjPwJtXrHwYOwINKLyAhG/iWH01uxI
c/MkkodIHYmEJqg4ZBCqmUL32yFGYwZMhyvuiOeH1zuRhOEf4rbv2ViSsRYLzCuK
S3zM1GHQxnYKR7ZV2bU1
=ARgF
-----END PGP SIGNATURE-----

--EVcIhgQsEzAXu06J--
