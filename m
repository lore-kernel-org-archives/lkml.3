Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbaDBTs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:48:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50459 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaDBTsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:48:24 -0400
Date: Wed, 2 Apr 2014 20:48:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140402194812.GK14763@sirena.org.uk>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
 <1396433349-31470-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRokNccIwvMzawGl"
Content-Disposition: inline
In-Reply-To: <1396433349-31470-3-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRokNccIwvMzawGl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 02, 2014 at 06:09:08PM +0800, Xiubo Li wrote:

> +sai2: sai@40031000 {
> +	      compatible = "fsl,vf610-sai";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      val-endian = 'LE';
> +};

This is mostly OK as a binding (though it should be CCed to the DT list
and maintiners as all DT bindings should) except using upper case
doesn't really seem idiomatic for DT - lower case is more normal - and I
don't think we can make these properties mandatory in themselves.
Individual bindings would need to make them mandatory.  It's also odd to
have a mandatory property which may be absent!

It'd probably be better if the binding defined what the default
endianess was too, or just didn't say what happens in cases where
nothing is specified, the latter seems better.  Generally just not
mentioning regmap is better for a binding definition, the binding should
be usable by all OSs and not just Linux.

--wRokNccIwvMzawGl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPGl5AAoJELSic+t+oim92VwQAJHm2vYiFQuwMgF7nTDV/BxI
xLf85c6tcmFIZY0hLIEL2EBZ8At6PyKUFjbW1/XT12SAAtnM80jBVOB8xvU2esER
tqPyygLAo/ExQQU4csJP7vs3rcFHJwSmgV+Nfg235v+wPbjhHdl1g4zK5Pxe/7st
FjwvWQyTlTyxAx8pqEqYewD+FZ/tvp858r/Fap3D2RmzWvQPXk2Yb6p3Rn+G6aHC
dOEly+MSo7dClAhq/KWpvshmf4HRm3T1wvzlK1xhOxRDvmNM3T7TKH0+RUiDKNjR
+doKZhnTRDOB+OBrsCRrSoZJ7UnAaSklMneYwRQCW9HMLn3xO+zgGl3dLu+V9T6s
MWPRl4fmqy8NLklIoYmF+NLVcBRnf2oV3cezMQRdHRQxDNkFeo/rImS+2rEw7GKb
HBi89G7lH6BfEW+Hh9balsiO/N+ROducDnOFo2lDsrrgWEb4hrRYUEsYbBAO7F7k
yMNnn5LwxaHsemtfgfMr7yPeTLE/IlC2lV3Zde55poPdzrgiUxvJeD0vN5whHopF
bHStBb0qjNEl8Jqcho6r1TwHGL8/Xmrg5RUglZnWjIWqpEBCzmNn+RfYuScc6A+f
EcLT8dct4NQJwj2HjBZgJUxkosqby285JS0dNqxaAfMs1u6Xin8FRpe0JjGI62j8
JY7jiL/oR0YqmfIY1nDZ
=U21g
-----END PGP SIGNATURE-----

--wRokNccIwvMzawGl--
