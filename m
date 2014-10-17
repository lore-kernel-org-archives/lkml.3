Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaJQI5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:57:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60810 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaJQI5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:57:41 -0400
Date: Fri, 17 Oct 2014 10:57:26 +0200
From: Mark Brown <broonie@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Vinod Koul <vinod.koul@intel.com>
Message-ID: <20141017085726.GC3771@sirena.org.uk>
References: <543feedb.9M0AZfu7MKIHlZcy%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <543feedb.9M0AZfu7MKIHlZcy%fengguang.wu@intel.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Intel: mrfld: fix semicolon.cocci warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 17, 2014 at 12:14:19AM +0800, Fengguang Wu wrote:
> sound/soc/intel/sst-atom-controls.c:249:2-3: Unneeded semicolon
> sound/soc/intel/sst-atom-controls.c:289:2-3: Unneeded semicolon

Applied, thanks.

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQNn2AAoJECTWi3JdVIfQfuMH/20NMRqJu4AC73ZUDiNmL4qO
CPU60xhS5XpqQAKj+pCB5OrFN1STPMpoZqnh5yuiSw9Bn+aN75l6WxO+JICdxdwI
oOOXyF5vY6Z7d+TYNzU5kFega2iMd2ayYK47fX16bjwllmqfmu+F7lu+OCNgweBN
+AuCpkwjHVvTrgp5nYBDstuFNLQTAqOPCB5/mNLUaOeXWGJeDlTojNhc3HaXjZVt
cilIji54Fwqy333uMnxJtYVHmXWt0qyBy9kwg63mETllNltoG442dmwK6/Ig7PhA
uVMuvDd9vFISslTPkjlKwWA/Uw9i1GDeNlbEpQw/f/jUKTDOT//1jpaSKofi2J0=
=cHGd
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
