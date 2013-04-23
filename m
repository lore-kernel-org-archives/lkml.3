Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab3DWS13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:27:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52633 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165Ab3DWS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:27:26 -0400
Date: Tue, 23 Apr 2013 19:27:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH 09/21] spi/sirf: fix MODULE_DEVICE_TABLE
Message-ID: <20130423182724.GU5019@opensource.wolfsonmicro.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <1366734653-488286-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sx3M3By4KbPIrykT"
Content-Disposition: inline
In-Reply-To: <1366734653-488286-10-git-send-email-arnd@arndb.de>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sx3M3By4KbPIrykT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 23, 2013 at 06:30:41PM +0200, Arnd Bergmann wrote:
> This fixes building the spi-sirf driver as a loadable module, which uses
> an incorrect MODULE_DEVICE_TABLE, by changing the reference to the
> correct symbol.

Applied, thanks.

--Sx3M3By4KbPIrykT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdtJ/AAoJELSic+t+oim9x+cP/jzdHTuVfonTof0zF59GPxxL
3lTc6S/tQ0JD5j3mGTe7hD3JeR8PbF86TQSLFKZOCH7+hsgNMQHnEqi3Slck9XqN
uAVBwZnXph+v4DHSjq2pUzuxCLg4BMcg9x0j7J2bzL6d981C9S/eSWZDFWyX94xY
Tz+km9KcdG++uvLG2ZTsDHdLtzEr7qv6NRqNiXD6kE8tvVPlCEUqHxPjhOErzzKi
GWJ8x7xuW2w9r99+ETcknlflPLcwUMoNzPH9AqpjuOnMU8TjZfFwLXI+RHFgHRjo
uNMhYFhsSgfaO59XeuVoM53+8Ud4atAJYUM8d/uwB/SEpC9n1yHb7+5rNg6BFMbj
brMcrq2hSViA6raReOF3IJuvRrTkprQSYF3MSpa7J10i3u8bZRhkF8AW1sRLTV+7
GsEi4HkjBEJP8N7p+lNpGgLcE9c+Chac/PGT7b8hQ+/Wh2ZwuDbK7Uxd6b2Qxd6Y
XPh9mExmicCHXFFvcM3jdBIfK6XINYca9JcEug08WyRn87rtcZXWrayA1ZKh+6l8
5A4XoN7XCpvyvHBJfp6v5dgEoTIzotxPyM4LYSHcnKEmNj8cPc2inWy1O4LLA6xK
QyfzqiystEh5V59hSaQHmQ7je9hm/VgoA05hWMk/+GCaf6Hh0NH6FkO3q0mxXrjx
t4+xtZ3gM3t12DZv2xfJ
=ZCF1
-----END PGP SIGNATURE-----

--Sx3M3By4KbPIrykT--
