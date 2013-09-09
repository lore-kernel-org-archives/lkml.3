Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3IILDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:03:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60720 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3IILDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:03:11 -0400
Date: Mon, 9 Sep 2013 12:02:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Daniel Santos <daniel.santos@pobox.com>,
        Daniel Santos <danielfsantos@att.net>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20130909110257.GU29403@sirena.org.uk>
References: <522BC27A.5080303@att.net>
 <522BCA33.6000701@roeck-us.net>
 <522D0D37.3050500@att.net>
 <522D17EC.3050908@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TPGKQYD3WP7vMswh"
Content-Disposition: inline
In-Reply-To: <522D17EC.3050908@roeck-us.net>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: "Virtual" Interrupts -- Need help please
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TPGKQYD3WP7vMswh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 08, 2013 at 05:35:56PM -0700, Guenter Roeck wrote:

Please fix your mailer to word wrap within paragraphs, not doing this
makes your mail very hard to read.  It looks like your mailer has also
reflowed Daniel's mail.

> On 09/08/2013 04:50 PM, Daniel Santos wrote:

> >Even better, thank you very much!! If this thing had more EEPROM
> >storage I would consider using the OF format for it's settings, but I
> >only have 256 bytes to play with so I'm using a custom
> >compression/encoding.

> You should really use devicetree anyway. How you get it loaded on
> demand is another question. Lack of storage is not a reason.  Custom
> data will likely not be accepted upstream, if you had that in mind.

If it's embedded into the device that shouldn't be such a problem -
especially for something on a pluggable bus that could be used with any
architecture device tree is pretty much a secondary concern.  Device
tree is far from universal and the main concern where it is used is
with avoiding static board files.

--TPGKQYD3WP7vMswh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLareAAoJELSic+t+oim9KDAP/1ixi6ZItG3guPt3wiwfSxJS
dfE2M79dNHxvLpJ3kIueP3IO8oTdJL9SNV08Ee4yMvGt9Ars4e0mCHk+bqfev45p
JuB0y0H5lvMs6/G0l3uHrE12tWIpCjMvnojkPqBcH02ER0mJxee+mC5qo5aKBqCn
svGWngvvZEs12D6diH9eVTEvXh5AIvLQfIgF7CfIdIwVz4zwisSMZSrJTSL3SlPi
pE280afJFeU/qWIgAkTNKVO8E/f4X+myk0zAMymAsbTO5bKoWvfCwNXeW9yqqcIz
Y1baiy/rjvIVe3qwp/G+f5WzfMTAQKrm4YiG/Q/xXOVqcV5gPyWrQqIkN3/1nQH6
hFfd8Ab4sNl/YhvvdJqqxjOsC6qz0Nuv9d82ajE6ig6rAjgXcz1awGB0oj91SlLF
eyJkyuiDyCPoeEFnHazhvbKo5NEwDzdrm6F3VtMKz+kuQWQoPMK1PZhCCenVrGL9
AIEP7k2xU/uu6uIftWrQMvQ3ux7AODER22bg23HjgRPhg2kWI6uFxIWAEkO7tm42
qDAC5lSAx7dssGbZOCRCKtQTMMf6DR4UC+6SCOgEOSApqxVgIUnXFiwBwljeIXAl
GmPfIzJO6E4uNPDBhwuZleDzZr/W35exdGbJQun5/9kzswVMXTRzn2C1m87UhNjE
3Wm1ONKNrWhfvv5AZakP
=HfYD
-----END PGP SIGNATURE-----

--TPGKQYD3WP7vMswh--
