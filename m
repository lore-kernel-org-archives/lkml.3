Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaJONnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:43:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56207 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaJONnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:43:14 -0400
Date: Wed, 15 Oct 2014 15:42:45 +0200
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Romain Perier <romain.perier@gmail.com>, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org, heiko@sntech.de,
        robh@kernel.org, mark.rutland@arm.com
Message-ID: <20141015134245.GH27755@sirena.org.uk>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
 <20141015124142.92D0EC40B00@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CsAk07yibld3GWUQ"
Content-Disposition: inline
In-Reply-To: <20141015124142.92D0EC40B00@trevor.secretlab.ca>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff
 capability
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CsAk07yibld3GWUQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 15, 2014 at 02:41:42PM +0200, Grant Likely wrote:
> , Romain Perier <romain.perier@gmail.com>
>  wrote:
> > Several drivers create their own devicetree property when they register
> > poweroff capabilities. This is for example the case for mfd, regulator
> > or power drivers which define "vendor,system-power-controller" property.
> > This patch adds support for a standard property "poweroff-source"
> > which marks the device as able to shutdown the system.

> > Signed-off-by: Romain Perier <romain.perier@gmail.com>

> Acked-by: Grant Likely <grant.likely@linaro.org>

> And same for the documentation patches.

I guess I should apply these (except the DTS update) since the first
user that's being added is a regulator driver?

--CsAk07yibld3GWUQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPnnQAAoJECTWi3JdVIfQ+w0H/3A/sjye4JqIOxvenRIDnuQZ
jlt/izB74roth3m9ga3wYqURXSqH+V9Tr/lMtffwBK3BLDnegA/+XKI+xQRuevyg
629j1b5koylFOm5foFS+jGXyff7nPw5Ia7rDrr3uGpglsgAAW9ouwLjg42TxD9IH
JWXUiyKdxcrd4tfYVIg58MPqtmugo7laNcfuFW2kWtLGox+VZD4vEQRmZcHLPML7
woWBWONI9aQdEvZD86YsF14Dbdeb+fM8ZRg7ek9E9l0nyvQynJTjaQljL3OxAzh0
5r3QGetlBsm66uM5qLRz0hRSa+5PWJjcAD9x9NAoIgh2U+Od+WFIJpU/ny/RozM=
=JrLv
-----END PGP SIGNATURE-----

--CsAk07yibld3GWUQ--
