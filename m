Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaHRQkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:40:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47249 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHRQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:40:48 -0400
Date: Mon, 18 Aug 2014 11:40:12 -0500
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xiubo Li <Li.Xiubo@freescale.com>, linux-kernel@vger.kernel.org
Message-ID: <20140818164012.GI14537@sirena.org.uk>
References: <1408367342-16413-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gs9iBZf6UKWgztis"
Content-Disposition: inline
In-Reply-To: <1408367342-16413-1-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.64.155
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regmap: Fix DT endianess parsing logic
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Gs9iBZf6UKWgztis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2014 at 03:09:02PM +0200, Javier Martinez Canillas wrote:
> Commit d647c199510c ("regmap: add DT endianness binding support.")
> added support to parse the device endianness from the device tree
> but unfortunately the added logic doesn't have the same semantics
> than the old code. This leads to a NULL dereference pointer error
> when these properties are not provided by the Device Tree:

Applied, thanks.

--Gs9iBZf6UKWgztis
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8ixdAAoJELSic+t+oim9i14P/1kJ0LMAVtaoq7G5OB/kA9CW
IwGuScinFXuo1sX732lbwLxIh5rvPXoopgp6K8gGkguPcV+76A4rgJdL4QHMng2e
ga5a+R8ETavxJehVtqY0Rl4DMOmTbRPW4kG/T71gtHlwUFJnRpGS+7VxBU3ePhQ7
XG6DHGjLZxGV4huZXNaxyNvnTeR70YZ2/PjyA0QgEg0IrqMSIPX8CfhFlCCNDkt+
6CiUZhdas7IsiBw0Jry5e39r9rz6wWmUovaAN38oUtViN2cKEPyAmpRlwZFj0EFK
NAsr80W2BmNfXUukwgGQb74mn8rBU1vBE8o/eXNmRHaLbZHWlB5XP5hQeSuwvz8d
UyPRDyPrIykeobafMAksgcTW+lZEkQpfm7v522zAfP2Aia9o/ke458Q1UFLjju7z
hOwSNswXax07K+R96U0s4481y9Dk00f/yksjNyeD2b7iCdFeKfFvqsG3XY5MisFl
4qi5MIQmeSSQxdDT1eRNeWBTcO9RVSHQw2vdHb8jXCFcEhV5acvcAt2h9avutHeE
o14iTYo3Pq90+0/QGgm+XXjijcCli49mOd7Ts5fycT4yJpeyq9sUp/Ng/CfZ0Mlj
oDt9VcbDGU138AEvh7Nh5weyZB5ZzzGF6DiW2M/pUm3J2SY586yImQvpduMgWKY2
Rv2xuwWcRyWu8Obyqre5
=JIyD
-----END PGP SIGNATURE-----

--Gs9iBZf6UKWgztis--
