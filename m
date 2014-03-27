Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaC0LlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:41:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39282 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaC0LlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:41:22 -0400
Date: Thu, 27 Mar 2014 11:40:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20140327114039.GJ30768@sirena.org.uk>
References: <1395908259-1832-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x0KprKst+ZOYEj2z"
Content-Disposition: inline
In-Reply-To: <1395908259-1832-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Add REGMAP_ENDIAN_SWAP support for values.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x0KprKst+ZOYEj2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 27, 2014 at 04:17:39PM +0800, Xiubo Li wrote:

> For the DT node, just one property like 'endian-swap' will be okey
> for cases 2 and 4.

I'm not convinced that the cost of having to define explicit big and
little endian properties for the hardware is worth having this - it
seems like a confusing thing to have in the interface since it depends
on both the device and the CPU and would presumably break in cases where
there's an option about which endianness to run things in.

> And using the REGMAP_ENDIAN_BIG and REGMAP_ENDIAN_LITTLE will make
> the driver a bit more complex, and also the usage of it.

What's the complexity here?

--x0KprKst+ZOYEj2z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNA40AAoJELSic+t+oim9I2cQAJGUdR1ELF98FtUMsaj9/jAE
rqsl8GneYqeOmBEYaG6axXsrNeGzVeWr1wVFHYbpbbT8ybTsO6GM4Qq1/Xj8O82U
0fVNT3VfPGYiFAgFAJK6QR6uyhk0Vh4bYu/cuuOQvS8LAbCiCyA1toDM3++6I2PY
gVgh9HeEqkdt4STHrWOAQBmYGYpTv2kd9Y6x2OUY2II1oa4lbZehTV03OHR97++Y
ZT87+PMyFVuem7A3p5GSRk8ImMwSWcrN/9zxm5zwsEFSs9xME32O8M3eWP+A0WqS
mGxdeXspjfGYjKxAZa+BNJ/g75NWDoNmYfuwNOT/MhhVJcRJaBHv4ZbhjCvI/SuL
FpSurb2L9fLGke80XkTwVCPjeVtE3kELck70WSvIu6NQSQ15rQ5nnJNwhp9v7YCZ
9iGaAUXnYtCAOkWoIjHFhDhwJGLeAeKPaJpc9ZoLFBgdV7g6fe+VUEaJEArbAy25
GBQhtzQyPa/mc/k3b479Es7FTn10+8EHnXwvK5fmxICb2imMmFnSyF5OJzrEH/si
G1Ev7BebfIltSR1k4qCu2gmylHj81KSvI+OGv/VjRf8hgnguGizPfmhbFOtZPHcn
/7hoBEI5yZZUtpR13mpdSn5ocD3fUWdpvXOQzKAiToZKFaZ/rAG7A1eKltso2V2s
Ak8fCvTmLsK4xXCiFPsz
=Ed30
-----END PGP SIGNATURE-----

--x0KprKst+ZOYEj2z--
