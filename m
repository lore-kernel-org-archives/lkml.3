Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3AXMBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:01:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57563 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830Ab3AXMBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:01:04 -0500
Date: Thu, 24 Jan 2013 20:00:51 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com, anilkumar@ti.com,
        tony@atomide.com, hs@denx.de, lrg@ti.com, sameo@linux.intel.com,
        khilman@ti.com, linux@arm.linux.org.uk, rob@landley.net,
        rob.herring@calxeda.com, grant.likely@secretlab.ca
Subject: Re: [PATCH 5/6] ARM: regulator: add tps6507x device tree data
Message-ID: <20130124120050.GP4955@opensource.wolfsonmicro.com>
References: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
 <1359024920-32190-6-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IYV9cRr2u6rjcP4B"
Content-Disposition: inline
In-Reply-To: <1359024920-32190-6-git-send-email-manishv.b@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IYV9cRr2u6rjcP4B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 24, 2013 at 04:25:19PM +0530, Vishwanathrao Badarkhe, Manish wrote:

> ---
>  arch/arm/boot/dts/tps6507x.dtsi |   47 +++++++++++++++++++++++++++++++++++++++

Why are you putting this in arch/arm?

--IYV9cRr2u6rjcP4B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRASHyAAoJELSic+t+oim9XVcP/i8d2OXORqtJb2RwAGdUtzVA
QvsP5eABuMJNDLrIzcbVm+aHKhjXUnBk0Z6wCWLgOzGwsn5uUAaMzAKK15mbXQeg
C6o0NMA+lGsRUM8k2GNkeIFwrkX/+ly9c1+KVUo20hpqoPeOrVW0bMVpPip4y/Ry
5V2nP5K6YW22iPkZUBOpbIo1V2mJcH2qy0USGkjJO4CdjfYb01wg5D4hotdz/mfg
scJp2NBwm35yg0ShLm0hwUGEHSbF3uhrQask6HD0A8BK+4YwuRXUGRllV7lL/ZpL
wqrot4SZgSu0MjLX+zGYZwMx+5Tmc50abpxkA5322QlBJFeqEdYOY3RND1w/avKH
cDsHi+se8CVxW8+AVvzOCAHx+7kRPXz+ITNlz8dTQoQZsinJVCUV0RXtYiPs5NY4
QR7vqvnIdQraLp1piBUMAzNpavR8twJH1z4QR5+ugYElJ2cZ+OUOG5X8ElYRe+FQ
hNA07QP18xIdj+jlZa91PbyxXRXK1VaC9CJlVYNim5VNuwwpmLlFwSgXp337tW6J
ZmYW7ieCohbFqlbUtWEzk7pOpDlG7kRyAg7taqXc1SVHoy3kXZFatYWJxrf22de6
Mysb06hWn652ux7QpXTZkSX3ejPVX61reQjprDoAYmNqYJpCZL1ozy0yKnhEVHei
TVTNhNSfsdMMfsF6TkdC
=vriK
-----END PGP SIGNATURE-----

--IYV9cRr2u6rjcP4B--
