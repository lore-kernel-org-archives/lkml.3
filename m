Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaEASrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:47:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54317 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaEASrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:47:03 -0400
Date: Thu, 1 May 2014 10:57:17 -0700
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Pavel Machek <pavel@ucw.cz>
Message-ID: <20140501175717.GI3245@sirena.org.uk>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
 <1398694047-28596-5-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yBd94+RIx/Fx7UDH"
Content-Disposition: inline
In-Reply-To: <1398694047-28596-5-git-send-email-sre@kernel.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 4/9] ASoC: Allow Aux Codecs to be specified using DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yBd94+RIx/Fx7UDH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 04:07:22PM +0200, Sebastian Reichel wrote:
> This patch adds support for specifying auxiliary codecs and
> codec configuration via device tree phandles.

Applied, thanks.

--yBd94+RIx/Fx7UDH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYor6AAoJELSic+t+oim9shkP/jMiBr2W/oJ26RYRp/hvcoPY
Iv9PQ3BUGwf+rOXYz3pe0aJwL8xtmnlISIgKJwLkuf4rLFeU9x7GTfQbz0sQAOYD
TOGh9CBDSdAvjJUR88Q6PqT48gCudqRJXMwKqAw9NEgg+wBLfVWY/knB6AYQfS0p
4PU5PLennBq01xGARK+IdIpmXc9HN+i4u0afMSid5+Ow2PjZTFZ/dLyJFTvDX9Dd
kx9klJ22f/pIAO7qDgStwMxpw/zewdNpj6eGqIBxU7f8I9NsEtkhSg6rnEDx5DHj
7izeihFvht/h787paEY44eq9OsD5cn56L8JqRuPTp99ER/A8aI2YJt2531+igFLQ
O/KFJBjL0zXFnA7Evg/UlTvV1rdfPh8mrGT1e2hRvxorjnpvDkCEaqu9khX9OO80
eA1Dy+NiWxv+ZIOEfVrGN1WjFBReDgAhYo6C7iBBiL4fyMmbd6l4gfiTgkt8dwO3
IsKObP30uNe7ZAk47EKigiraiw+ZH7+tAs77UmC4Pa8+7YXzdmhazgLTSu04ALyW
T+k2lTYcRb4Ie9hTNr8WqVYm5IwOeAJmbhgJvQdMKsWwAW2RgBDb+Ru5zwlmP2nj
hNy+czN1UTt3Pz0T286CK2u54lJ+IjVvsYI4q+n08kKgxgt3TOFnOF5BgDwskjIl
4D0vKVCbybK5FuQAae6T
=pyai
-----END PGP SIGNATURE-----

--yBd94+RIx/Fx7UDH--
