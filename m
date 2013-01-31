Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3AaLY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:24:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56041 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213Ab3AaLY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:24:27 -0500
Date: Thu, 31 Jan 2013 19:24:16 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: alsa-devel@alsa-project.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com,
        lgirdwood@gmail.com, perex@perex.cz, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, rob@landley.net, grant.likely@secretlab.ca
Subject: Re: [PATCH v3 1/4] ASoC: tlv320aic3x: Convert mic bias to a supply
 widget
Message-ID: <20130131112414.GE11078@opensource.wolfsonmicro.com>
References: <1359631394-9511-1-git-send-email-gururaja.hebbar@ti.com>
 <1359631394-9511-2-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <1359631394-9511-2-git-send-email-gururaja.hebbar@ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2013 at 04:53:10PM +0530, Hebbar Gururaja wrote:

> :100644 100644 e7b98f4... f47c3f5... M	Documentation/devicetree/bindings/sound/tlv320aic3x.txt
> :100644 100644 ffd9bc7... 9407fd0... M	include/sound/tlv320aic3x.h
> :100644 100644 4989143... 65d09d6... M	sound/soc/codecs/tlv320aic3x.c
> :100644 100644 6db3c41... e521ac3... M	sound/soc/codecs/tlv320aic3x.h

As mentioned when you posted this before this patch needs to update the
machine drivers using the device too.

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRClRUAAoJELSic+t+oim9L+UP/0MbgirGaZ56JZ2U+2NYlmqN
4fR8DtqAPVA90eVqULe7BncuBv8t+b+8RiQBqXB14d9QnicuxZuzBp0zI3M60spG
eJ+i+ckBt1kZPcfn2Abs/y/BSmwmRUei1+RMSwR4Trc3JMl2xZM8h1M4Tu/Dla8w
kAnNUvpkc85IhsXjBScAtJOLKhagVjRGMOzc8GMRvptMwl2ShQkXLIpCN6f9Wt8T
4tAPU0chhofamLyoCuLCYhDu1M4ekpnHqaa3FJzXhZM9XjeSYVTQGBv+lWefgH6T
HSW+KbtkxxbwlN6FvIoIs2RrQcEcYFNPRcb+4aUOeTRGDZS/JriE+2KqYfgRHqlL
0rqsQXIZhL/oDCP2F12PNFVNRsBArpaHPqFNCmft6HYpgr1wumyXuEgLZc8eLptM
6ycD9ee67qWh1M6UYThulTbs7DucGWllqipEA8UfAHsEYVzkhvAL9cxHFWrIfI5J
DnuGl/ykx0N2iirat/vvlsmoZnoVqr4uSEkUGz6Avmy9JCx9rnM6vE1Syjwl3E91
/ihYR51BaSSLDh+aKDqW3BrGpciI/vfT0KI5hv/v0beHbouFOWGRNYistyl7wIxi
bIk0//GeUYJRC8U+xVTDm815zvTP68J2APwVvQbK17M+NHvvZ2M38UofnUvcIF9H
cWfbtdcVTa5t760oMrG+
=uL6c
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
