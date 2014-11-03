Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaKCMby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:31:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35328 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaKCMbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:31:52 -0500
Date: Mon, 3 Nov 2014 12:29:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: javier.martinez@collabora.co.uk, Heiko Stuebner <heiko@sntech.de>,
        Chris Zhong <zyw@rock-chips.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        carlos@github.map.fastly.net, rdunlap@infradead.org, jkosina@suse.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141103122957.GJ3815@sirena.org.uk>
References: <1414813978-32233-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lYetfuAxy9ic4HK3"
Content-Disposition: inline
In-Reply-To: <1414813978-32233-1-git-send-email-dianders@chromium.org>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: Document binding for regulator suspend
 voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lYetfuAxy9ic4HK3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 31, 2014 at 08:52:57PM -0700, Doug Anderson wrote:
> This patch builds upon (291d761 regulator: Document binding for
> regulator suspend state for PM state) to allow setting the uV in
> addition to the state at suspend time.

Applied both, thanks.

--lYetfuAxy9ic4HK3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV3VEAAoJECTWi3JdVIfQYAYH/0pBS5oz7SQWYh8FLZTdcMVY
CWyToAQVxKC/a9KGYyFOR6cKYg7sxhN+H9tCXSdAarPfYDDuOl+XALgah7d55phT
IUMFgUf1AzTEm3T+yeDlV73ojhoELC40Nc7TAk+/P/JVsJiq/sPtYUU9R/rapT+/
ZGf/Acs8Kli9HyjG2xHCCI0EVUze78gajzt0XSAScCMURj8gkrFeG3glwAVpKgoN
ks5b4jdwMvKYxHrDBuFbcv6eGt8etvyG7byBNkWllQMcWxCgT/s7Hn9Smf4RJgof
qOHqB3qdQeK+VxyQZEXEAQpU8paGTwqqnUl3824IUxyeFWrXvndaaN16tl1JYfI=
=cO7n
-----END PGP SIGNATURE-----

--lYetfuAxy9ic4HK3--
