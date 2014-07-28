Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaG1V3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:29:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60115 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaG1V3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:29:15 -0400
Date: Mon, 28 Jul 2014 22:28:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Lars-Peter Clausen <lars@metafoo.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140728212831.GF17528@sirena.org.uk>
References: <53D20A61.1050506@metafoo.de>
 <53D21066.8000905@monstr.eu>
 <20140725101815.GO17528@sirena.org.uk>
 <53D2324B.4070602@suse.de>
 <20140725103905.GP17528@sirena.org.uk>
 <53D63746.3000905@suse.de>
 <20140728122042.GR17528@sirena.org.uk>
 <53D641DC.4020804@suse.de>
 <20140728134420.GU17528@sirena.org.uk>
 <53D66EC2.1050408@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o7PcwBx7JqiqHVZr"
Content-Disposition: inline
In-Reply-To: <53D66EC2.1050408@suse.de>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 09/11] Documentation: devicetree: Fix ADI AXI SPDIF
 specification
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o7PcwBx7JqiqHVZr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 05:39:46PM +0200, Andreas F=E4rber wrote:

> Similarly, your statement about false negatives didn't really help in
> resolving the not-CC'ed problem. I now know to CC you if I ever have
> something for adi,axi-spdif-tx.txt again, but the next person might make
> you grumpy again and potentially demotivates new contributors, so
> certainly worth fixing.

> Regmap, SPI, regulators, touchscreen MAINTAINERS entries seem unrelated.
> Should your "SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)"
> MAINTAINERS entry get an
> F: Documentation/devicetree/bindings/sound/
> or is the "ANALOG DEVICES Inc ASOC DRIVERS" entry missing a line
> F: sound/soc/adi/
> F: Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt
> (which would then still not CC you)
> or is a new MAINTAINERS section needed that CCs specifically Lars-Peter
> and you on the latter?

What you're really talking about is making MAINTAINERS complete which is
a very big job; even if only looking at the DT bindings you'd need to go
through every binding and make sure that MAINTAINERS says the same
things as it does for the matching driver code, and where there are
missing entries add them.  In the immediate case both bits are missing.

Really as with so much else it's much better advice to ask people to
look and think about what they're doing; it's the same thing as ensuring
that commit logs match the standard style for the thing being edited
(especially the subject lines) and that if there's people who normally
apply patches and work on the code they're included.

--o7PcwBx7JqiqHVZr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1sB3AAoJELSic+t+oim9nGMQAJldHc0eVY6J/0zVFEGcyr/r
G3170S0fEioNmr/smd2jVOrH9008+WoDgjjWj5ItletMBLjABwy/sO2p0wMRwEq3
gGhBQ90PKllBiCWuYnY5beLsWEs5Bbn7xzV546jUjR0fBKRUymhN3NA/07Rkgkj0
CveBt8mkkfKNQ/Pe1wSsI//mdSPFAMBjEkUCHXWMkHTenwaGdrg50H6bp2R/rWr1
3EOv4Zgar+/advNzDiG4QYeyGgdPy5A8H2Z1Qi2J3CJpKmnguqwgdtNg6w10OlXN
zNvUNLoLEbHjbe10rM/9yRqCDYSe+yEkNeBjci02lvK8ggqwON4ZQ0ZSOHiRUv/J
Gqhw+NNwT6x7EDrIRUMaBVwK9vusMcANzX/7QKymJM+JXrEndA1XO/mRYepS9b2/
EI22C0iYpCsus61OMOuIT7tw7Zjy//sRmKYcpwER7s0BF5kgHzrIgilj1F1wcVfE
kh/Cmk+sEA55aDM8hi0Pt8JqkX1WK6xomHJdsVO03zx+BoCTvdISEc2RLriChivM
5eeuWwWTWLhcHJPUO1d7aaKfO7Z2vrDCH4Hrq30kl9f322ZvSvsRCn4qfXbhObfw
tl2n5T/e9d4EnvVL+OOVenNKyx8UvexVhq6x3EXIFLeLqMp/xh19JbaGs8rpftpC
gHT9qv3dpRYno4NKGRnw
=vbZm
-----END PGP SIGNATURE-----

--o7PcwBx7JqiqHVZr--
