Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3AZHbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 02:31:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60101 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab3AZHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 02:31:29 -0500
Date: Sat, 26 Jan 2013 15:31:22 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] regulators/db8500: Fix compile failure for
 drivers/regulator/dbx500-prcmu.c
Message-ID: <20130126073121.GO10580@opensource.wolfsonmicro.com>
References: <1359041366.21576.146.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nRwNdQxTdQ7rZk9A"
Content-Disposition: inline
In-Reply-To: <1359041366.21576.146.camel@gandalf.local.home>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nRwNdQxTdQ7rZk9A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 24, 2013 at 10:29:26AM -0500, Steven Rostedt wrote:
> Building for the snowball board, I ran into this compile failure:

Applied, thanks.  Please use subject lines appropriate for the subsystem
(I see I let the original one through).

--nRwNdQxTdQ7rZk9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA4Y+AAoJELSic+t+oim9hncP/iSMgHddRytv5WNSnU6X3KPy
VXxmt0R1/v/teOpF6GVXiJKNOrRQY4rLI/wCgpsm5kDtrStdKXDyA7aOzrUp+FEX
2418tnwZJOtJrlJJCnYAd7HyZ0fKeJPX35seEvH/BRtFfHNUanXtwV3I/QpP6Fqm
aFkRY8PjBm0Rx/ERHRgYmUFrx+fne5mziPkqN2PI3OJ8Y/3EuiQN2GB8bDBKSP50
aaA19Qs78ojCn5UuClbu4ZWZ1VuFMaX34wLF3gIWzPaEnml8NbvEHI2S4d2ih5uq
tQMkIX/rjU5TQ0Y2Qt8PDXzhhxb42VD64UCTKAxVEkwVzd+MqG/+STOuFe6wu+CY
/wVVKO54mPHWb4Mw3eL2JUwNjQx6hp0WCcOVdlzkwXkTzKTUXI4YizXcldz9/tSs
ALBUwALcOV83sRKtTuYS2Br+L3sZnVxE9gdVqW7Khp92bVqysmqL9oKo+6+4ibhp
qatKHoQfdc56ASQJlL9JAB3uNxeNG+gIMqKRVTst/MmJnbBKnuof8g/yZnEgnSwo
jPAPfwW8LzxkxqWvh42jkgkTwuQRb08PCcr+PukVi7j3Z7lVjix5Vq7I8omRaE9U
6zkfDsIPlPxJuQpSmL0k+DThu++kZsZHTv+mmaTGYElhKfOT+K8O8bzNEPjlaEi8
Xdz+F+1g6RMyD+AsWSl2
=jh9c
-----END PGP SIGNATURE-----

--nRwNdQxTdQ7rZk9A--
