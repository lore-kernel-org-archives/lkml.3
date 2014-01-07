Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaAGPiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:38:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48361 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaAGPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:38:09 -0500
Date: Tue, 7 Jan 2014 15:38:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20140107153804.GN31886@sirena.org.uk>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <1387468508-12286-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gyrD3n6DECm5G5Ux"
Content-Disposition: inline
In-Reply-To: <1387468508-12286-6-git-send-email-lee.jones@linaro.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/11] ASoC: ux500_pcm: Stop pretending that we support
 varying address widths
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gyrD3n6DECm5G5Ux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 03:55:02PM +0000, Lee Jones wrote:
> The Slave Config's addr_width attribute is populated by data_width of
> dma_cfg, which in turn is derived from dma_params' data_size attribute
> and that comes from the slot_width which is always 16 bits (2 Bytes).
> We're cutting out the middle man here and just setting the DMA Slave
> Config directly.

Applied, thanks.

--gyrD3n6DECm5G5Ux
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzB9YAAoJELSic+t+oim9wz0QAIwaSfP73x6pEoUIW1jU4ZlC
WfirKyYB3jPelvWWOPEunimuigYHRvmlo5pYcD/9FY+PWf0T5cDIIEhLqjMnDJwh
6qMIBv7OzVCxNLMNkVN5QdsF+GVY4vn9pS96y9ES7Gqf6KYdwvMRS2gnfQYLl9He
+3/O3z+/dF137wyDpPN5kah72dwT1rEF7v3rhbryJnMeih8xUdb7vtvtJROk87C+
wfPcsC7+1PdaiOj/Pj1JYproNjb/eO2o86XQHkT5VN2V5Wq3aghCw0kXyfTQKXqr
Y5klc24WACqOtLrc8rRE9HojlO7RXegYTZEDDDhFGVS0j34kzPXsZEnCBDSyOWM0
Xqk3uoEn/cFEX5jfLcmeK5lVZCtT7MD9q/SUakWefArqbuPgRpLVRWkg8FnP5c+e
EnRA2FoTXjX6zsnN8i3F7KhwWldTFogxXSITTSfz3a2echS/SY+gPcjnqVrWA+5G
Gge0pOAmdwFxrfQwAkxQsGhVojKk2L/3fzexyjBgSyfEfhLSRswPTqqdBi5FvANS
HrMyh7+Nsz3ghcxtjey7PTdhjRZ8roVm4UjcG6rrBSmfjX8rWt4TfT/iT1mZ5Hat
V8tlRmBiWmspUAHhxXgRWmXdHoRkCpoddPyUFQOsRV0yZlFoIw8f7cDy+jRp63ST
8FOWJsdzZu3+qj9VYqZr
=uo1m
-----END PGP SIGNATURE-----

--gyrD3n6DECm5G5Ux--
