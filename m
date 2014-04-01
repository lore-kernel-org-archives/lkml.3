Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaDAMij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:38:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49911 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAMii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:38:38 -0400
Date: Tue, 1 Apr 2014 13:38:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux@roeck-us.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140401123822.GW2269@sirena.org.uk>
References: <1396247611-22289-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wGE1Wqqn9IXiFm4H"
Content-Disposition: inline
In-Reply-To: <1396247611-22289-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: mmio: Fix the bug of 'offset' value parsing.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wGE1Wqqn9IXiFm4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 31, 2014 at 02:33:31PM +0800, Xiubo Li wrote:
> 'offset = *(u32 *)reg;', this will be okey for 32/64-bit register, but
> for 8/16-bit register, the 'offset' value will overflow.

This doesn't apply against regmap-v3.15, please check and resend.

> The core trace:
> ===============
> Unable to handle kernel paging request at virtual address ffbd0000
> pgd = 871e8000
> [ffbd0000] *pgd=00000000
> Internal error: Oops: 805 [#1] ARM
> Modules linked in:
> CPU: 0 PID: 1004 Comm: sh Not tainted 3.14.0-rc6+ #990
> task: 871baa40 ti: 87090000 task.ti: 87090000

Don't paste entire backtraces into commit messages, they're enormous and
most of the detail isn't useful making it easy to miss relevant
information - either pick relevant sections or just describe the
failure.

--wGE1Wqqn9IXiFm4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOrM7AAoJELSic+t+oim9mdUP/36N8SKF3qPevdpkbyeuIREx
geci1T4+DjZEKn7GvNXlHJ6nsDfrnfmDgBWP8zKUlBw4lpJuSxM04MPXM59jE1Q5
8XzyIPVP6GbyeXsrCCWLzNjy1JhidTh2wMmvi08CV+zSbAU9VYFZ54j0vuCCfM9C
X8z9TViIJlnmaoncXbcetcAdPMBgObPT47B1nFoJnBz1KX0+CrPutP2Y4AOcETK6
xewhMh8QttxGMtlbUPU711fIU2MZBgsBD04Y/40FoqIi5GQUTgOrqfNANa0ltsf/
TIKo/+9ux0T7uzFWvRAx9TxneZ1nB4ojYn3FKfUCkBcIFinn/kCpKUm9+/gO5r9D
nwXdT9sRvGeKRtMJQXNB2Lq7ZKLvgB/FvMPlkFueeK7wTpWHa3fJdFWzTtj4Ek23
MuNMHnq/8+iIOzRTo90kPEZUWN7jw2gGada5dtmKpdsENcA9C27O1GUlqjuO7BNN
8wmvxeZaM5Tv8ye6OYTeWSGJS52bzjn85qHxN5e6zvFdsIeO7cUbymGQfgY45iJS
axFEovO704nyQQXcQttRBOkItrNoa9wGYAEZHWPbMQrj5Xe5IFVsUJY3uEGZtZOD
FZfpGfUB4W/qq+jvznJNLP+QJPZRpwJgQCHSpq9k03b5GMQbXHoZPxgAJETYQ721
TrxNBULY7r9hbpckhBtO
=7oRG
-----END PGP SIGNATURE-----

--wGE1Wqqn9IXiFm4H--
