Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434Ab3DBLvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:51:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33776 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761031Ab3DBLvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:51:41 -0400
Date: Tue, 2 Apr 2013 12:51:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: ab8500: Staticize
 ab8500_ext_regulator_[init|exit] if !CONFIG_REGULATOR_AB8500_EXT
Message-ID: <20130402115115.GK23065@opensource.wolfsonmicro.com>
References: <1364862038.15806.1.camel@phoenix>
 <20130402112740.GI23065@opensource.wolfsonmicro.com>
 <20130402114549.GA5580@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rf72Gf+bfLC8kxKs"
Content-Disposition: inline
In-Reply-To: <20130402114549.GA5580@gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rf72Gf+bfLC8kxKs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 02, 2013 at 12:45:49PM +0100, Lee Jones wrote:
> On Tue, 02 Apr 2013, Mark Brown wrote:

> > Lee?

> Better if you can send me the whole patch.

You were on the CC for the original posting of this and the other one
you didn't reply to (both sent today) but ignored them for some reason.

--rf72Gf+bfLC8kxKs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWsYgAAoJELSic+t+oim9XGMP+gMWVNnlyPU67moXi4XmLNs3
NWJe0QFeYXXvtAOPhpo0VJOjrLxbLBbMW54dYzuR+c8HaIYADo4xa8B1USCM8Qi9
1T5R7T3KSxNe59Z+Q/NkOm4+C2dUy6SxvlO3lQBTRV1b4fOJrLtR1+aLOnsJOlOO
zvA4W2v0FNkXicq/ZGfxsNNdOPnftL8GNQArwUxJCFClNXrXE/7Km+hNxYKnxoK3
zr9Fvdqc7vaABHNdx47n+mkyMOGfQdl0+v1JGtKv5dsdckCxiWnvFJvkXkHKY7VY
jpF2gyIpbG6CUBJdCyPVfTfcN+8ZoIdkptcV4J5b20X4amDhjBv8w4quNDIkjBKj
JY6ecENPA0cqt+ppnY/vVCat4pJSbezkXOCxZJJeSJK7RzeXIwn4t8QoePoh0lRk
da5UbRA30T7zpta/Flz624IhfsTz6qucnHPi6efizy6ghhemWMQCHy8SiKpA3wbP
nZ7D5CxQxWiXTmTzQUAFsKeF3WAR4dXo560hcUP83xbT/6tlH9wO93j3bVSXnpxO
0mpBpXWrTE0kkat0YohfmacdHGWjzyRHD4t5IfWd1/do6EHvY1ZM3KZGLhIsR++G
fitW3QkyK/X4WCF0Z7FGw3tznaTSbYF5PH/7r4uMX2mJhw7NuDGP8w9EuzsuUWr8
/QWWnD1LabZ/xEl6wmSw
=sVgt
-----END PGP SIGNATURE-----

--rf72Gf+bfLC8kxKs--
