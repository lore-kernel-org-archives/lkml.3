Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaHTMcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:32:35 -0400
Received: from sauhun.de ([89.238.76.85]:46651 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaHTMcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:32:33 -0400
Date: Wed, 20 Aug 2014 07:32:11 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
Cc: Mark Rutland <mark.rutland@arm.com>, atull@opensource.altera.com,
        baruch@tkos.co.il, mika westerberg <mika.westerberg@linux.intel.com>,
        grant likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        skuribay@pobox.com, rafael j wysocki <rafael.j.wysocki@intel.com>,
        alan@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        delicious quinoa <delicious.quinoa@gmail.com>,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree
 setting
Message-ID: <20140820123210.GA1373@katana>
References: <20140820092257.GA21174@leverpostej>
 <944257148.1724.1408528177642.JavaMail.root@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <944257148.1724.1408528177642.JavaMail.root@abilis.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> With the patch "i2c designware add support of I2C standard mode" I already proposed:
> - I2C standard mode is selected with 100kHz clock frequency.
> - I2C fast mode is selected with 400kHy clock frequency.
> - EINVAL error is returned if clock frequency is not 100000 and not 400000.

You forgot to send this patch to the i2c list. So, it didn't get into
patchwork which I rely on for tracking patches.

Please resend an updated version to the latest codebase. I like that it
has the EINVAL error checking.

> What about the other patch "i2c designware make SCL and SDA falling time configurable" ?

6468276b22069d4442aafcd8c59e5d8ccae23f5f upstream.


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9JVKAAoJEBQN5MwUoCm2H3sQAIJTQq4H42z9vdiU5cIB5Z55
nmKDv0oi/VlZzrVrgfbF3fdr0oin06Y5WbD70WvWGyEGZEb+GhpDEHlrqx8xLFNR
EutzYS1Qfc3A12204V2xghnhLGneLGY0bZuiNjAV390wEbnBCq1J1ehsPDVAQBeE
1bUi1kFslH9Lk1fd0tYCPR3bq5OjF1BqqipGRMpcbhGVUyG0YikgIDDVzZrMz8Tf
7RFaXZC8ScHT2ZpiHclmN7A3aZmirIgdz2ItCP3ZsOz+5v3WNKwIkCVZlG8hCn5K
RS3nXr2tgzop7KXB2/awpuNmZVVfa2tS1GHqvq1vEL2yL8CV1oMhOdX57KegK4sU
p189MwzAjAGRF8fEDO6I23NZz1T3Ad2ABLxE2LYG26yhC+Om89mxQj9rSNataslt
AwJUT5CMZ9XbtFHSPj28sEUyaXESOl2c2nl6fdPBXKvt9A/DmYtFujLxd9oWHWJu
AjKVAD0ReY5cO7Gt/dzt+8e/dQdaBBarXyKswxfksl5SkY+FXRc4lOyV/i2RlBv6
I8NLJ2k5kyr0sF7TZbI+m+G8ghoEV5ZdOynmvfWfsze+Spk3TPjhehCQOF7fZ1lu
Xo0ysoh8pVT+TA3cmkq0N1DCQuQNu8qBWDrUfrKruF7byfSA3YBSd7OzhMr4U9vm
kMXDUShBMaOslR6esLYj
=EIDY
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
