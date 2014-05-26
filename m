Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaEZPTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:19:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43313 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaEZPTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:19:35 -0400
Date: Mon, 26 May 2014 16:19:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        dianders@chromium.org, swarren@wwwdotorg.org
Message-ID: <20140526151915.GT22111@sirena.org.uk>
References: <1401092902-20525-1-git-send-email-tushar.behera@linaro.org>
 <1401092902-20525-3-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iWgke0titJZxhgDH"
Content-Disposition: inline
In-Reply-To: <1401092902-20525-3-git-send-email-tushar.behera@linaro.org>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: max98095: Add master clock handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iWgke0titJZxhgDH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 26, 2014 at 01:58:22PM +0530, Tushar Behera wrote:
> If master clock is provided through device tree, then update
> the master clock frequency during set_sysclk.

Applied, thanks.

--iWgke0titJZxhgDH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg1twAAoJELSic+t+oim9lZYQAJabidoIPELzOnxdAZU7wFDD
RzdfEgu+f8bv4U1Rbum7GeZ0XUZrVHMCb/tVJUrPDBEg5WDqquk6+b+YLvbT7Sp1
gE+79eSazHJmJMYMKMDB4LqAwL6wUsY93Ma1qX22qETaG7ropEDKkrQufinsX5E/
fwJhcXoX/OUnZcxLb/PIvjADQW3I/V618AeIonGFmosZCrlfLRXOOS+BvjhNlU03
MHmkDfQy+3TPvltUyHHbWeVlOye1NJMFr0BS7m1bwFyO+lieyBUaLmElPDE1I5PT
HC90ZWWy205eQ/vSD9DO+Ke9+nazDvj8KeX3Cn9jyBBkZ1zfqHZ2vcFM8j3QNSze
C2NoiP6rFwtNgP/dQCrt+cJs6VmvcKMUpX7bL8GplcKlZzTROmzFl12yTRX7phgv
yLkKt9v7b9rGRs/a+PLiC9HfmimWLXu4S246c4QKyghZmBEtMarEB54MUeKaT9XI
s8OkGpjsoJ6lG85T4kPIW64yvmAt9pAuPpLbfMtCLKrcbvI269td+Ylp4oVdG/cK
yFmXbh30+IgKKtc4ZKtL+T+mE/OeA7vZVxzO/9/jmCsV83hpX78id40fuPN/mlJo
kT8vVCKwnk8D5xiXQG08ZYiIZ/JL8HMrLF/T8cDtc78xGoBk269OZHQwdPSYrMM0
ytJMqoxgq51/ho8AbO4w
=jm0w
-----END PGP SIGNATURE-----

--iWgke0titJZxhgDH--
