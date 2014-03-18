Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbaCRShG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:37:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45328 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCRShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:37:04 -0400
Date: Tue, 18 Mar 2014 18:36:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140318183645.GM11706@sirena.org.uk>
References: <1393044798.15653.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wFsmFZmaatp/x6ak"
Content-Disposition: inline
In-Reply-To: <1393044798.15653.1.camel@phoenix>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] regulator: anatop: Remove checking control_reg in
 [set|get]_voltage_sel
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wFsmFZmaatp/x6ak
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 22, 2014 at 12:53:18PM +0800, Axel Lin wrote:
> Remove checking control_reg in [set|get]_voltage_sel and then convert to use
> regulator_[set|get]_voltage_sel_regmap for [set|get]_voltage_sel callbacks.

Applied, thanks - if there's a problem I guess doing this will shake it
out!

--wFsmFZmaatp/x6ak
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKJI5AAoJELSic+t+oim9XCIP/RaETrgOEnU44AELMV7HgpDI
1gUSe8ss/Yq44WE0BQVr0o9W69fcHf4SYhRRtT+X4HpQ/GWt2spz2jtfmQxOYMIp
yMCtgTLR8w6BLXe77I7wqL4ykXAYRi/HGkFGGbVZoiJpLIqWwbNBDBhGm4WnpHPA
i4z/BD2lFRD7reWpakarxGzTXMD9wuBwx3KgGM+CjT/DoKtWoKnXGWC3JCHpHv09
2Y5ylm/hYEsenmVuQwxjuGnWNy6g/XnZ465A9uc+F7gKcZo9NMln1Dg5AKTy9Obi
NghTzsAIi27xIIh7gmVfRmaNSe68AYFHN09+nkTJo2sVfWNULftM47AjLCFpAxq4
x3Zn1QSTVdHIxZ3O0y7uoqIHW5JoyJY91ZjXFxCnQQUbKCjCLkz354e8qqD58hke
3cEpHHvXQcPnmy+ZbkSH0aBjNStZDdtTzV5WN1VkMM9dXkJWUUP18z/3IqK8aAyE
LeD5PfB5PL9RO4XoJmKLva1BwzZPhaIGo4V7jjgyIVJLo2jiXI7ukpActfE6JCZ2
juu/aXwd2V+w4o1fIKIAQB26b5Pn5CEypINrbjzEJm0dkx06ZKq6c9Rx3RQY/zui
lbFa8XnJfmpXZsUo8ybmYg/YyH2p0XNo04GgQPyc3oGfGyBypu5M+ffoqA24sQDU
o14rdYKBkgO8BT2q2P+U
=oOdC
-----END PGP SIGNATURE-----

--wFsmFZmaatp/x6ak--
