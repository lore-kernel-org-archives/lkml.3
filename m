Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaDRUj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:39:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38312 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaDRUj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:39:26 -0400
Date: Fri, 18 Apr 2014 21:38:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Bo Shen <voice.shen@atmel.com>, Boris BREZILLON <b.brezillon@overkiz.com>,
        alsa-devel@alsa-project.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        devicetree@vger.kernel.org, Rob Landley <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Message-ID: <20140418203817.GA3479@sirena.org.uk>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
 <53518C76.2020005@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <53518C76.2020005@atmel.com>
X-Cookie: Will stain.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/8] ARM: at91: sama5d3: enable sound support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 18, 2014 at 10:35:02PM +0200, Nicolas Ferre wrote:

> For this series I am a little bit puzzled: should I take the ASoC part
> of it? I see no acknowledgement from Mark and I also read some messages
> still discussing about CCF and wm8904 afterwards.

I've not seen these patches, judging by where this message went they
weren't sent to the address in MAINTAINERS (broonie@kernel.org) but to
my work address instead.

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUY02AAoJELSic+t+oim9N08P/A9BcAybl0fKUBUjU66UeF9u
YL0gUySKSiF94XQw9CwD6Y4fX58BEDu6r1IdMXL0i8lAiopFwFffuLRyFN1viph1
+kc2drdyw5N6VJOXNuxAXE76yrOA4SLenfX8HL4lojjEITujXbneRzgHYkBLawym
3rZgIFjD9/tzYcSiO5Z2fJ6Bynr5I8DF648oDjeM8rSy+cjbHWGiYvreVCNObgfu
4R9O6XvOmn60vFon91PJmMzdIIjGkVZ3QMdeYgeQRDANaTSYizlmjZ/gUTnrHW1o
COSp+fpheFojVvojB3UUXmpPbaTg9s5LIrJS9eXVkONVYjkVy8T6mL3j/G6NHJaY
hvg1FGXwRq0XO5YQ0UTSw6idAskVwzgP+g3t4v083vSxlHa8xr7vtQvliL3ZTEpt
/pWvnIR8tPIuKyjc2lLfqRV7ccrmiqZKWe/IZ/fN6A/91p9smOz5Hi+fyHKFZTxS
WlL/kI0AyDSDaStvq4qPGtUVRTJDYXOmN2BD6GvE3+qeoBijvhJ+z0zjlHRECN9R
EJkOeAbTaMbOM+9ezRcwyS+YvVgwtV72eXOAy3Dag/uBMfHt4ufUDWbiaOHbFofN
ndYZbnxQESnYNXufLnHWnRwXQP/jrZzdeB7CkqlPrfaAT5oatlXmUN+FToqrEQpd
mtfLxnF1aCc5xpMbu8Pl
=t7N5
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
