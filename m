Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaFUUlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:41:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52588 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaFUUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:41:10 -0400
Date: Sat, 21 Jun 2014 21:40:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140621204026.GH22657@sirena.org.uk>
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk>
 <20140616192500.GJ5099@sirena.org.uk>
 <53A01D54.10506@collabora.co.uk>
 <20140617141254.GP5099@sirena.org.uk>
 <53A06749.1010606@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIIRZ1HQ6FgrlPgb"
Content-Disposition: inline
In-Reply-To: <53A06749.1010606@collabora.co.uk>
X-Cookie: Dime is money.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 17, 2014 at 06:05:29PM +0200, Javier Martinez Canillas wrote:
> On 06/17/2014 04:12 PM, Mark Brown wrote:

> >> I just looked at regulator_register() and saw that it does rdev->dev.parent =
> >> dev, so yes this has to be the MFD.

> I noticed that many drivers set config.dev = &pdev->dev. The original Chrome OS
> max77xxx driver and max77686 are two examples but others drivers do the same:

Not all drivers are DT drivers that bother specifying supplies.

> And also I see that mfd_add_device() calls
> devm_regulator_bulk_register_supply_alias(&pdev->dev,...) so I'm confused now
> about what the correct device should be...

Right, but to do that you need to set those aliases up - have you done
so?

> > Do the regulators manage to get their supplies?

> There are no current support in mainline for the devices that use the regulators
> in this PMIC so I can't tell you if consumers manage to get their supplies
> correctly (e.g: if regulator_dev_lookup succeeds).

That's not really relevant here - I'm asking if the regulators get their
own supplies rather than if anything uses them.

--WIIRZ1HQ6FgrlPgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpe23AAoJELSic+t+oim9ByMP+wYqiynHTb+Xzz0LdWDlo0u1
Ybojhgpg93PB0jwTEijpHnFI3hDTyP1Ozn+EgvSrMkFFs9zd3yZrEUGZrpC8k8Rs
CnCNzv9z+A7phmVIwzOH5cgO2lN7OOQIuQwmoozTFj+H/fpOVux+AaHhMRswx5HB
5a48oHkbZT3CoJtY33wEBtcd31R34X4T5nwIrAik+myvFl27yFjQW7ofGCk3Fd6r
Kj4evF+NbJFTZB2DzpRsyj2b+H6YA1WPC+3aJHCow0EU9dwL9TqPW5rXLvK22fAs
/ulY2m3LFdK2gsugor4RSF0srkXITAkjsXPEjSkDT5gs38eyPFB4vlOSHuvzPd8b
4sEWw9YsWPQHhTF9l5RkZKlvfxAnYyEUBSScAmBYYKtVqiSDJHPhLphKC5NLdDYT
5txobNxpELaj1sTeuN7pzXM42OhxNT5P+Xn4jqip+N40PZPDIp6gAeHtdgrV3Bsz
2+AfZnh+WO4PeD7nlMj5dG5YIh/jp0jKR6JFgZ62ZFWTsdIQ2+Wl3fkqlsYpD371
oBYAQT83Zm7LNun1zwZeDLsRC1gU8cIXque1A/s7DS1HajrP4Hih5NoTvYTtQQjO
7+/Tt0velX53qq2x2/fNmk3sbedfJm9NOmA9G9DMFPk34EfKW3N47FsoBf5Ax55t
8CqmWZjvMm7cz6bXpCV/
=Qdml
-----END PGP SIGNATURE-----

--WIIRZ1HQ6FgrlPgb--
