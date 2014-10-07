Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbaJGThL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:37:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39232 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaJGThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:37:09 -0400
Date: Tue, 7 Oct 2014 20:36:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Ben Zhang <benzh@chromium.org>
Cc: alsa-devel@alsa-project.org, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>, linux-kernel@vger.kernel.org
Message-ID: <20141007193656.GH4609@sirena.org.uk>
References: <1412372246-10489-1-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="213B/23bCmw+8GSd"
Content-Disposition: inline
In-Reply-To: <1412372246-10489-1-git-send-email-benzh@chromium.org>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] ASoC: rt5677: Include gpio driver header
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--213B/23bCmw+8GSd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2014 at 02:37:24PM -0700, Ben Zhang wrote:
> The header file is needed because struct gpio_chip is
> placed in struct rt5677_priv.

Applied, thanks.

--213B/23bCmw+8GSd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNEDXAAoJECTWi3JdVIfQ6dYH/jXvxYPxAx6ZVQIA9aR5/g/Y
A8LuwelO9gzn74pTii6eFMZ81SgsWe+GPtma5LWXzHEBCpOd4JGZWTqTG4RdPjyf
SdGEdioS20MqMKGLdSZ+/UMVOGt95KpoxkxaBK8vwrQWk/Veyc1aGKzG+adWbf4V
VHC6o8EY0AnI+/bqtx++VVZnvtV+9QPWSZf7DjuW/D0ji6N/llY5qbnFm3AUsAcB
DZIElp0VZ39hn6+0ALhqTPJDJkxExN1m328Lw/eZRYWrEKAWYSh3inwKg4pnNZqw
c372yG4mxky2r1o3Z1TjMzNlCNpya+FK8vETtbtIIuQUBieY8Jta4DIadmfrsOw=
=uuD2
-----END PGP SIGNATURE-----

--213B/23bCmw+8GSd--
