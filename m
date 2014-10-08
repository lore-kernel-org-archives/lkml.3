Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaJHOZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:25:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40769 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaJHOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:25:47 -0400
Date: Wed, 8 Oct 2014 15:25:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141008142511.GA4609@sirena.org.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NRg0qHkDgHfQnopc"
Content-Disposition: inline
In-Reply-To: <1412775847-15213-2-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: of: Add regulator-initial-mode parse
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NRg0qHkDgHfQnopc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 03:44:03PM +0200, Javier Martinez Canillas wrote:

> But currently there isn't a way to do the same with DeviceTrees. Argubly
> the operating modes are Linux-specific so that information should not be
> in the DT which should be used to only describe hardware. But regulators
> having different operating modes is also a hardware property since many
> PMICs have support to set different modes for their regulators.

That doesn't mean that the definition of those modes is something we can
sensibly provide in generic code, especially in a completely
undocumented fashion (perhaps you've done that later in the patch series
but bisection also applies to reviewability).

--NRg0qHkDgHfQnopc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNUlGAAoJECTWi3JdVIfQgHkIAIY527r8xpJbskYfmMvb5P66
GvpG+7Uc5BKFOkdpceg2Mf+oO5TZR1ilPsAOEQYGhOHHLhMeKZi3pwgx9gLCiR7g
oB+dXKw0J5QcDhN7jGLFCUDSWDzD7mgqhGmP3zeO2pAbKqaaACNBjEAKrWhp4kgz
Ra9gqvOVZjhV8LoVZThjpxoxucfwue3ywSJZLCtQ40HMJRnxyNO8KKqEwc7MJbqI
lJmZNeFTzGbAtc+DXi1VmR4+MlSkBQw564jgJ/b3NEWrT/o1/lfFVJrjHJj1xV+r
CZup4CpdynrzaKYYQN9RFjosM4e1XKcVxyXBIF1X3qao8MxE1uYU+jXGcRr2R5U=
=roPf
-----END PGP SIGNATURE-----

--NRg0qHkDgHfQnopc--
