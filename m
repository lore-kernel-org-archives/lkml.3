Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3J3Vg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:36:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43286 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3J3Vg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:36:56 -0400
Date: Wed, 30 Oct 2013 14:36:02 -0700
From: Mark Brown <broonie@kernel.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr" <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders <danders@circuitco.com>,
        "vishal.l.verma" <vishal.l.verma@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Message-ID: <20131030213602.GQ2493@sirena.org.uk>
References: <cover.1372211451.git.dvhart@linux.intel.com>
 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
 <CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
 <1372398218.9243.29.camel@envy.home>
 <20130704162641.GG27646@sirena.org.uk>
 <CACRpkdbKGti==FTfHm81EkwD++iRfixnXt3kWgBj7CxjM+2znA@mail.gmail.com>
 <20130721234134.GA9858@sirena.org.uk>
 <1383142680.2460.5.camel@dvhart-mobl4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xiprIVX1FSGBv8kC"
Content-Disposition: inline
In-Reply-To: <1383142680.2460.5.camel@dvhart-mobl4.amr.corp.intel.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xiprIVX1FSGBv8kC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 30, 2013 at 02:18:00PM +0000, Darren Hart wrote:
> On Mon, 2013-07-22 at 00:41 +0100, Mark Brown wrote:

> > I'd expect it to be a bus, yes.

> It seems to me the platform bus already provides everything we need. We
> can just make a platform driver, say platform-id-gpio.c which can get
> it's platform data from OF or ACPI (_PRP proposal from kernel summit
> last week for example). Why would a separate bus type need to be
> defined?

For the identifier space.  We ought to be able to register handling for
plugin boards separately to notifying the system of their existance in a
similar fashion to how we register drivers for anything else.

--xiprIVX1FSGBv8kC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJScXu/AAoJELSic+t+oim9O2UP/1j3RBDdt9UslWA3FTv4oiEl
b6/li/yUAcrEaR73zsSb2S3gnyC7khitAazykrUsaFWTMCQ/B5SEi8ZBjem5KN8+
V5ghIZhBQ3KXQsLwMMjDJ+jfaaIi7ChIsXuPMP4c1qhZIXzb7a4KhGti+fi1nug/
DXJJGDZIDC5YWwDKfP6KQxcLZSfJzKE1Rhgg1CKXlHxHfqAmyGvgm8QXq7kejJUs
667MhRQvblbtYnCN3Pn580QZlr3TJ9mG4ezUbYQF5d5NfloM4v4AuJWuWbThi9uV
c+MELlI6L3FbVpgNZYIRVsGETMvoHPZ9VUuDCgzebdcb5cte0+VbkqfJhksPplnM
CSTpk99eKlnpXkU2E1ILZuP9mb9riPr/KQqZ8ph55wdd/Tj6PNW/rk+U4KIiE6vK
jqE09dQOSZZr3j2xrvxo4MIbQvnNKJLWgneSoyT4pUh0fOHRMRFMLnnWelGal2Di
Nn5NVJtmvOzIWv8FFNyu6D5p30L/Seli3D4V/2dH5RDYOJ0Dl+A4iAqR78vjBmZ1
hQKDpXvl+jn4+0cO1CcYjPDmoCMPKV7/+wET3kUJOyN0NdLEocacZN1N0AxlbvPr
kmEqO/sT7k6gMIw0zptZw/WW/+aC3edk38/ec3SAKemTrwqwYK3qNpdBHTnSn3EN
d+bQtVWOrhkEVBqla5r6
=ywXl
-----END PGP SIGNATURE-----

--xiprIVX1FSGBv8kC--
