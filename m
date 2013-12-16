Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3LPMd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:33:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50352 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3LPMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:33:24 -0500
Date: Mon, 16 Dec 2013 12:33:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Message-ID: <20131216123301.GG3185@sirena.org.uk>
References: <20131216164721.79bfe996919a8ec3576867c7@canb.auug.org.au>
 <1387177714.4280.2.camel@AMDC1943>
 <20131216114510.GE3185@sirena.org.uk>
 <1387196021.4280.7.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9/eUdp+dLtKXvemk"
Content-Disposition: inline
In-Reply-To: <1387196021.4280.7.camel@AMDC1943>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the final tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9/eUdp+dLtKXvemk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 16, 2013 at 01:13:41PM +0100, Krzysztof Kozlowski wrote:

> Thanks for applying the patch. The commit introducing error was picked
> up by Andrew to MM tree and lately got merged to Linus' tree:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8d2763770c34e8ed771f0be86760eb4485febc05

Yeah, I saw it went in through -mm - what I was wondering was why it
wasn't causing failures in -next.

--9/eUdp+dLtKXvemk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSrvL6AAoJELSic+t+oim9nEkP/32r6ZE+itcgiqb5qYAjj11x
BWQuNGH6BRXFKCogBU+2sVFDWU0A42eAmuUyo6dqBXZ3PcqkZtSDNmZhvrMOfeXK
9ivG9ZRy4oKa+/mEPaXmuWTuHZv9Iozrs/iW73e0kC8hZapHMlmigxq8xrWUDAZ7
6rQjqmBD7zwVGZTu0aYgg4FfMX5VAwc4Bi6PHrHCcEb8JXAaioWqIkws+vM6i+PB
bzRFhmTCXXbSYIGKxpgFfBqnHSLg1xTpCn0VV/028YPqtXtoxn2H8Zrjd+rh8eGE
Oqf00iPMlnW2f9GkhOe6nQGMd5ZNtrAWNocm7tmcjGpvZcNAbzRdV2K2dxgdK3po
j8JG1Z2y9gYfTpgJ/w3PZSX43fzPDw8BmSLSYuKUfmOwyc6bF5USPRpAHS8hBs5v
3LNGhHcP3HwrjUABIgfSvnhOsXsELmP+l3H5bM7bZQFJV+qF+VkNBGnGiuhnMcTq
/7cJCZMG3KfDWqdrQStvBLz8yhCPD0xJU0ZpH1wbZi91UaOC2XrlFDrPax1mpx9H
gdQ7W1uq17vu0+E1WfvSUe9rZT6NipW61ouiMx+JIyu+7FmoxsUb5yquTKIQMnWw
om3gJVSolPNC0nFr67yEThjXgSuiSF1dMCIom6w3ehLrgNARluBP4Y2YhrhjiwDb
yHXn1Nav/cERhakdZXcu
=TG1G
-----END PGP SIGNATURE-----

--9/eUdp+dLtKXvemk--
