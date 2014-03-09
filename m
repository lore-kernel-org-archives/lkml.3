Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaCIII1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:08:27 -0400
Received: from sauhun.de ([89.238.76.85]:46544 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbaCIIIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:08:19 -0400
Date: Sun, 9 Mar 2014 09:07:53 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        romainba@abilis.com
Subject: Re: [PATCH v2 2/2] i2c designware add support of I2C standard mode
Message-ID: <20140309080753.GC2575@katana>
References: <20140116193345.GB4127@katana>
 <1390236338-21407-1-git-send-email-romainba@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <1390236338-21407-1-git-send-email-romainba@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +	/* fast mode by default */

Please add "because of legacy reasons" since the usual default is
100kHz.

> +	clk_freq = 400000;

> +		/* Only standard mode at 100kHz and fast mode at 400kHz
> +		 * are supported.
> +		 */
> +		if (clk_freq != 100000 && clk_freq != 400000)
> +			return -EINVAL;

You didn't add the error message I requested last time.


--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHCFYAAoJEBQN5MwUoCm2naQQAKHnlAs5QVp89Pwg1CUG0E8S
I8xzKt6poP+bNznTsxNCrQiWJLSGAh3fu6PYtTaIOpF6syuayzuC6PoEP1wCUuFe
6Z4srh5j1+nqmGs4TarLD3+Lu7nkGGalw4KMavpXbR0QdHuGZFJuxmE+iKuhE5Zt
xhuXoK+i4NalPEXoA5c9oGFZ5ETPu7wefu4sANnyYchwDyS1JvmflMqrzC+WqYvz
QiUrGk8Ar3qCMVbRX4guAZklRm/OZnNH2S4/G0cQaVUeERG0f28KsBEaEFYnFG5s
F+569ot/mBeh1LoJQjfjIdHJwKJf4swbjmwNeB78OA5xXfwPVEsypH5GmCeVWapR
j9pbV6LHVyDIXn+HibIlGNzyEVWkc+qs/mFPBz+ZycFKZxLoskfN7UNq7+BgIXfa
/86WFki+iutPv3xCrWNDGEhWvgDAK0sxysJoLev19d0L4WkPhLTQ6Fn/laHc+y+2
1UH2mA334+Cg2sE81HRdg1KZhx7Rya8QO507Dgbu9f+MPOUPd+lpTkE1PnLP9ZKS
hP9UgbR/wLIEA9paMj99hZ9b85mCv0qX7E9u3wX6dtfQZuAKqqPtgj2rKc1YPuEu
HX9BhsxteXMDYtqEGmKwJIYfdxFgdX0j59tx64ru95uwVl3uIA9X7C/MQtZIbSrI
4vLYTXDiHWcgpLwbC97+
=nyS+
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
