Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3HFRNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:13:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33145 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab3HFRNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:13:11 -0400
Date: Tue, 6 Aug 2013 18:12:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20130806171225.GO6427@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-4-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NT59pYSnj1ZLVgEN"
Content-Disposition: inline
In-Reply-To: <1375180329-4860-4-git-send-email-richard.genoud@gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 3/8] Documentation: DT: update atmel SSC with DMA
 binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NT59pYSnj1ZLVgEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 12:32:04PM +0200, Richard Genoud wrote:
> As atmel-ssc can be used with DMA, the documentation should be updated.
> Also, a configuration DMA example is given.

Applied, thanks.

--NT59pYSnj1ZLVgEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSAS52AAoJELSic+t+oim9o7IP/2l5DpHxEiREhyWrhzMgiZGR
bu1ekyn9KFV6YIhhjn7xyVAFHsunFkrDeuV//mWvViaUJ2p0/3M5TOcLi/8nwX4I
KODjZfuoY445OPahqa7qmzbnJu06PIiEIAFxlxnY7aPiSi3Px4LxQEF+gDXd0cNJ
p61ImLuuGv7IAr3G86fMUjib90vZJkcnS5M9weRYx35+v2eyZxKJA9R7BL02YMAa
XpXvGDMRSHkARtqh/sOoUnEzqmfolFKlQ78UPvRO3pjCe6kYiuHCZG5WVOegcfHc
jB1qP8DGodEoI8Oy9KdEiXX3jsNmLJkq9CjPfywTq022mTv/imK4SrGeJppita8z
rXHa4bWfVDXhQE3XP4alKvoCpp3Duk7ZBgFGBGZM2aMBFw5WbEa3vuPYzhVIUAMF
dVxq5nyw8sJR8D67FmMoQJS68iVydL3cpI6OAmNeEtY4PkWtXda2SSKcL/JBueoA
HGUDTdVfuZB/jRui7rxTABUbS7QDIdmQWN5Jg5GdsugXC+ATAbsTp+YXwHauPDRp
jsJucGE9+IHExxJ4iL9HEsQxBRrgzEJMhtwYDIXfN/hcfN9GZYrOKr7+h6hZBnIF
DSJIHW9QyDMWLGzrY9Z5Hy3YXdQvrWsJ/XcuaKYVWvqn+00EH7ekivUTVgFcRomH
touF61WdERxnUFO533PQ
=N+0/
-----END PGP SIGNATURE-----

--NT59pYSnj1ZLVgEN--
