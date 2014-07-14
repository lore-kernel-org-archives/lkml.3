Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbaGNSDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:03:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37240 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaGNSDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:03:22 -0400
Date: Mon, 14 Jul 2014 19:02:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Message-ID: <20140714180254.GK6800@sirena.org.uk>
References: <20140711041406.GA4207@himangi-Dell>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Content-Disposition: inline
In-Reply-To: <20140711041406.GA4207@himangi-Dell>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: omap-dmic: Use devm_clk_get
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 09:44:06AM +0530, Himangi Saraogi wrote:
> This patch introduces the use of managed interfaces like devm_clk_get
> and does away with the clk_puts in the probe and remove functions. A
> label is also done away with.

Applied, thanks.

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxBtLAAoJELSic+t+oim9lL4QAJQj1PO3rOsvvnoH3gbAfN45
CD77ibMHnzFxhgmsIMux1jgfCf6A7DGWs/lu/+0S2Rkfq+jL3k3O/2WQf/J0iiR2
LHwvXczSJONtFVO08/wNYvzFbRin89qBlitbWcyPi2v7670xIxOWDbQay9dF/tuq
3vYJ3wUL2qB370zClrE1tSNHphTyUPR3GOSoi/I6MZKcObcUWYSxgQ5y4VZ3GdEi
jMxwkASHOGTMZOpVq3e9ZSYD4yIml1Wdhar1xoA5alLfiwMIV9R0MD047iAq5Kv9
y6aQrpfZUKTo25T6k+zhA2FQ1+evIb908iw/U2kiojvcHcpGjgkUkv64hdyWCB8e
f+pZZRQTV7yrj0t0MmMQGeWe6kxdXjn3LRdRYek9jCZE89kb8Klc610/JC7xRBSy
GBWUyjzIEOQuv6TtNScaqV2qgXWsVwBIcISjTXVSxyZ/cAyOIcEjVvFeYqcD7gjS
+yjQz9KKki2wWYY+iJFoRoMokGRtsZ0tF4sIICJjPidnwPA2HQYTEg78P4iud0OM
ENn40ps0dWW5GD81VelUWDjF01EBNsqkGdvvNUt7qr7q7HWcQzZBFzJvjmDkSiaI
A6YhGkkWt1JnAEHMR0gAtLM0bgqODRvMwFJ4FRfBJCUSVK25HdgX2od3kQJ97eaS
MQLgOdyZS3tSzhzpE2qG
=46HW
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
