Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaFVLAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:00:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53408 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaFVLAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:00:44 -0400
Date: Sun, 22 Jun 2014 12:00:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Graham Williams <graham.williams@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Matt Porter <mporter@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140622110028.GP24291@sirena.org.uk>
References: <1403120530-27395-1-git-send-email-graham.williams@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kOdvwer/5gjFgNo6"
Content-Disposition: inline
In-Reply-To: <1403120530-27395-1-git-send-email-graham.williams@linaro.org>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: bcm590xx: fix vbus name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kOdvwer/5gjFgNo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 18, 2014 at 12:42:10PM -0700, Graham Williams wrote:
> The vbus regulator was not getting its name set. This results
> in the sysfs entry being empty. The lack of a bcm590xx_regs[]
> table entry also upsets Coverity runs. Add the table entry
> so the name gets set properly.

Applied, thanks.

--kOdvwer/5gjFgNo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTprdIAAoJELSic+t+oim9McUP/3nPGMzfxN+eHV3rAiIWOaWO
m/PTfvd48j7uG+bTKdw1ANfTxq2oh2zpmnG/MshmywT6fH1ZW57CSDh5SWCiRVMr
ggPlQDXaGE5w8lIp0gpJjyxGlIhb59/N7Owg1cI3LJF1UJNe6XvvMdGp7ImxpN8d
sfckdR1G2RvvowW4HCXejn9xY1QVjO3I12tDAt6I6OlMcf7Hh9bVCHqEU7ShNwT8
1mX1siiKPiUWKmb7nAkB+dBbbg6mW5KtUPJ8kQCeKykSWefYd8EL9oK4GMaWe5iq
ql1uxK4YUxdbI/stWmFPwIEmPKt/E6W+dg4Fkt/OVhPJUd97V5/aLgL7mxROzWSO
6JX54cnTFbmr/E0pF2IqOIx7VXubCxwh2pZbMMWyE5/HthRx74Dg4gIPRs4uHpf7
Hh1sNH0QgPUvz30B3QQQAM3c9SrHBjiN8E+W8A67UhIbC6vLgupESYIb4aeGzKCx
olBb9TnX6JliTyyEdC4XwOmNEwe95EEAmYx/EqllJ4uhWIMcI0+SGF9HyllU5GNi
ReOJDLIeOkBowXGeAVYB+95p9ShydJgQp806RFnucpakrFxq2KmF4C7sx/wCH0lG
0T5OTLzX3Arp3HBjiwqmkFbLCGzu9YJJMMSnDNPQ0rfaiSaG7Bl/PzCb/e6tOmuU
Rq6WVszXMAZEdk0vCsbv
=PUNH
-----END PGP SIGNATURE-----

--kOdvwer/5gjFgNo6--
