Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaAVUTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:19:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58355 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAVUTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:19:38 -0500
Date: Wed, 22 Jan 2014 20:19:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140122201932.GD17314@sirena.org.uk>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
 <20140121185553.GW17314@sirena.org.uk>
 <52DED341.3030503@ti.com>
 <20140121215624.GC17314@sirena.org.uk>
 <52DEF56C.1000209@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M7C8deoQiHu/TN9U"
Content-Disposition: inline
In-Reply-To: <52DEF56C.1000209@ti.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M7C8deoQiHu/TN9U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2014 at 04:32:12PM -0600, Nishanth Menon wrote:

> The other alternative will be to use reg-names and map individual
> registers (there are just setup and control registers to deal with per
> abb instance). That will coexist with other pinctrl, bandgap and other
> drivers which are not based off syscon.

Yes, I suspect that's going to be a lot easier to deploy given that
there are existing drivers using the current non-syscon setup.  I'm
totally fine with that approach.

--M7C8deoQiHu/TN9U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4CfQAAoJELSic+t+oim9yCkP/26nhSpmqHzgZBj7ol+IB99E
bSYbdzaFVD24DueizieloBTdGu0FdBhEvMf4VCC3B8JxrI2Zw9A6Y20b2PHBQu39
JuHP6QoNbAWso7OGuiXsNXAmbdZOgarSKahrwhH4hPskYy4E2hL+lWeqoJoyHq08
MMPtMFdkga767Ebj6S4JeMLDMDic0YtamctWe4dh14EHDO0TfGawOdUMSEQZFZ2M
Vhe8LD0rz4m9fmj8MWSc3xTzO3XH7CUT6FJQ6fU1RVNkjoXsd9qEr8XsRd5rm2Nf
CsIYalH/SSZ0vWCPOPDy1YOjuUm2bFdo8Fv1zRJQqi5DspXccpp4vzOFUIfuu9f7
IEckLIe97X1O2sUoYQld7DBW1UcTIdGzfZkhnsVNwHPNMfo1/YchUaRpNR6cPFxd
mcWoZP9BZgGs8KT1sw2dfLCJnMLYGdgxXWce3P6x7TrJ4WoQrI0FOACBUNMX/QOj
6eVaO95/18GqNgsDFIoIGz/9OSKi2ak2Lzy97VlqGuhYfkTW/mm7kwp2MRF8Z1OK
/zWzm6XFlGn3+Mlo38ogZNmlxrkifaSfRMoBcDMBwQbzv8Ufy9whEO4ax+SqAaWW
zAbsa2CdEda1/9GuHq+Xw7wMQ93f7rXvrnX0PYmHL4QsoUSMLZd0dh+H3sbLtink
yMpsSQJJX+1YZ2Lee5k7
=9y0b
-----END PGP SIGNATURE-----

--M7C8deoQiHu/TN9U--
