Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbaCRUS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:18:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57500 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbaCRUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:18:53 -0400
Date: Tue, 18 Mar 2014 20:18:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <devicetree@vger.kernel.org>, <Li.Xiubo@freescale.com>,
        <moinejf@free.fr>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>
Message-ID: <20140318201829.GR11706@sirena.org.uk>
References: <1394593331-22867-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9+r891pQCxLAqAJT"
Content-Disposition: inline
In-Reply-To: <1394593331-22867-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: simple-card: overwrite cpu_dai->fmt with
 codec_dai->fmt
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9+r891pQCxLAqAJT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2014 at 11:02:11AM +0800, Nicolin Chen wrote:

> The current simple-card driver separates the daimft for cpu_dai and codec_dai.
> So we might get different values for them (0x4003 and 0x1003 for example):

Since I really want to see some sort of fix in v3.15 that allows
sensible looking DTs to be written I've gone ahead and applied this.
I'd expect we'll change it again but this at least lets us only set the
master flag on one end of the link.

--9+r891pQCxLAqAJT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKKoSAAoJELSic+t+oim9lM0P/jpv+JMyZ5oul2TmwMnK/Hhb
uGzFyGhPAtrG3HxmSP94k9l+ufMIYD1dyc2Bdi9dpcIetLCqjYmRt0Z07M+hEg+Z
kgsOte7Yre95AENq1/hLyViRfOwN6j5IOj48z4EbGTAx5wt8m3P45KEKu3jYLCp5
acQFuQMClMXUvSMfvio1QGpbhYf6PFlcKnqaglrpR0v5gBCv+aWKbZ61CqCy+wCk
sgcWRUSg7XOMhReSMUsg7K/rJDMpZ0sRI+v2ux8OS/0riYyqWmOK/EcFU/tbVrZz
KoOKIIdOAlfYD802JDpHMx7wcCn+ZAarUmuS2/K9olfzNpBs9AE7ZHtP3+gbJ3h+
hDKAw/UXw+pOt3Z/nRuNFh2NqTKRAuZSmcAqJ87trGBCThRQRXIJ/d2tl6rwrJhF
5Z2jpPnFl7Chb/ftlZDSTZsDjnC206vTnpGj/YjArnEEtTmH7W8AqI5e4dBEeiXM
sxjkkvJXFP4beIobZzrn6jlMtMk8jf6B+O8TgWmaGIjrq65lNC2ce1g2CA7I/uU1
i2l+WQZ5Bh2n6D/JraNtaEghRSTXN6l5oiMSaGZXeOtEUri5pAK9w6H9N9fjPJ1e
L1oJ7YV7IihfblWQRxUnEBF91ATm3WQCIa9wlVrPls3jUSwEtuRx8lWfbed47IH4
V+OX6req3q9prJ1KcsqH
=/7wV
-----END PGP SIGNATURE-----

--9+r891pQCxLAqAJT--
