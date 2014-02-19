Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaBSHwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:52:12 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60936 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaBSHwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:52:09 -0500
Date: Wed, 19 Feb 2014 13:44:58 +0900
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>
Message-ID: <20140219044458.GA2669@sirena.org.uk>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
 <1392765432-9111-6-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuxWNXB0+C4YKz9o"
Content-Disposition: inline
In-Reply-To: <1392765432-9111-6-git-send-email-mporter@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.145.86
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/5] ARM: dts: add bcm590xx pmu support and enable for
 bcm28155-ap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IuxWNXB0+C4YKz9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 06:17:12PM -0500, Matt Porter wrote:

> +			csr_reg: regulator@13 {
> +				reg = <13>;
> +				regulator-compatible = "csr";
> +				regulator-min-microvolt = <860000>;
> +				regulator-max-microvolt = <1440000>;
> +			};

You should not be setting voltage ranges like this in a .dtsi - you've
no idea if these voltage ranges are in fact valid for any given board so
they can't be set safely.  In general I would not expect to see any
configuration at all for regulators in an include file for the chip.

--IuxWNXB0+C4YKz9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBDbGAAoJELSic+t+oim9HyUP/iejeqqfCwxpuLryX9gF/zid
gBWJp8SdChOm+Tcnqkjad2Xj0jzQE1B4cwH05g06Ak2MTnkoQ+eac4G5q43r3pz2
mj2RhlubkSuD8YuYiJp4AC3+vqa0haoYSZz7qMpOWjcwhuactM5Cd6v7ycgFssu/
kEje6arpNwmW/dySCWZnf3NODXwVPe+vsntkGpiPOJGislw8ojoAc+1oyNWcR72l
lxxJBireQOdx+D5QsQiShbo2IWTnsK/V21IvPBNb67m/JdAY50MsRXAD2PPH/BDG
3SPCBY4FDD6ABV2AYj1hnXik519zD+SYO0NI3eiX0QWjU8QS9Ox0MksuKL+fg3Xb
6iuAeVmA60klRTyABtXVZ2AVUuK9vdQl14vUgyn7fNpfMuplKyWij4+IWwcH9QNa
9enMotRjA8a91fpm/brnJNRvk3dz7I3QoS6UIUk9LnQNzV6NaJydYFUVIlbUgVwJ
tVNpox0e5ypBhBrslawt8bPjFSQX7boRgDvrtX2WsFXyMuOMCtec2TbL3Px/7TS9
+tzCMO5sH5A81c/16jSiFOOarT2qGg5KdR7GIsjB23Xcm9F0q2JE/Y/Jaz8LukD7
/ivgtbiUCJDOyAphJ5KLxHABL7qKDMkQRvZF+nGPEHYkqyB+65tiOvH8QI97PSlJ
8TNCa5ZoXp8KtlzQOlP8
=6XEW
-----END PGP SIGNATURE-----

--IuxWNXB0+C4YKz9o--
