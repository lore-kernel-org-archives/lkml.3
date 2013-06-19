Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab3FSJs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:48:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41841 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067Ab3FSJs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:48:57 -0400
Date: Wed, 19 Jun 2013 10:48:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kevin Strasser <kevin.strasser@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>
Message-ID: <20130619094828.GU1403@sirena.org.uk>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-2-git-send-email-kevin.strasser@linux.intel.com>
 <CACRpkdap753rf82jqDx4CGRcsNRUYwsrsfpJe4=331NQom6SuA@mail.gmail.com>
 <20130619091127.GW7161@zurbaran>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tFjrZTgZYY8Y8fWe"
Content-Disposition: inline
In-Reply-To: <20130619091127.GW7161@zurbaran>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] mfd: Kontron PLD mfd driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tFjrZTgZYY8Y8fWe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2013 at 11:11:27AM +0200, Samuel Ortiz wrote:
> On Wed, Jun 19, 2013 at 10:40:04AM +0200, Linus Walleij wrote:

> > Not really my business, but I think if I was to implement this
> > inter-module API I would use regmap for this read/write marshalling
> > right here.

> I thought about this one and was under the impression that the regmap
> API would not let us implement this kind of stuff. I don't see how the
> reg_read and reg_write hooks would allow us to implement that, but I may
> be missing something here. Maybe Mark can provide some more input.

You should be able to use reg_read() and reg_write() but you're right it
would be a bit hoop jumping.  Really the code looks like a new generic
bus type for ioread()/iowrite() users though - I guess there will be
other similar devices connected in the same way and they probably don't
have radically different ideas about registers.

--tFjrZTgZYY8Y8fWe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwX5pAAoJELSic+t+oim9KJsQAJSpl61SbZxsT4CoI5yCqBOG
cuPnEoMNRLw+jx6lAvWcToSAFpXStKC7o53OrYef+MowCVNptaVwTwCd6S8BZpaY
rkifF6GkYfRrABTLdcrB15lnVN6wnGSj6bc/QyXyqj9Ubtjb6tAsQwSQ0dmLphTR
F+meFsAEvmJKGOtRHCde+cktqrXBtOVCzZNPlJGNyJM9Py5WBOqIrpcYfoNynZcn
1t+vA1djSuRsCKeYij9u92NwrZ8h9COHkxOqZ0hovwtP3cV+PagIb4UnLzbBzmeH
a+P9bQIR1ylaVaEUQtSIHczIi5wf1QOQ7y/MiL/Iww59CGqbL2VUgpThPKE+R4+I
/cu0PIhE1h6h86NRiOfGlhJxf2XNYyudS/xfaIMbNGvNwry05xbvqJSaWSsm+Bc5
iDpFcSwRFJD2z9lck2H5oBzaLvEJkY9X2kswkHriGQVDusgMlUSSD9rC1JH3jfcq
au1gxFBUEfaWByHAnKNFfxZEIzOVIsJiBA1cLODEGdEjvkbHOupREEvq93dEZ233
qddIz9BxNIhIYAx1GqBYYpUMgRaP7DvLSO9NJeJ5JwqDK8J9Kxry/OYgUaUEjvo1
CjOI6KWaUKhGXx2j5j+tfRwOvS/AsGh8xabVh75cCDk+OnYDeFoqgoXE1hWUavk1
pqwP/f+OvY/ku9zOBzFn
=PADR
-----END PGP SIGNATURE-----

--tFjrZTgZYY8Y8fWe--
