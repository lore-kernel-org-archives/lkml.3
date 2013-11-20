Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3KTKUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:20:54 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59794 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTKUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:20:50 -0500
Date: Wed, 20 Nov 2013 10:20:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131120102045.GW2674@sirena.org.uk>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384877043-5640-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131120091636.GA30012@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1VhaNAE4Hwu38Ubd"
Content-Disposition: inline
In-Reply-To: <20131120091636.GA30012@lee--X1>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ASoC: wm5110: Expose input high pass filter controls
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1VhaNAE4Hwu38Ubd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2013 at 09:16:36AM +0000, Lee Jones wrote:

> For the MFD parts: Acked-by: Lee Jones <lee.jones@linaro.org>

> How do you want to play this ASoC?

I expect this to collide with future changes from Wolfson so it'll need
to go via ASoC.

--1VhaNAE4Hwu38Ubd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjIz6AAoJELSic+t+oim9dWEP/0oiRjEOt8GxmvXEdhd2e1of
hDPw5FvvmmSxqYqRhX7Scd6ay8ipiyiNFmNflJGvGUEm/ocGwchC7TEU7iQaHTPj
JMyZu6l4rTk1wT+xF9eH/i2vdVfwwp66aOI+G/oz7EI1Qam5Fgng1+FNCHZ/4v3/
kp1V3z1XlORfWRPqJzcO9PoRZZ+ofOWf4Jxb3ZkLm/m6TxfUnT2qtQ4kx8P2IUiV
QXDx3+ysZodsWvs/768ZZl0rnuKZQxQ5JIF7fi1Xtf3fJd/cVk2j38JdCNHnmeoQ
d7Hn8NnLYJ88tzJxpQTWOvcJdSABVESdeGUr0U1fOMaspCYlLsuNBODjo4o1/1is
CYtd0GNpq9o/zJa+MVuQG1pMNF7aa81g4VV2VXivDNACQec5JVyjOPiwhVmgDoB4
2LuuBX2SskIopp3031bxdyuH04ZXyRDZrglEF932bc7idBqTQrYZRSDLDdK10COl
Svl75jsIjjPo4/mDVt7r/M0daq0TqCvW9ovCQlIMEKxipLMs7a4DjW7arDCb19H8
MWWsz1GoX4ZOE3ts9P3xgrgI7wvhausy/vZdIHIRWHB+k6rcqTEv+z7RqtRfmyY8
lcLBZ97QcPiwQcOftDc50uGjm9X0QrNU/1G7t5wvoykdk5vTaLLBa3eqgqiXDE8K
RBLEV8PnA1lWzT4FNiOM
=HqVM
-----END PGP SIGNATURE-----

--1VhaNAE4Hwu38Ubd--
