Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3BDJpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:45:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52523 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab3BDJpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:45:53 -0500
Date: Mon, 4 Feb 2013 17:45:49 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: zergmk2 <zergmk2@gmail.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Subject: Re: [PATCH v3 00/10] spi/pxa2xx: add Intel Lynxpoint SPI controller
 support
Message-ID: <20130204094548.GA4720@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACb1VKtD+pc5cAJAqBg82uCXH_icm9fk1yLB_UnwmEq4Lq-NVQ@mail.gmail.com>
 <20130201102247.GM869@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20130201102247.GM869@intel.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 01, 2013 at 12:22:47PM +0200, Mika Westerberg wrote:

> Mark, thank you for applying patches 1-4/10. Is there anything you want me
> to do for the rest of the patches in order to get those merged?

I stopped at patch 4 mostly because it's very large but also because you
said you were hoping for an ack from Linus.

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD4GgAAoJELSic+t+oim9xYQP/Aq7/qwoaF1NJPmycShsoNz0
hO35H9XXmzTlHalZ6ayxy8dIUx4zpu+3YPNJhh/6D75/VpxizZNCvHRp39tIJgBf
KEEJMKAX0JN+v9J3zmfxwCnISxRp1CgNq88C5smZ15JvV2LvfGs3P40x5hBZuSyX
6b+lLDFrGclo3Js4+fByFU3wUD6sQ6sub5GWBxHcA8z7jWQVEH4QjGmAP4CgYd5D
+wKbuBwsA4EreaKT5+W5jcpHir7kad1vbJs1w21N0LalryAadmeurz5Y+xfMhT7u
Xi7F/YCWItjmGJtVV5BxNudzH3xXH0wDZUv/MWjNRQ12yxYFmEecVhsRszDp2NEH
kCQbo8sGl+Zwjm43TmL1ngGx5p5rNbhRnLr+aVoqyRG7C5bfube6aUf1OeCycWaP
EJ5SYEgR+YfLfAl7YFq3gJiuNL07+M9JXa7V0FKjqDRcW57ctylU9tTUqzWLJt5f
EwxlRbPFl9PrzVer3SmEwNDzPugxrMq2c1zS06zcTwOkSVn1BPgkSU3Wsv0gvVqt
372940wi8YjJHdRUK6bPCp6GAyNDtMKfoDD5/w7V6o0w29D3D921RQt2KXndnibY
vvfmfvS0bgnWZXkT17spKkEDp2TpH6l6RfK1llwPdIKttfcoJn7arFtDG9zgkcJm
ebNo+YrpFS52Kc6Mq1mo
=bkg2
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
