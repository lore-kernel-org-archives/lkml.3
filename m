Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3ILWCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:02:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54755 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3ILWCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:02:06 -0400
Date: Thu, 12 Sep 2013 23:01:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org
Message-ID: <20130912220138.GY29403@sirena.org.uk>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <3397524.g9aUWuArnm@vostro.rjw.lan>
 <20130910213522.GG29403@sirena.org.uk>
 <2029393.u6DaKBPszu@vostro.rjw.lan>
 <522FC0DC.9030708@intel.com>
 <87eh8trbob.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="579wq2TFqgNMeWbK"
Content-Disposition: inline
In-Reply-To: <87eh8trbob.fsf@linaro.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--579wq2TFqgNMeWbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 12, 2013 at 02:07:48PM -0700, Kevin Hilman wrote:

> IMO, this decision belongs to the PM domain, not to the core.  We have
> an established legacy with the current core default (auto) and changing
> that means lots of breakage.

Yup.

> The "forbid by default" can just as easily be handled in the PM domain
> for the group of devices that need it, so why not do it there?

Or at the device level - I'd guess most I2C devices won't end up in a
domain outside of ACPI.  Mika's latest version of the patches address
this issue, the default is left alone.

--579wq2TFqgNMeWbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMjm/AAoJELSic+t+oim9+QEP/0k8z1eX7gkWT8LZAirKrNCV
bIrjbPcaafu6bZZWM3jZYmM6Lv7/OzHDoPlBIBzYVUfmqnAavjt/XGIrUV1DEmN3
RCTYLDOIVvci7CAt94kOcNlcEQymU3iLbPFYaMNFKUQMl2VE96S23MVbZQBuY/21
2g0kjU/dE05/k6fwe0kH43FnQSrMg3pZ6iQjpEC4HvwPLReJwvDoMylJEX+dUCrY
nDhrhG+G3/pJA6dJ1FlHatuaDybQEDO9B4rhGratsRfCro8I74ETKdnaOJL0ls7r
mbNb7cWJ88G4Xfn68P8kkyI9ZsbvBrcjFUXHIaxMxFZD/EKiE66+0ZuCC5D5MPmT
fvwruMvzAIfXqYIhquazx183VipEVfZYNMUh35Q/0XTx2d+lUcB3dYMmmsl/r+1C
n38IXGiv+vOrXpt6AREcJj6Kdsy2atqNyl7a2/y6/mhW9ZEbsHykgm4tSobLo+6v
+plONpdkTuQ7rEPnk7moqw7k0UKaIgzpDgGCA06/XIa3CAbcw8t9NY8gsiQ5cyr0
88lsjorpVi1OmpJT/uyNVefIF4n9JAYkuh9Uc4NheCCwKsMB4K1H/zLxGCav9eYJ
m1zgZXkcY/TcE3g9KWn5cD0G2ZIDd7oQpXKdZ7YBAgyZox1mq6obVwIffO3Gt5+X
H6/TyjtLAcnfR+JgGHlX
=W0wz
-----END PGP SIGNATURE-----

--579wq2TFqgNMeWbK--
