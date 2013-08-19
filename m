Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab3HSULE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:11:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41765 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3HSULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:11:00 -0400
Date: Mon, 19 Aug 2013 15:10:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH RESEND] i2c: move of helpers into the core
Message-ID: <20130819201005.GM26587@radagast>
Reply-To: <balbi@ti.com>
References: <1376918361-7014-1-git-send-email-wsa@the-dreams.de>
 <1376935183-11218-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="McpcKDxJRrEJVmOH"
Content-Disposition: inline
In-Reply-To: <1376935183-11218-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--McpcKDxJRrEJVmOH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 07:59:40PM +0200, Wolfram Sang wrote:
> I2C of helpers used to live in of_i2c.c but experience (from SPI) shows
> that it is much cleaner to have this in the core. This also removes a
> circular dependency between the helpers and the core, and so we can
> finally register child nodes in the core instead of doing this manually
> in each driver. So, fix the drivers and documentation, too.
>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

for i2c-omap.c:

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--McpcKDxJRrEJVmOH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSEnudAAoJEIaOsuA1yqREcNkP/0LKPk4o7wCnJXxOqAyLoeZd
WwCRafc7R0Ls3S5M28xTpxPm+34Ol7FOt8tezKWc1s6G6WCLxEo84glBf4gAWKhf
KaVC35hyoh1tibIeUZR4QfXYKn+UVxu6lMeEwJaC8+yMhuMjq0SLXBHkAUwsLCiN
q3/Unq+bsuNgup5HnIJ6aAOZfbYj047leZF/cnfqup3epSxcZDsU/1lVj+I19rL3
pTYeZ6WECWwhmxHj0rjEf3mgeqCaMwW8XCsRKDoDTOd/sTcvWsAooC53h2ygYe2b
tS9zeeNW9uIlZSmtR1yNBgr59PP1ykf0zp9jGOY0r8u/oP6HG5h/bAjLMN58dXwt
WWLYYJgj3mrXA2EtXoSKQnDNmJl7tLOJu3oxMpQfBbKlrCECgyvxp54xSQpUd+yB
0kT8QEY/wQXCLjlLJWuPWqHkHw+YNCTap//XQYEfPyubucT27Zxa8wz4vhmkjWdH
Cp1VEWD2O5sWpfwdyS7w54GgAOfkNyuF+FWus8zd7PN1hMxNKui2Tw8n4glmC2Ql
LljlBN9YZUvz9ETmJTFuGFGLnX3PZO/zWeF7JkXbEDjYV4tAlKYo0pW8SeTSnY6v
M3I3C6h4TFKDYmctFDbEJnZl8NBmBImV3Zhh+eRohrhimEtscvyoYAiFXtK3tgWN
ojVKmnuVliAHBulFgZbj
=wjr2
-----END PGP SIGNATURE-----

--McpcKDxJRrEJVmOH--
