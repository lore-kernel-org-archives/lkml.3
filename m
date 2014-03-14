Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaCNKN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:13:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33865 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaCNKNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:13:55 -0400
Date: Fri, 14 Mar 2014 10:13:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, joelf@ti.com,
        Liam Girdwood <lgirdwood@gmail.com>, Tony Lindgren <tony@atomide.com>,
        nsekhar@ti.com, Jyri Sarha <jsarha@ti.com>, mporter@linaro.org,
        vinod.koul@intel.com, dan.j.williams@intel.com
Message-ID: <20140314101338.GP366@sirena.org.uk>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
 <20140313134601.GU366@sirena.org.uk>
 <5322CE32.2000102@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zpKbRLlnGgG674Bt"
Content-Disposition: inline
In-Reply-To: <5322CE32.2000102@ti.com>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/18] edma/ASoC: dmaengine PCM for AM335x and AM447x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zpKbRLlnGgG674Bt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2014 at 11:38:58AM +0200, Peter Ujfalusi wrote:

> The only thing I'm afraid off is that it is going to take two release cycle to
> get this in: first cycle edma part, next cycle for the ASoC to switch to use
> the edma-pcm.

We can do a cross tree merge, or the EDMA code can be applied to ASoC
directly if that's what people want.

--zpKbRLlnGgG674Bt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTItZPAAoJELSic+t+oim9p3sP/RND7EuvcSdbk1Ak3hsE3IP7
YjoMVcIc3vEs9r8xoY5VVWKAonl2lQ7ltW8bOCGQu2zWQox49MURpk0W2vnw9lp6
T6i+3yqIoIVvEkgQYFmL+vZUSst00lzyqKzt8vnm/PSZ8FHHQ10AYvF/uZifRx1E
a6gGwEQ+EIEGVplebczWfpHs40DBOhvWF/3cJaz21fxLsRhEg1SDcODAoZJYRSY7
fcdKAAVHHNX0EOA5sz9dreq/rV5qzaljvkHEVTrfkl8LrdP54fgZvjp1wy/P9nSD
LpJ8WBVmzUIbmGoqFJJi2QsoGVbcyv5gTNMNjPre35Go4V62t68W4EmspcRCiMW2
zawOh66rXcNJ0GhuTHGNEmahR8azubvGG+Z+ik0Ej98WsGxmKicxVLHaJeW2LgKE
JpT2GVIbyjPQ8ky/zgsLtx+RHBgRK8UkXwrK2kyaNldwXl05VF+eqioikmdRxFtf
tbCHpwUEbbnWMT/VuyhGn7oWiiz+wohtRU2B6NqvmRLbXG7zPxfLODxw/GNILpj8
GgQAFuiD3QJeXVpaR9aScJZoc8RmH88oyeYFQ5mCjP8akgWzgctqSBEqOyt/GkIM
IGne9KxEkrigX21F51W+7x6F3DjJXxNJ2USYma1i0nAQ6v2nelx+c1mkwBuwTNLn
IK8T+iAZfpasvr50NlEW
=e4Zm
-----END PGP SIGNATURE-----

--zpKbRLlnGgG674Bt--
