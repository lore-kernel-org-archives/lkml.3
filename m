Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaA0Tcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:32:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60163 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaA0Tct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:32:49 -0500
Date: Mon, 27 Jan 2014 19:31:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-sound@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140127193149.GQ11841@sirena.org.uk>
References: <1390805726-1841-1-git-send-email-voice.shen@atmel.com>
 <1390805726-1841-4-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aNvCJ41Feu8IgPyB"
Content-Disposition: inline
In-Reply-To: <1390805726-1841-4-git-send-email-voice.shen@atmel.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/3] Binding: atmel-wm8904: add option to choose clock
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aNvCJ41Feu8IgPyB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 02:55:26PM +0800, Bo Shen wrote:

> diff --git a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt b/D=
ocumentation/devicetree/bindings/sound/atmel-wm8904.txt
> index 8bbe50c..2d86e2b 100644
> --- a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> +++ b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> @@ -33,6 +33,12 @@ Required properties:
> =20
>  Optional properties:
>    - pinctrl-names, pinctrl-0: Please refer to pinctrl-bindings.txt
> +  - atmel,clk-from-rk-pin: bool property.
> +     - When SSC works in slave mode, according to the hardware design, t=
he
> +       clock can get from TK pin, and also can get from RK pin. So, add
> +       this parameter to choose where the clock from.
> +     - By default the clock is from TK pin, if the clock from RK pin, th=
is
> +       property is needed.

Can this be made a property of the SSC device so that it's available for
all cards using it rather than just this one?  That would also address
the issue with the way the configuration is passed to the controller
that Lars-Peter identified.

--aNvCJ41Feu8IgPyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rQiAAoJELSic+t+oim9SaQP/j/gJn19O2uDOb/Vy9xTetL7
xdX9xq8LknromRrCXPIzOafVM3+UK+NvPI1cgA9PYCaJ61djg/KfR53tHrpscmzk
V1xlmCfNsgtH0H1bW3LGRXq6PAwcZCj4ppL1Z7EDbT1j5OpSXQvKYN5WP8j2lhPo
67NYWnvDDliVVoH39gzaw1o+c/mEYfb0seAFOyXFUPwqxKvbY5/PpUJaz+6AT7ZS
BKI5BlVcEsqoyBSbvHiIPc/x5OFxPv1EQLHwh866NPXoYdYHvkn71jjSwkGd/2b/
GZ8Ut+NC19uK9/ObsU35jQfHSck6OJzgoKqVxWU8ggbdVUgxC8tMy3mnrrJ1qH73
QqTeyDSmkwBkpnAVpBBqSB5fKYSm0EMSLGJoftHdVOmHcEXeDRyQhBxcuGpeXSMa
ICmRR+/4iJjF6Ok4IiLzYYritzCUe8Qt7PNPvqvNTEHbdR+nPa0AlWYt7fRf4lDO
XUq4WHcHTXUgw5IEayRsqWOCwhF22IqyrrLymfFtJHxQR9c4wly4RCV6TGXV/L1c
deikYCcxMlf4LCFfKOIBVxk0WFnVNKyMlghIuyZ7KOwzIg5zyJNTsyEdzZfiy2dR
kOkfPUqIMC8IReySjDlU0fARWpTY/tIODT1BwbmPIhxBZQ35ZZ1hD4+645A/jfd3
RKzcMdxMYzH6SnA7deBd
=ubGp
-----END PGP SIGNATURE-----

--aNvCJ41Feu8IgPyB--
