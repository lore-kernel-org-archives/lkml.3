Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546AbaGPNyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:54:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40287 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933362AbaGPNyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:54:00 -0400
Date: Wed, 16 Jul 2014 14:53:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, pramod.gurav.etc@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Josh Cartwright <joshc@codeaurora.org>
Message-ID: <20140716135345.GA508@sirena.org.uk>
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
 <53C66AEB.7030906@mm-sol.com>
 <1405512867.75389776@apps.rackspace.com>
 <53C66F3B.9020507@mm-sol.com>
 <1405515375.452411340@apps.rackspace.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1405515375.452411340@apps.rackspace.com>
X-Cookie: Keep on keepin' on.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 06:26:15PM +0530, Pramod Gurav wrote:

Fix your mailer to word wrap within paragraphs, this will make your
mails more legible - see Documentation/email-clients.txt.

> On Wednesday, 16 July, 2014 5:55pm, "Stanimir Varbanov" <svarbanov@mm-sol=
=2Ecom> said:

> The CONFIG_SPMI option is visible in menuconfig hence either it should
> be set by default in multi_v7_defconfig(like in qcom_defconfig) or
> driver owner should mention a 'depneds on CONFIG_SPMI' as suggested by
> Lars-Peter Clausen.=20

> I prefer the former (defconfig).

No, this isn't an either/or thing - the dependency is absolutely
mandatory if the device needs SPMI.  The defconfigs are a separate
thing, they just exist to give people a starting point for configuring
their kernel so if the device using SPMI is important for relevant
systems the defconfig needs to be set up to enable it but that's
separate to the dependency since there's no need for people to ever even
look at defconfigs.

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxoPmAAoJELSic+t+oim9REIP/iQyW3RexEbX5M7oop8QXx6K
EznBAiMBh2LXS1smxXmuGwrMPo8FZWokLhXo11sSbtU7OwzjvV0m4Mw6NaEv4h9T
Z9dGNncAmg/uZbhdY1dA7/8wL9ZabnQ6fTSQHvSiSGq8MvOBtt1fBu4dEptrpkF2
bRvFVGbTTuEdqylUXu/xb9O1pyHrrROKuFxNK90koUrB/7egXMFsQv9DpgeH12zH
SgbJ4JNnmrK6B4vkfhBI+NvqOjn517y0vTKXBGpFBTw1udyEdNkSVKH73ZdXb0EM
TrC6yqxMKtiahgIFMmu4t025bPirDiuVZEvFi/5uGzpatOFYIToB8jCQYr4/+tPe
7ga3QY9DZwYsm+aeToDMTdB6CKUe7zEfvqPTj6ixl4rfTCUzS1CLOYRVicFqrcvM
rMP75yo9qJV93zP0Fc3KRk51J/IE/mrLgOUWl0BLtrxISF8OnU1kRHN+A2ndwA9R
D/xDYsgq5maxIFPkxbpmvEio0zX0ID/79JsaEH4UrsO9TWFHs1kHQTN38xPTzcuB
wZwzQsz9KI5P2Is3Rti8TiYkQH1odXdcK/aYj2W/4J+TPS4vCCGIJE/n6qjNZ4G0
pOuVBXbly852Wo9wfKhwMfZxUFqdrrEfu/jFB81DsCjZc19fS5hYsxl1KW0qlzPZ
F9+Swx2dc8n2tm1KsOA5
=Wysb
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
