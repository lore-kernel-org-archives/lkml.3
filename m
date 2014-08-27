Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935534AbaH0Rvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:51:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36356 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaH0Rvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:51:46 -0400
Date: Wed, 27 Aug 2014 18:51:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140827175116.GL17528@sirena.org.uk>
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2XR5MPVh7HFfE+/h"
Content-Disposition: inline
In-Reply-To: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off is
 read from hw
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2XR5MPVh7HFfE+/h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2014 at 01:37:41PM +0200, Javier Martinez Canillas wrote:
> The max77802 driver reads the default operating mode (opmode)
> set for regulators when enabled from the hardware registers.

Applied, thanks.

--2XR5MPVh7HFfE+/h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/hqQAAoJELSic+t+oim9L08P/1BAb07HR1SfaLyG+bh6zhxD
IW4nKLlkVQgn3jwYLk7oPTXjH3bTGAWwxWOmJfUj6+fixIDaOKJ1U0WfJDXOl1f7
DlWbnFBm1nb4YYG+56ccXXNAxHn02BZWi0rC+JbgzwDN5WxPtBksBTVcepg6+F15
+IQryNrpxIB+vurkxq5RpO0g6rrMNSPa9dBp1EpUZNCBZLEJSQE97qFDaf4T34tF
KrMm9Z3qO7vn+bJ/lrWDvePaTkZWVond9Jt106mI67Rk9t7QX5JAKjDpBPC5M+HX
JDjbHXpgU1i5n2mydQpeMgqaQ3/SSlM/T4bdTW19Kfxayd67ErAxD6m2UOcCr5l8
FJYr8E4TmfGN/Y9ZqU4ilIjdVLyal/Qeq5DFmDxYppspqX6ta5MEX3HlMpmunrFB
WJIzdTzNDnmuonHeu92R88HSH3k8DNkuLE85fLp1PjAVbkn6X91qngVZ3kKLAGud
qpJ5JUSr3D4/caC0iTZfgMfRiRVP1weTlsvwk4pGcWAz/rFUsythXQOZaMaXOhfR
UickhSNrTzs95Tx3v7vLmH+Woo9L5bzatKo1xK4RO7VA+snDP8xNBb9IoIUK1ZeP
KhcEIL2mi7nAcXPNmbILpF398LW7G+uFolJ+GhFg5WJeC6+fIhVs2rX9Erx2tXZ/
8sP3HpBa+jjJs7hmp29p
=Z36r
-----END PGP SIGNATURE-----

--2XR5MPVh7HFfE+/h--
