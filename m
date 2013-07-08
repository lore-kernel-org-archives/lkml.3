Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3GHNWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:22:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51598 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3GHNWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:22:00 -0400
Date: Mon, 8 Jul 2013 14:21:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com
Message-ID: <20130708132119.GB27646@sirena.org.uk>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
 <1372510280-31931-6-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ZYmCFUXJGH+43jh"
Content-Disposition: inline
In-Reply-To: <1372510280-31931-6-git-send-email-yadi.brar@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [v2 PATCH 5/6] regulator: core: Remove redundant checks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9ZYmCFUXJGH+43jh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 29, 2013 at 06:21:19PM +0530, Yadwinder Singh Brar wrote:
> In function _regulator_do_set_voltage(), old_selector gets intialised only
> if (_regulator_is_enabled(rdev) && rdev->desc->ops->set_voltage_time_sel &&
> rdev->desc->ops->get_voltage_sel)) is true.

Applied, thanks.

--9ZYmCFUXJGH+43jh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2rzMAAoJELSic+t+oim9FeoP+gOrbG40ofDiv8D/BvGTmphc
GtaxUzDnosG5T9XPbWTBoQlu9b3wLSfrY16Gqg5D0EiwRKBTGw6UviC7qCE3u1DR
085ACYVqs2avjPyhHyFsL7F4aU1BO7X6nwfpVriBC2pk/vacuiPrT0N8Cbz5M3dR
P47CBLFUe7/Z69vmhYhXjCexgOZEe9G1nQBEu7sNibURHF3eAEqIHmCDzvtgR0a5
PINzl9wHsBOTXB9JnX6XnDriSQPm9uv3bWBaaNk6aXw05YPO7TUFryCWtY+ONLuo
WC2iPveDwK5J97ddCdKyzuyG7BwrEXcAXIIV05e1shJXBgmO9NIGjQr9FZCbnTCW
saDLBCZzZMl4qcxpnhBqLKb1nVR58lgKNdE+1yO4KAASgDRv3niJk32NSUk3uPOp
CZQGSnNDYmoZ+KZtiN3tbLZU3MHpKah6ioQDy7GPUC9vBFJkV8BEzTreLvi80A0T
T1cBQaCK2aX7RZBn7N8cSQRi+8h7wGQGSBuUnIxlU+I+zeSy/hzMiD3ost5CLgpV
Jk5oEHtZVEyDqa+FO1TfCdAU3FC3X2iExBKGQbbOyi1PHat+cI89YcqlJiJvMqRQ
0a3sTK5hhVzVet2R1/v6A/kfNMziiAW5wExDcXD6zLYo1IS3Io8x9oikN2AVOcSA
NVTYmOXPoTyQg91eL4Re
=AYWo
-----END PGP SIGNATURE-----

--9ZYmCFUXJGH+43jh--
