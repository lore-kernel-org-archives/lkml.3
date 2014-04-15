Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaDOLNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:13:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33763 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaDOLNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:13:51 -0400
Date: Tue, 15 Apr 2014 12:13:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vinod.koul@intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140415111327.GQ12304@sirena.org.uk>
References: <20140413224631.1a1bdce1@spike>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oDto3OTLsk6uOlQH"
Content-Disposition: inline
In-Reply-To: <20140413224631.1a1bdce1@spike>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Intel: Fix a self assignment in
 sst_mem_block_alloc_scratch()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oDto3OTLsk6uOlQH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 13, 2014 at 10:46:31PM +0200, Christian Engelmayer wrote:
> Remove a self assignment in sst_mem_block_alloc_scratch(). When calculating
> buffer sizes there is no need for statements without effect. Detected by
> Coverity: CID 1195249.

Applied, thanks.

--oDto3OTLsk6uOlQH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTRRUAAoJELSic+t+oim9V9oP/1/TKltXRdsWAlCBGO4A6Bpw
me9hmS+P0HMwL6FujHNh5CRg5ztnocIGjGqqDj9BjaOhWWkGj5EDv9Vxm9PByZIq
rc+7hxRk6DCCyg4brnD1PARIA3NoufZ15bOkt50wAdnI+QblLXoxc0+Kl+Rg0imw
qN8wbi6zTgpbZUhZabpGXNu8UfEWizrKCRHA3HZR7f0GH83nSQ+kVglLcQX9JQpC
RxjPha6UQflHqveyR2z0AGD6x6MAKN57ot1ZJhWiC8M5aclilLtgx1y3mznUzFrh
ZCqiD8OSc5Smq19Hkp/1F5o80Rdh09lwmOYE5q5OCYOBInNCpRhBaA+mKKtNfClo
X5DBnYQDksEUNuNq8QVU4egFMlx7khSX/YaydylKlb/0RbgEPmG8tI6sVrXTsirB
foIF4B/w+cCCBjkqrEO3dIRU7CtcvY23s8e6uMSK2mfv4ToZXlHeVBeQzB/Cc69Z
wvn03mLURqgI9C5XiimDVd8qqOdRw8SanoE1ZtWFxqprTBJmTng7Gje6Ti/Wy+EW
5k8KpVOj5JU/g0g/SVJHCYRsqpl2bBVzgg1sy60WDUFFxRMKNhhUE8sKCBS7b+hI
FZINYX+QKK1bWvpSz4WeGmrFHOmECzIKZTPsstPbvDE6zc2JsN4yZiADiDEvDXld
DzIQd0vbDyas7HpYl/Xx
=nPPs
-----END PGP SIGNATURE-----

--oDto3OTLsk6uOlQH--
