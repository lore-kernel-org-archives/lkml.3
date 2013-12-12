Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3LLQxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:53:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47954 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LLQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:53:05 -0500
Date: Thu, 12 Dec 2013 16:52:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        vpalatin@chromium.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com
Message-ID: <20131212165240.GP11044@sirena.org.uk>
References: <1386811131-2720-1-git-send-email-wenyou.yang@atmel.com>
 <1386811131-2720-3-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jXoUnAu9pZeaHebo"
Content-Disposition: inline
In-Reply-To: <1386811131-2720-3-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: act8865: add device tree binding doc
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jXoUnAu9pZeaHebo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2013 at 09:18:50AM +0800, Wenyou Yang wrote:

> +Required properties:
> +- compatible: "active-semi,act8865"
> +- reg: I2C slave address
> +- vsel-state-low: Initial state of vsel0 input is low, to select default output voltage.

This needs to document which regulators exist and what strings should be
used to select them as well.

--jXoUnAu9pZeaHebo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqenVAAoJELSic+t+oim9/BkP/ApRL883vwdxH9/+6SLLTeAR
zP56qDwEj0qQthkHO9E9X1x3Dt0FalWOAtWjIa4MYpWw9O5GSpRStbxoouugHOXh
2sxnJip5MzFsWBaUdXgKtK+OskhdWTdZUfwqmwnT84KoyNvb3la5iQFXBAokqiDp
LeoKK/yHmk+1MTB1AAIJVMlUjpuZcsFJO+RzQ7mVVCsqe5jIG2ZLr0Jxomg1bqgx
tR13mW1cl3Ae1ySNd6sPc1jdFSklZiuCZ7gZvNLckqxsMTqmsmc0K5TjaG0HcOUf
duGVI6Q27iWy7Y8nTLIJMAxhcUy5RL1CVarx5yoAPhxLgZH2ZBMVORxoZWTExFNv
rtkImo9DptK3P4lAaTm/dvQ1e3ltN9msSbJm7rE6JSd74hhTI7vj8b8nGto5S4x8
or38kf75syR08DE5cyvzfIUR4CwKGUryCnkMOGZIpMKOiUrQqE7CCKAw7egE38+A
7fZ86ahHkZgdkKIMZWcWhDDKJHIF4CeAtSjhBq5FCQfd6Xvc4Xo+2zIerpIujZWp
XKMXkIXSGX+2znLZtSEpqB4Zzn4I9wJqcYaLaD2jBC1J6brx6J0tQrW2KWB1vIU6
rjAEXZX4cwJ0CJYSXLpiyIKZCZG4scElAjJOZXdpfRUZ2sa/OW58awawbkSf9mTp
HveVukqe6s2U+19Qxdrj
=748T
-----END PGP SIGNATURE-----

--jXoUnAu9pZeaHebo--
