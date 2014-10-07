Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaJGTkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:40:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39243 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaJGTkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:40:42 -0400
Date: Tue, 7 Oct 2014 20:40:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, heiko@sntech.de, linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20141007194007.GI4609@sirena.org.uk>
References: <1412070294-5535-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hv6+fPJLRRhGCb8a"
Content-Disposition: inline
In-Reply-To: <1412070294-5535-1-git-send-email-zyw@rock-chips.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rk808: Fix min_uV for DCDC1 & DCDC2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hv6+fPJLRRhGCb8a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 30, 2014 at 05:44:54PM +0800, Chris Zhong wrote:
> The min_uv in DCDC1 & DCDC2 should be 712.5mv

Applied, thanks.

--Hv6+fPJLRRhGCb8a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNEGXAAoJECTWi3JdVIfQeFoH/RkSR9agRKLszxoZmf7FaNf+
B5Hw9eKnA59I0wpBa+zwRisbTYOkOJOsqDfpa/toqsPKXmmcvfOXSfMHq+soV75a
MIBPB3Y2jd4KLWtJlQpI9eHuLCAN8P3mCU0+3lshNDiW1uFwDFEEta1O2O9NuIC7
x9Emq51Tg35XGc0+MztoCdofPiOlX6fB8TagRLsnv+hnEmttpdJgqupZOUbpBpeY
ciKGk9ijV+ukzrbCMN63gt8cUgnpdkg7hTjrct8wTf6JoTIfe6gIdbBcqNXkvaGY
0hFSIm5Azh5XiWwMyx2Ny1k4eQLH14eg9K0dAdCHmfuFAkX+JEZ0mvM5AXrlaMA=
=VpsD
-----END PGP SIGNATURE-----

--Hv6+fPJLRRhGCb8a--
