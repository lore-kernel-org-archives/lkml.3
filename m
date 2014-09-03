Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbaICLB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:01:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47888 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbaICLB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:01:26 -0400
Date: Wed, 3 Sep 2014 12:01:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Cc: Dirk Behme <dirk.behme@de.bosch.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20140903110116.GI29327@sirena.org.uk>
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
 <20140829190129.GZ29327@sirena.org.uk>
 <5404246E.4090908@de.bosch.com>
 <20140901101512.GK29327@sirena.org.uk>
 <54045FA6.70602@mentor.com>
 <20140901120602.GT29327@sirena.org.uk>
 <5404680F.3040308@mentor.com>
 <20140901124947.GU29327@sirena.org.uk>
 <5406D98D.7000402@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvGDtX8LmIpY177y"
Content-Disposition: inline
In-Reply-To: <5406D98D.7000402@mentor.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvGDtX8LmIpY177y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 03, 2014 at 01:04:13PM +0400, Dmitry Eremin-Solenikov wrote:

> OK, if the question is about other users, should we review all current users
> that do not specify that gpio, change them to pass -1 and then allow valid
> GPIO#0 as a valid ena_gpio? What do you think about a patch
> that will warn for one or two releases that ena_gpio == 0 will change
> meaning in a forthcoming feature?

The warning is sensible (I'm sure we used to have one though I can't see
it in the git logs now) but I'm not sure a two release cycle is enough
for everyone to have upgraded and paid attention.

--cvGDtX8LmIpY177y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJUBvT5AAoJELSic+t+oim9dJ8P+J1XAmxsGB5T9WZUepQsALVG
GhGnXqhCDRaFpw4slaN2RwMAKGHB3KA/38yBRVISxhWYRGYU1rSv5awFy/0G6BJk
BatZLdnfMYEY51C7J/yWFga4F077ZnzIIUwtkzF7wzKViBuiFcy3TTwVq100PCEF
LvAJV2SusBm44oXX2k7JQgQQHIHsSuMUQcusrPkN/Cq56mkZRJ9zOuWn7xFOYHG+
maT9OaMH9N+30rNGkApCpfLDxkroRBnh9d+fY58l3PAl+sOaoiCuhpJjOPPxFC2I
V1BcQoFpexTxcKk/QHdZniijVOwKU+/eXw3xIWozWKCLFbYGH+G3fqfuaXTgS2Pb
navyGafxAgN86ICMtCzpqN4k5EoMmWXn2aggKe8tLp998/jsK9UG8mDPYc1ywgwA
aWKozZLEMzfiAM+x8U6NxxpSrpUg14z3OUa6vGV8GcVZhzgjMabKohS3Z+/ouCHW
ZiRiJHY9MnKhMw5khXrvWL5T+tq7aAVYGNionly6CED5BPFvpU99IMLsPsHknWrT
O1EJFlaPaTvqubIM8+qUyylrEG05fYrxiFHVANDta1AX7R8/qFLaSvsq/i/XIZ+2
RV04OHPnBNLcwD2360Idn70x9RG8lAXRGBVBfBzrSnNGtwWXR3B0XowH0VlamU7e
Y5PNtwuJW4sRFuPfcH0=
=H3oS
-----END PGP SIGNATURE-----

--cvGDtX8LmIpY177y--
