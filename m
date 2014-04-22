Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaDVL61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:58:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41400 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaDVL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:58:23 -0400
Date: Tue, 22 Apr 2014 12:57:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140422115745.GS12304@sirena.org.uk>
References: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com>
 <1398113819-22289-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nmlcH3ziD3PjyGfX"
Content-Disposition: inline
In-Reply-To: <1398113819-22289-1-git-send-email-boris.brezillon@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] regmap: i2c: fallback to SMBus if the adapter does
 not support standard I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nmlcH3ziD3PjyGfX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 21, 2014 at 10:56:59PM +0200, Boris BREZILLON wrote:
> Some I2C adapters are only compatible with the SMBus protocol and do not
> support standard I2C transfers.

Applied, thanks.

--nmlcH3ziD3PjyGfX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVlk2AAoJELSic+t+oim9sGgP/26uvBTRQ2M5n1vulf5a4Qbs
jgIGHuGBdybnNzlLQ2Usq96xauEQkcfvd3O57y22qcwIjTOq62YccAVCAO8oc37c
qWQ409E306CgyQIc2Xr0px4J1mOUSHdgG2bMQVGHWC+/JzCo+ve+sZTF6TeK7u9g
IEajHjlglhvqSoafJEcfq9QhqY20ICdYt+gvWyGE9Bv+mMFzJiWR7BHvrDcEUNnK
jBjWp8K2HPpcLNdcbwW+nNe+79vHc3HVy6Y1J+L6AsDOmHKAlj8suTUqwmPpr7DA
emZ/ykOZPssNPM7wrcBvfDZgy58gdVw5kITCrrKMPG5R0pMoK5Kyzh/ktygbWq9q
cvBZRo51SsCG2fQYYnq6DM8MgzKqMdkjA1ePliG2yUdqTRxHESEzhel8lov/yPhQ
A2ppg+E9AcTLWfCNErDw+SBv+wQAuYsEJT0W1mDEQdNcdHg/vE+5oXf8sZb27+jh
5FVtI2y9M13vszmBnGpHhyYnsFjJL5TELlt/Ji8sn13IMJaxwNe3cuj1l2JG0n8/
yp9HpQ16UEumGQMdt69D9vYWP8pHPvzxt55ULm1uIeOamPCWAcYeQdCd+PbzaHzT
n+6/yE9lNf2PKWTIfDJyyQrwKNJQDJUbFZHAGl8msdFP/QEbQ2K9qfmKKIqKhW9Z
UUmlBq8ZtftLb0h60ZrF
=0zV6
-----END PGP SIGNATURE-----

--nmlcH3ziD3PjyGfX--
