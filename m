Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaA0SZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:25:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60102 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaA0SZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:25:27 -0500
Date: Mon, 27 Jan 2014 18:25:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Dylan Reid <dgreid@chromium.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140127182522.GE11841@sirena.org.uk>
References: <1390606839-1044-1-git-send-email-dgreid@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Content-Disposition: inline
In-Reply-To: <1390606839-1044-1-git-send-email-dgreid@chromium.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: cache: Handle stride > 1 in sync_block_raw_flush
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 24, 2014 at 03:40:39PM -0800, Dylan Reid wrote:
> regcache_sync_block_raw_flush takes the address of the base register
> and the address of one past the last register to write to.  "count" is
> the number of registers in the range, not the number of bytes, it

Applied, thanks.

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJS5qSPAAoJELSic+t+oim9wRQP+IC0YnQvDaZsyOvbuW/rb8G/
+8vokKdl14HoHhpM71APyQeUgnK3qbPqmLm8U3W8Sd/JwM0pX9TxF7Tc/rpOKBHw
TheqkYI2wNsJydH1t8A48Bas5Vd0DpPfMgyKeLk3Fu+nfXRWHkhTlz8+A+rhHY1F
Fot4ZzeFpvajP2gidWsHqZaJN3lFZD/T1XhV2scpfG7hSR5NH3VWwto7WrvKSNwQ
T26BGdWUSNSWhCEFLYTnOeUnXjf+KNcWqaevfUgxk9FV1oTQVg0K7QzDH0aQjF1X
tviTAsn178SvpZoDS29nDNvuQ0gdHWA5Mx+LykaCxovTOSLOcXw/PW3TlqlfU8WD
NCzUkQxjvOdEt4hOxxCo/HfwHBQ6TaVou8xUQx8NAS16zxozYp9/GmCNLfPa0/9t
cdBLjwoJGrbgb2NNvUPIZAE+y/rzklSqvLRpp8qiv5x6Uhdzh7RVKj3kN2ofUQsO
jxRXzfF5bL2Vvggerx3WqPXt8U+trFeKPMn/acQA50w+uPwIwIiFmoN3SNcIuayT
BwfvSjImEMqAdbuX5ssQZNM6Xt9kAkxEMX9b4ZXBJKqEhKuZ6NL7fj0/JWZuXLHc
GTwAEtnUuj9DFe3SVaUy6SdZoU5K+tJNTYtsSxLVj1HYlt+aMBp5yfOGSzo2nH9V
jqledlHepHcORRuIPrQ=
=Oyqu
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--
