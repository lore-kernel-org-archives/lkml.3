Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaIAQs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:48:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45065 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbaIAQs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:48:56 -0400
Date: Mon, 1 Sep 2014 17:48:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: moinejf@free.fr, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        kuninori.morimoto.gx@renesas.com, jsarha@ti.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140901164823.GH29327@sirena.org.uk>
References: <1409554012-1427-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MKyq+TZLpK62LzFe"
Content-Disposition: inline
In-Reply-To: <1409554012-1427-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3] ASoC: simple-card: Fix bug of wrong decrement DT
 node's refcount
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MKyq+TZLpK62LzFe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 02:46:52PM +0800, Xiubo Li wrote:
> DAI links's cpu_of_node's and codec_of_node's refcounts shouldn't
> be decremented immediately at the end of the probe() fucntion.
> Because we will still use them before the audio card is removed.

Applied, thanks.

--MKyq+TZLpK62LzFe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBKNUAAoJELSic+t+oim9ywwP/jNIaGr+FK0cApcEdYIVvCEC
Hr4QpH4Z188cc9cbXrD8D3ymR/Firr1KkUv2QqTbXfvZqDvMHuxnbLSBXZY4AQRd
+9iTHdT1zFVWhNNce7pXGV3OQ6ofuKut2tzaLK0+M6/HEq1bbrUnIMkUZsPHYTo5
cRn3tXXKVS9ZFX2aDDjyze340XI3TH+DO4heXJO92BOg64jHNWavMlq3eT8hb4wf
4W1CDQqye00fLc2YxPb8e3m2c7Klu3yblARDZu80JZOxfGj4B2hwFBnN7xpnfzCc
EhVTH/ZvlIhcdxnDUASCiAXWRCwf9Y/q15t08SD3FokKtkBAsubdaDYaC9wENJn7
jv5AwVjZJbgEMBxftGhphFWljN2l+zUkKlsmy4jQiqCgYJ85tmhE5b1wIQKvbSWN
OD51kDvmKm45iHmh+FpSE9tzDrByG15pQmFgaZPV5RLKsY31iGMAYev+C9hniLu5
FUcx4dkyNuYy3bTsrowh9ojUGIbkEj5M4Q7vULdlmULqcTPVcml/2JuLFAmB4G4/
79Nz5xUaRppE1wlLovOvoouEtUFFjnt2ts4r9zlic9UG4JgzcUPoIkxahEer1xWj
GCbBd+bJvIHERHe1J443TkWgcTnsHMs2QTBNWp8XjNN776PEKR4jWMyYgzKQ6Fpl
1P6B2lVvFilsL7OK3XsD
=/Lsp
-----END PGP SIGNATURE-----

--MKyq+TZLpK62LzFe--
