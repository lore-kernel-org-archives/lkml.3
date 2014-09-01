Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaIAPB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:01:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44901 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbaIAPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:01:25 -0400
Date: Mon, 1 Sep 2014 16:01:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140901150100.GA29327@sirena.org.uk>
References: <1409582932-4512-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5LK7OEqpP/xdrAG9"
Content-Disposition: inline
In-Reply-To: <1409582932-4512-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: arizona: Add ASYNC_SAMPLE_RATE_2 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5LK7OEqpP/xdrAG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 03:48:52PM +0100, Charles Keepax wrote:
> Some arizona devices have a second asynchronous sample rate, add the
> registers necessary to support this.

Acked-by: Mark Brown <broonie@linaro.org>

--5LK7OEqpP/xdrAG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBIopAAoJELSic+t+oim9Bh8P/0CJYbQcoP3lDfKJI8jrrEWN
yebzWtTVVQHUddFa+5r8SemmEiO/vFWu7sQovBEdGNM/XQE8QOOog2ZI1/P1arGb
W+olJTpGx/NXVh5oYlrkj14DUw8w+9V99OUQPaAMnyvxJoDH/2O+8llVglO3UGu/
tBjXSdkl10+pFZiBn8G3BgRNLb6Mnh1flU0mCB03G9PYe5LNlhZwF3zk2XBccPC6
32Ya6vfIpavCUO98Jl+0D4jZXSwO+KspbAzW1WpXgfGz+G7U038ByhvbS6q/c4K7
a9VWFiJWiOFZVnIjJDAYSnqFUwJZ/A0m4jNFU2AUcMwZZ0/RjNf0+pFuhL0Ts/kj
+PFexhRyQyGUtWAkIrK0NMFJvsnV+0GNoWNun83zbxsQ66I3Vz470xts6HsSO1mw
DXJu4YHLZNpOHyg0aBoDQzkKBoUYO0gIYIFt1XdVKFr0G8ZmvEZ78m1fdDleVcVk
J8rVNZqFnOrvsVQc4AeZTKraBlJ/BegqIyzMkjalikfkrdlPmyftgl4pNSz7A3PH
w1j6DMNNEbJTmWJhfutQiG/qb3Aaj8enDUa6bVPiD6yQEXopFefbnA5EohPDwJyc
ZpdmfBb1nm+qKDoqJciNvwZobFV8dQshKvP6wptaYmxQ8h9mQq/J5sg2GfwUnvbf
CvT7rnequRlFuzdv/poE
=ZZ7p
-----END PGP SIGNATURE-----

--5LK7OEqpP/xdrAG9--
