Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab3EPSWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:22:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57894 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3EPSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:22:03 -0400
Date: Thu, 16 May 2013 19:21:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130516182122.GG1627@sirena.org.uk>
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <518D320C.4010707@elopez.com.ar>
 <fe9e603e-a432-4a29-a195-fd393b875a7e@TX2EHSMHS006.ehs.local>
 <518D411D.9070209@elopez.com.ar>
 <CAPtuhTgsP4gvMAFoQb3icXAZw3ucSg4dfrAdJMho-VxNmNTvwg@mail.gmail.com>
 <518D7C45.2090602@codeaurora.org>
 <20130511142132.GA3200@sirena.org.uk>
 <51945F27.7010003@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t4apE7yKrX2dGgJC"
Content-Disposition: inline
In-Reply-To: <51945F27.7010003@codeaurora.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t4apE7yKrX2dGgJC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2013 at 09:23:03PM -0700, Saravana Kannan wrote:
> On 05/11/2013 07:21 AM, Mark Brown wrote:

> >It's much harder when it's in the standard kernel and there's no contact
> >with some of the users.  I've pushed back pretty strongly on some of
> >your equivalent stuff for regulators for this reason.

> Agreed. I don't really keep up with what's going on with the MSM regulators.

> But at some point, I'll start requesting for this for debugfs. It's
> terribly handy to debug power issues, run unit tests and for debug
> sessions (debugfs. So, clearly!).

Sure, it's handy for debugging - but it's also far too handy for writing
silly things in userspace which isn't something we want to encourage.

--t4apE7yKrX2dGgJC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRlSOfAAoJELSic+t+oim9qjwP/iQyKtFO9DpMs/6zjbGHAO7U
zebCiLVRQGPDOVkMmksD74Ke3XMHQWU2hp/Ew/5sZy16oXgvii8i5Rh9M4Jda65V
6sgUoSEBieCrE4YHkdnCnu1b73fZYBmI4c2Z+4kwxTiNbGkdKaQTRzAzgNuaE8/p
Nn4kAJF0RL760nbsSad3ybsOzhAa/HzB1Fouv5hxTP01uls7GarGAXaTvCeYgOmN
15TYI3lLuGiTAA7X7DSGfMjgw1QZ5crAr+QnWbIlt/uWEqXqhs5YUPZXORPHzVIQ
/RYWXEZfb1HdydM1hV+Qq5TN2FCXHqcXsvE9quvgOiR0n42Yvde7vUMU/baL+Ux1
8l1x4GRrznqa4qLTaSFDMrlQYhKbi3zVYthPrq7NLbBeXEJiYSgzGwM9HpIWlwBN
VwhPYA2GRgoLwbmefCOlrSTXs5hnmPWetVI35Tz/o8XAxnwEOX9tS+uLw/kJuOyI
tCPgqIZLAX2hSxej/eK+J9MXwlvlI8AN2WOALuXldygT87SYUThW+KH6wBPzUBiT
QXl7uAS/UFveNFdP/8Vrg7vLWS6+3FrX9lmtCfwM+wMYK2d6yhmYA9Jt8bPPoDET
HU7zdRLX7uF9rBbsDggasUrY9dGUkvtZbOVEFNFIGHuUHKZ9qHcFAXvyKW2MMRuS
LDbwDmylAotenkU6NoKi
=uHA9
-----END PGP SIGNATURE-----

--t4apE7yKrX2dGgJC--
