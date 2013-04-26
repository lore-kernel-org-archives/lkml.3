Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab3DZKbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:31:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42864 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759189Ab3DZKbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:31:23 -0400
Date: Fri, 26 Apr 2013 11:31:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: hanumant <hanumant@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [RFC] pinctrl: Pin controller with different types of pins
Message-ID: <20130426103119.GW5019@opensource.wolfsonmicro.com>
References: <51771D78.5080101@codeaurora.org>
 <CACRpkdY2EHiaFTK26hoCwQ_TxgECohR2EAAmQESZYNvnx-mX9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y88ZgXPnK3pWvLGs"
Content-Disposition: inline
In-Reply-To: <CACRpkdY2EHiaFTK26hoCwQ_TxgECohR2EAAmQESZYNvnx-mX9A@mail.gmail.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y88ZgXPnK3pWvLGs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 26, 2013 at 12:11:49PM +0200, Linus Walleij wrote:

> OK seems normal. I guess you really mean "drive strength" as in
> "configurable mA output", because often the voltage (VCCQ) can
> be controlled as well.

> There is some overlap with regulators here, CC:ing Mark Brown
> for a second opinion.

Yeah, I think it's just drive strength.

--Y88ZgXPnK3pWvLGs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJReldwAAoJELSic+t+oim94GwP/iqBVRubJ94NUztTd/9CssVZ
c2rIi6mdiau5lxBzAb1tFCKDkJ5G0Af5GT13+2jdmRRWT7Qp3aGnyvzi9K0nV52K
l5P3tS2JFfvjOub4+rO5pgbc9AojhR0ktm4ti8t7ZdvhHxYw35xzd/YEbUk+b/AH
IA5PVuk3KwSzVnksjJWOVSC/q5KSkqw6BCu+H1WwzI7V1ZL14o+n0HhPmzj2+hTn
8UK1SAMuHfOkg+gkeTGQxyPEnLFtp8dCiVHPhHrVVBufGxqT7LUHXluwkPiQLy7H
TZEdT2uXeXWi7OzUMlTdvcaqNnxbRPVaywU6VsPUn1dMUB9fx/QHTu5rGZQE1NLg
dv9FwnjDaNKRuj7LIm40gnOQoCJnTjBqMI7V3xwo+g3cIP8RIfNPBiCgnOBeXg5G
519nO1sB+Erch3g/XxHgufeZbO6rKH0746cFzZSI0DGxIgufvK8vV3j0Klwmtzgj
65drNMYow/oOLy5YN4+mlqbutJf0Yr251ihMsVHTBgFWMKae0qIh3LO0JsXM6FgL
A9euR1igqnqX7sFwAbkby6mZCtZdxvuRj8S3takKdHepnPvjvF+QZDybUXrA0r3s
Aeyg5jYib1oL9LexiPG3HVu+ulurE3Orzk2rpmtWxMDSf+5mVq4IaQieFKZnadgm
pzY6vGJmaxf7wWL1dTVG
=0mcE
-----END PGP SIGNATURE-----

--Y88ZgXPnK3pWvLGs--
