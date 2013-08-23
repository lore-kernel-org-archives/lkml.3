Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3HWJaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:30:22 -0400
Received: from mail-bk0-f67.google.com ([209.85.214.67]:56351 "EHLO
	mail-bk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3HWJaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:30:20 -0400
Date: Fri, 23 Aug 2013 11:13:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, swarren@wwwdotorg.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: dts: Add Freescale ftm pwm node for VF610.
Message-ID: <20130823091309.GH3535@ulmo>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUk9VBj82R8Xhb8H"
Content-Disposition: inline
In-Reply-To: <1377054462-6283-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUk9VBj82R8Xhb8H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 11:07:40AM +0800, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  arch/arm/boot/dts/vf610.dtsi | 83 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 1 deletion(-)

Please also pay attention to the correct capitalization in the subject
here. "FTM" and "PWM". Furthermore this could probably use more than a
single line as patch description.

Thierry

--SUk9VBj82R8Xhb8H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSFyelAAoJEN0jrNd/PrOhBXkQAJI+69TMKBHD21Mqi9NCseew
DAu0qXS707U0FMaNgM8iOF2p1S+lHojZrjDQB9gt2HqDzTLNbLo0/GfYm5xObnkj
G1UsgslgSZ161Wi7eQWif5vG87jBl1brX6DXPKiHViUYbZ4E1JG3gyu7DgSdGUWK
fncoBvIF0qoPpYXkBj2iX4bq8+sKvXVxwUQs435iLXh3JOHKiF/w89IvOgBsyiH9
A/x+qmjsjikZTYE2cZVtAlO7jLXgqzH1HK4kgsCJbb2sJKSRPHJff6yHGiJhxlKA
gQ4YS//qWFUrd7E/ggYtY4UjRYvC5LYIcuB8+t8MzMYxLzPxl1Dh0Ad04vbOTLsl
FUntukkPPHRJukcaUHvtWx7GTZVIzlnoXQTspDsZpFtV5mI06F4oNCTKOMTPOrB3
v2HQp0W68HMov+cWZbjUN1fGO3FqysKjQ/eDJ/P5D+X77bZaJS3NLpoNl6pUK+SH
QP+Kymnh0BEMukES44yB6lQ60scmvAr+RcdFr13A0bc+43sXquQAeox7XfmjaEF8
vSX4RiRzTnxl4CDW3tY2ekwIJP7XsE9xAdxWvl4BVzt9APM8NpOlBde5KLqgPZ2B
8OeFodtA2QAz6GD6Ycg3x6mYt5Vf+ed6yWlnZu05IlnQthNsdvCWgZtMUt3Qk0V7
daL1LB+JMLzMhXkN84Ef
=LEb+
-----END PGP SIGNATURE-----

--SUk9VBj82R8Xhb8H--
