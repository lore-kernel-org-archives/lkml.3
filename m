Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3FKLwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:52:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48084 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3FKLwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:52:11 -0400
Date: Tue, 11 Jun 2013 12:52:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Message-ID: <20130611115206.GA1403@sirena.org.uk>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
 <1370621488-18130-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KjcUHqqCp23GY06r"
Content-Disposition: inline
In-Reply-To: <1370621488-18130-10-git-send-email-lee.jones@linaro.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 09/10] regulator: ab8500-ext: Enable for Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KjcUHqqCp23GY06r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 05:11:27PM +0100, Lee Jones wrote:

> +static struct of_regulator_match ab8500_ext_regulator_match[] = {
> +	{ .name = "ab8500_ext1", .driver_data = (void *) AB8500_EXT_SUPPLY1, },
> +	{ .name = "ab8500_ext2", .driver_data = (void *) AB8500_EXT_SUPPLY2, },
> +	{ .name = "ab8500_ext3", .driver_data = (void *) AB8500_EXT_SUPPLY3, },
> +};

Should be a binding document update for these.

--KjcUHqqCp23GY06r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtw9jAAoJELSic+t+oim9vOMQAJXqr8zKrsCLjf8ij0Biegek
DLb6unz22VgsMUEXgFBQnQ1cuBGwwmkYRFwrn8S8vy8Xo77aG1YaJmQe1auqA0sa
pFYUAl+7ffyOtwVUeb2YfP8QcO5pDTzuqENbF+HE24kgUHXkYh/FHhBeepSQDa1M
vZMJ+RHu9XxpaX2vk3exOGGrJvwZafUl/emNEl/h25MUf6pyxPDgeNQX598UIJ4G
LSo8PQVIEYMJ2EGQn0J9aqVrnQJ+ptQuaQDRX4U2uZPVPcSfAk5Wf/HblMp36GYB
8H4yaAGUa95gQqGWqCCl6Vydeb2UOxMB2GDtAF0Iq5CKFKz13QDh/vxt+OWaSiTW
VrX0hYCLOYDSr8mCKyjWw4JD6yJ6O3KK9uooBVqItxICZ4lXfd8s2CcbFvkY5vzZ
oIQnHRdBAA/74pS/wWXw1E7kirubRZqBeGXIEWQrqhjCPxzlNgQPza5NGA/l4gY2
zzx2tz/OYl1BJnlt1AhjURUNZ9xTM/Tc9FA4ouK83J2b2yr6ERN9n3zY9qhTmDK5
fP2liiSc/nvTzJ1Qrk4LAWDQnkTakT4oVNPhfOiW+DJ67v89+UL1cv+iOw/coSRE
djFBI8l75ABkBYLhFz8NWa1rp9tP+P0N+jjNq11UN9ZHKsQgwhKrRTGbxG+ICcXy
wl5Pd9Etc9/+/pyAJQv5
=lHsW
-----END PGP SIGNATURE-----

--KjcUHqqCp23GY06r--
