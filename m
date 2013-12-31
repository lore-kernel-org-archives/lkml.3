Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3LaQzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:55:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41959 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3LaQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:55:38 -0500
Date: Tue, 31 Dec 2013 16:55:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131231165533.GK31886@sirena.org.uk>
References: <20131212185917.7ed6b21f@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRMPWTMRwp+GIPe+"
Content-Disposition: inline
In-Reply-To: <20131212185917.7ed6b21f@armhf>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: make snd_soc_dai_link more symmetrical
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRMPWTMRwp+GIPe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2013 at 06:59:17PM +0100, Jean-Francois Moine wrote:

> This patch renders optional the CODEC name / OF node on sound card register,
> as it is done for the CPU side, in the case the CODEC DAI name is unique.

> This simplifies the definition of CODECs with multiple DAIs, especially
> in DTs, while keeping compatibility.

So, this is similar to one of the comments I made on the DT patch you
sent today: you're saying that this makes things better but you're not
saying why it makes things better.  I've been sitting on this partly
because I've been wanting to sit down and try to work out what the
benefit is.  This information should be readily avaiable and omiting it
seems like it will make things more fragile.

If anything I'd expect DT to want to move towards specifying things by
CODEC plus optional DAI index rather than anything else, that's the more
common pattern for DT based things (really phandle plus index) and it's
what the current generic card is doing.

It's possible there is a benefit I'm just not seeing but you'll need to
tell me.

--QRMPWTMRwp+GIPe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwvcCAAoJELSic+t+oim9XPMP/RX538KEOYqY3kQDVf+jJs2Z
cshNr+zpexjgcyjcvF6xuMJ4AqU13Ci4U8y99M2jDgvlX7MXUP4g5m1dNxwgMV7q
pYJ8GlqvpcVc46Y59t15QTZx2kL9Sp++bM2vABl63RBFOf9tCfVYI0OTfzqpjRXI
m2LJP6+G6N1LqSQOQYMWlf+GYnluZ/yKGI3MWqKeSZ8zFRcxfeaKHTk6Dn7FkBBI
xwyZSzrRX/mW5EBbhMyfTrhYaZxtjcvphiIHwNKMUNPYxM3ZjW0I7+mgLfmQJKL5
fKOMpStR+lbiNfp1383jWn+5u8IZN1jZZlMoNWW/vsXA7WmKCcOh55WKZ5r2r9gG
rShNpGOE/MVn4sccGeQyJh7CmOpeTXqg2IgrLli4Z8xlkHprV8uSTtsOV9YRm693
i9vn1X1VD2rpJ2fqjyJ5d/Lva7BYyRQiw50+GLt+59k7p/sV4/y3pMXaWoRAyT9N
1IO8+b+HinAVTtc/3CBj6qnpPkuQTrBg0i1QsIWp5WiDTKIapi3ljrmrAgBOskis
0Mr/PSwkl0Bu4N6Wx4llS03y6+3lbwjSKTM/ARnZNoLI+Sl7r0GlUewWI6clcqq0
irgrSin+2EIIWIrMwdJJYTtdXJQkUaJ36V7hU0AZXYDI0pnoPX+fpjiJecD800fQ
oF6rGAA2d1OO3ObiwJy6
=EW/c
-----END PGP SIGNATURE-----

--QRMPWTMRwp+GIPe+--
