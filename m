Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaHPVhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:37:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38909 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaHPVhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:37:34 -0400
Date: Sat, 16 Aug 2014 13:02:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Markus Pargmann <mpa@pengutronix.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140816120216.GB28623@sirena.org.uk>
References: <1392729108.18579.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <1392729108.18579.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: tps65910: Allow missing init_data for
 diagnostics
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 09:11:48PM +0800, Axel Lin wrote:
> The regulator core supports this to allow the configuration to be inspected
> at runtime even if no software management is enabled.

Applied, thanks.

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT70g+AAoJELSic+t+oim9m/MP+QGLEnX1YMV9Q1prOgIFY7jg
MaYVShw+nKxNCWfdo2W6OH5zs2PRnT7rUGlFGnJvbJPuZ0PrVOivrwIPeIt0u77x
mfXp0JbumRyJaA1v7xnBjabQi7Mw8JgMu0jmPuYTi3xEG1789Sk1LuAe/baRCHYW
SEqKR60nn6AJtFvtdKkSUML9O1RQ40mvK51oE+NPpdvls9sGi4nwZBkHh8IVj9+3
kbofw7GwQ2w3jc5LsvDyVq211XICC0lQMggZ+Bt/wiU+6HpD2VuTN2kIzaD7NbBN
zPOLd26Mz9tJn2dP11rkSjQ0g/kV+WJPA0SvqQ+Tc+uedwSYcwYpa7DzkJ9qMwZN
ElragnYZIqKKa+/qX2vlQ5XX/F6SI+hey4BK0/7lNJ9ci+jZhHJyW6mjkekebORD
+cKj859d6HijDUWCixa/Fs7mociyADXXYr2ntUCu8eL+i4avFtmUVR3wKx3G/+lq
qVDpNRMNwccMbG4qY1Xx6fnTmF4InAsvSgLa4NAmkdxwDN2vu1Nt+VqEUvr7VqLY
L1JRC2mCOap7D+dsKtDlos0mbBlrorpbWXvxoH3QVgwLUugyqgHqCI/hM1A0lvCb
AJXNpnakTjmeI5fkfWM8oCiboAHLtz8AOKGHpLTpCO6G58N5oWmcNauzm/BXcCNG
OJh1+Vu/kBn0tnhdrTJt
=44Wd
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
