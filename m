Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3FJP2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:28:18 -0400
Received: from sauhun.de ([89.238.76.85]:40142 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3FJP2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:28:17 -0400
Date: Mon, 10 Jun 2013 17:29:55 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH REBASE] i2c-designware: make SDA hold time configurable
Message-ID: <20130610152954.GE2987@katana>
References: <20130514110745.GA10906@intel.com>
 <1368536642-7158-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IU5/I01NYhRvwH70"
Content-Disposition: inline
In-Reply-To: <1368536642-7158-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IU5/I01NYhRvwH70
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2013 at 03:04:02PM +0200, Christian Ruppert wrote:
> This patch makes the SDA hold time configurable through device tree.
>=20
> [rebased to i2c-current/i2c-next/mainline-3.10-rc1]
>=20
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Hmm, I really have problems adding a generic property. I need to better
understand why this is needed? What is the usecase? Can't a safe value
be calculated depending on the bus-speed? Is there a public datasheet
available somewhere?

Thanks,

   Wolfram


--IU5/I01NYhRvwH70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRtfDyAAoJEBQN5MwUoCm224EP/Rf3V7bWv+RErWc9/UrPKlvS
fkwU6fckWq2DVPn7L85VcqBIshBoNa37KlXX/R8ldTXe5w17LdrJB9RGyitDRUGn
d7TfRO4f9pUrn+eNbTxMoFMh0nh6nVzI2LARyWTDcI4qfP3DN4JvFpI/CaXRQBpW
lud+Mt9xB/fNvTP19pjFWHqslRoIFTk4NUOqWFaOJ3n6mzh9t8udsTZ8Yqk19bWC
CEWTuR2MQkWK1DGjYhSaBcQcIankCDv40m5700DQ1AdG7OfILSDrD9eO+P2BmS52
i80TvqcFpADIo1ccZKI3AmqjrbjRU8Dew/9Z6qsPX1D86Ee30Ou/FhuiUAE6uY1T
6sDLUOr7BJueEeRNoBv29kY6NHB3kVw9ghNynr+xrC3fVhgFnyE/TIfP/eX8bF6P
Y8eyakaOocbScfm/WePz2yLGzTVrkyPYHIagPMiEtY0CsuWkq51VfUGm3Qf1M5rT
DeAFfdZghKpWzTTmCZvH+HwTSMym07AJK3khrvs+IKtptSH0MwefOcu7XKyLDkTH
pSoJfSSGMjGUP1LbsDY0xAHcOjQ2fod3dhghJdE0khGdBt8lvDohLnnZ6NUWa28H
3FFsOkDS+3iJsrbNADinPn8WIa6W3A+080CSpWsoubE1Z6OJAw/vmV5q+jtnpQ66
/fOtoxe6eXcSTm5cfjFK
=3Uig
-----END PGP SIGNATURE-----

--IU5/I01NYhRvwH70--
