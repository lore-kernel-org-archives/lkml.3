Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaDRRhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:37:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38156 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaDRRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:37:18 -0400
Date: Fri, 18 Apr 2014 18:36:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140418173651.GT12304@sirena.org.uk>
References: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1397638902-7576-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Acuacab4LPnnfGxd"
Content-Disposition: inline
In-Reply-To: <1397638902-7576-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] regulator: arizona-ldo1: Move setup processing from
 arizona-core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Acuacab4LPnnfGxd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 10:01:38AM +0100, Charles Keepax wrote:
> It is more idiomatic to process things relating to the regulator in its
> driver. This patch moves both processing of device tree relating to the
> regulator and checking if the regulator is external from arizona-core
> into the regulator driver.

Applied, thanks.  It would have been helpful to say in the commit log
how this avoid races if the regulator driver is modular - the MFD can't
get as far as checking if the DCVDD supply is internal until the supply
is satisfied so if it's being used the LDO must have loaded.

--Acuacab4LPnnfGxd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUWKwAAoJELSic+t+oim95yEP/RsYyqQ4HglP1o/FjThmCPby
S0OKVEcaPTdV+osZ0Ar5UOL03Cjpg1s2wj6ocj0/J+tyPbLFWEbDA/yB0nmfQTDl
7HGRlDAXQ0hPP2ZHYEJCfy8yhLmBXI+rG9HYPkMK0tgzj3ZPntL/QQnZ3q/3elQN
FqxxJ6C4OQ3A7Lf91Yr+sQfUcxRu1Qa8naakR+2uMipvA1THS+pmFADVRxkAu8jO
BEJ18H/FIcITPC+7OdhueCW7ZtFdJMG+573t7aoB7Mlk7miI/S/06vxoZR4RV6oc
j04jt0nC5mw/2IKcsd6+n/T6hQpAPrzfKwvh45wd2W4CCc7MUSMR7AqRRC8Jm5Go
Hz7dSsUZ4/dLSAVyktFRXhwbCGv8a5Qr4PLfj/r3SCxfuTUKrjnB2aVqg9I287JQ
ORVYLDeOgrZlgHc8rYQ4ykE4bFq1Yh5KgKMJcJ1rGWZ67CICtPI7o3AicBvVYt0J
0hKhHm53/thYT9yELK6XWklpnOoXLYsk7I9H8HbnpsmzGyRpz0K2P8pjbcLlZ89s
EutAYh80y5lZzhp0ZeXK2VaoIiv3chIHq5gTeJUQOaofRQ5k4AOMchIqAtsIuHf2
zDtjIhxmgDvcuJ/tfohaJaEMZfHnz7dzwsFYjxj0l9IZ7Bo57CjRM09qJqAhL57T
/6V2U/fbUxjBGj7HXZD3
=PvB4
-----END PGP SIGNATURE-----

--Acuacab4LPnnfGxd--
