Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaHSVOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:14:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49387 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaHSVOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:14:51 -0400
Date: Tue, 19 Aug 2014 16:12:46 -0500
From: Mark Brown <broonie@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140819211246.GP24407@sirena.org.uk>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408469363-15901-10-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N5iGxCIPT7YMRg16"
Content-Disposition: inline
In-Reply-To: <1408469363-15901-10-git-send-email-andriy.shevchenko@linux.intel.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 09/12] spi/pxa2xx-pci: remove unnecessary assignment
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N5iGxCIPT7YMRg16
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 19, 2014 at 08:29:20PM +0300, Andy Shevchenko wrote:
> There is no need to unset driver data pointer at removal stage.

Applied, thanks.

--N5iGxCIPT7YMRg16
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT873HAAoJELSic+t+oim9EIsQAJabOVhkeu1DdbLRbgWmzA/2
u8PR6gXB4xaFIz7m5LJ4EAQgZ+Vnh9P8RBew9knIcXLApVcvBJBbDwMuaExZkVdi
n8BeqjzChMbNigPw0Gn39ZtNjfKdxE9TxLtBJz8CeJCpZo6mTq1MDcJexfpimulv
G8fr0ehEH9NVw+V1N4M+zkDNVUy480H/2ppF5tPPGhPxb34XbajZJ9N2+d9X0scZ
hrNt0v2CLbuPTG4TBVkExc7JOltFhdHR+AZacFT4iHhxlUywYf3ruvNST/Fx0Y54
U3lxyH9zAj3odhH12i+Ys+cLdbrlox806vuw6gFfyCjyBKpsTTuxmY8SU5JdQ2IW
q5FykOf2mlqj4/akzZRzCkTHPdom4bgYs6uQmxo3gqYAgz5zO5SWKMgpbufUl4aX
E+PzonIaJeSMsENUc27bRGGWkqTdSFaigRrDco44OyT3FuId/KUoaDFKYqX8o6KB
ablTFwdk/9qe72qMYCVfvB7frEM/9rPxbzJX4E555sHCRMuzpI5tcjBCBZVAQSTB
75ubEDzU3Mh22F6hstawAfgTj3TW7MV81Y4o2bpCCb8Y/mxpVNrDsdJG0/0ItkI7
FPR4QmCgNbx/2lhj9Sasj7bL3jJnxXDy+RVj1vYr5wU7QIgwR84iBFYEyGiTV6Qs
N03eBM6sPSwINshOdiQG
=qxZY
-----END PGP SIGNATURE-----

--N5iGxCIPT7YMRg16--
