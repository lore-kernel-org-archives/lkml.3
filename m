Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3AaGkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 01:40:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46392 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495Ab3AaGkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 01:40:53 -0500
Date: Thu, 31 Jan 2013 14:40:42 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anson Huang <b20788@freescale.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, shawn.guo@linaro.org
Subject: Re: [PATCH V3] regulators: anatop: add set_voltage_time_sel interface
Message-ID: <20130131064038.GA7663@opensource.wolfsonmicro.com>
References: <1359649433-3691-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <1359649433-3691-1-git-send-email-b20788@freescale.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2013 at 11:23:53AM -0500, Anson Huang wrote:
> some of anatop's regulators(cpu, vddpu and vddsoc) have
> register settings about LDO's step time, which will impact
> the LDO ramp up speed, need to use set_voltage_time_sel
> interface to add necessary delay everytime LDOs' voltage
> is increased.

Applied, thanks.  It does seem like...

> +#define LDO_RAMP_UP_UNIT_IN_CYCLES      64 /* 64 cycles per step */
> +#define LDO_RAMP_UP_FREQ_IN_MHZ         24 /* cycle based on 24M OSC */

...this ought to go into device tree too (at least the oscillator
frequency).

Please do also use subject lines appropriate to the subsystem.

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRChHcAAoJELSic+t+oim98JwP+wQTOZs3SvX4yvG3pCvTT285
bX1XtD/ySNqagIc6dS4XNa4DS7JuQ5p2BsFVmfoUzqBKIJW02h+TLMXm3iWkwdh2
p8ZeR5qU3UPlPEEjGqR3bo52T3XI2cV15QYqSe5KdgvUWdBlaimuXxY7NT6AttqM
wPGNAZ05dHVl8Ry7RTUkMmpAP8/0tO/O9aqNizJcq++M5/woxIqU5wg0+d/EG+tJ
moR5LyCHHfP+NhwsQlBEQPdM1D8K1CGRGlJAXt6Ipgb3QytC+N3EsLrF5EZri8t7
05D6+0iRerSso8MDMh5G62yestwwsnSQca3XjG9UiQp/cZoRtWVRMd6WQ7hJTYpP
pv011Kidavz711z1ZXx26E+3VOuZrmWU8jdzsg1Xqpp7hnJtVc24iX5h/c7ETshf
gGRvSCYVceZNyVenauC+AOc3KYFR+pKypyPxYKZwA8hzcgIwwdBmPy50b40PcMAP
ZzobGqpJG5atpYX7iHbwdt1dTpKkBTjSEq9x4VWQ2x3UxUEbAreNf91M8vwggZ94
ShcytaBT830F/+vO4iFU4xs25EaGuYVR4P7LSPxcrbr0xvLpWEAiOkNSo1FWnH66
GYiw6w/SANoijX7owEsBN7TAqPfC+UUu+T74BXykkjdMWNTsemHt3alauBhknNef
kTA0D0rBCbMU2I3PWlzn
=ewN3
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
