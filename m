Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaIPS2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:28:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45567 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbaIPS2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:28:47 -0400
Date: Tue, 16 Sep 2014 11:28:20 -0700
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>, axel.lin@ingics.com,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140916182820.GV7960@sirena.org.uk>
References: <1410888174-8279-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aDKukjHEfhu1+b5Q"
Content-Disposition: inline
In-Reply-To: <1410888174-8279-1-git-send-email-dianders@chromium.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rk808: Add function for ramp delay for
 buck1/buck2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aDKukjHEfhu1+b5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 16, 2014 at 10:22:54AM -0700, Doug Anderson wrote:
> On rk808 buck1 and buck2 have programmable ramp delays.  Let's add a
> function to allow a client of rk808 to set them.

Applied, thanks.

--aDKukjHEfhu1+b5Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGIFBAAoJECTWi3JdVIfQ1+0H/0CY1YMXbU+mviryzCW8rAZz
e9pQMKKVOA2OiakR4s1NfNMNyFzxwNMUqCmubj4k8n842egD8OOWcH2ergENU0S0
bhBzd3iTutS7dFDZZx1mIOKdF8n3et3SCAiUydZuxGdUBLl5ODF66P7Ymp4FUEzU
M1lt2+5Nfcy5nOallPKZard66GC3kJmu67sDWHfsD3iOAq816lRed78B1YbfteRo
3Jl/lr/pjdsNt1pHM+g+lQlOIDu1BfOKTON+PMA8DdUqfokH7YnlDOB/ZjSaLwMW
Ee93dGHZs6MQmCrC7xemLk+G7egtRbprOUHZP7+tcdtZczLf0ndmZrkhMtSUatM=
=Q2KN
-----END PGP SIGNATURE-----

--aDKukjHEfhu1+b5Q--
