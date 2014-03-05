Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbaCEDXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:23:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55859 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaCEDXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:23:48 -0500
Date: Wed, 5 Mar 2014 11:22:14 +0800
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20140305032214.GU13126@sirena.org.uk>
References: <1393984730-14828-1-git-send-email-wenyou.yang@atmel.com>
 <1393984730-14828-2-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qpPEP5KwiTnADq8L"
Content-Disposition: inline
In-Reply-To: <1393984730-14828-2-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: atmel: adopt pinctrl support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qpPEP5KwiTnADq8L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 05, 2014 at 09:58:49AM +0800, Wenyou Yang wrote:
> Amend the spi atmel pin controller to optionally take a pin control
> handle and set the state of the pins to:

Applied, thanks.

--qpPEP5KwiTnADq8L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFphdAAoJELSic+t+oim9mwkP/RlnLd4QhqQplRiqu84fq/2+
45YiQ+wDdAfwhBe0aTw0BTCMSKTryN7SqQI9Qwoew/dKghiMb7HkuEeiDwsRfUMW
bBsVmmclVJzWsHWZYXzDYWNMobPa8CigDSDS8/dq8IevnSzZw3gMCmEJkRXn3x6S
iG0JR1yRk81zA/QqGm0e3xp3KeSvQG06CKscq3Qlnq9tifjwtexuFx430ACuhe6U
GzdEJ4zONb0XU26Q0Wdo8pzJnUzVTrc9SupUG2cVi8KsKpraOQZyL+FkuLMcljex
pswTxRFxlGKp0caOqakNIUWRan0jWEQitK4cyvlMQudkLAn55niZBP2hYTk8uiDr
gkpH00CgCC4aBt3hKMMyzKkr2KJhcyw/Xl9NvZ7rExzNwqJ7aeped4UZ7mHGzcxt
bTBOri7pxT+dOc2L2tqci6+56p91N7u18CnTzhHWjbrP01R/jFDB+V3no/GHTWsy
V3+7nOyeKS+6hkl7Z/P28T124c/y1IvleJUsOhy5osE5JU6OHudWABDBW1HjONHO
bMDBdsVySKCuDkRN+RW4P5Q+MjUvQmvoi7dc9al6+h/T3JGQxtNw6NhbHw4NlI+4
BX9jlDVy5u0oAX9WN3A8HDYTzGXQ7J6zmKmuMZ/BGWlgppaulZ8XtqDqQa7xO7LV
Ifjd6siW17J+RYncRXfM
=NTnd
-----END PGP SIGNATURE-----

--qpPEP5KwiTnADq8L--
