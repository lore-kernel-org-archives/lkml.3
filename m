Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaKYVE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:04:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38527 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaKYVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:04:57 -0500
Date: Tue, 25 Nov 2014 21:02:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Weike Chen <alvin.chen@intel.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Raymond Tan <raymond.tan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Message-ID: <20141125210222.GO7712@sirena.org.uk>
References: <1412000548-9908-1-git-send-email-alvin.chen@intel.com>
 <1412000548-9908-3-git-send-email-alvin.chen@intel.com>
 <CAOesGMi5f_Kc1xA_JqiZYsbVYxaJgBXMZCe5TAxDkPQj7=o8sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jQ+AERLI8tlfAZXA"
Content-Disposition: inline
In-Reply-To: <CAOesGMi5f_Kc1xA_JqiZYsbVYxaJgBXMZCe5TAxDkPQj7=o8sg@mail.gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2 v2] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jQ+AERLI8tlfAZXA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 12:06:41PM -0800, Olof Johansson wrote:
> On Mon, Sep 29, 2014 at 7:22 AM, Weike Chen <alvin.chen@intel.com> wrote:

> > This piece of work is derived from Dan O'Donovan's initial work for Intel Quark
> > X1000 SPI enabling.

> How about build testing for other platforms that share this driver
> when you make changes to it? This is obviously completely broken.

> Doing these constants under ifdef seems fragile at best, braindead at
> worst. Please don't proliferate that coding style.

> Mark, can you revert until Intel learns how to play well with others?

Yeah.

> This is from a pxa3xx-defconfig build:

Ugh, why does this driver not have a COMPILE_TEST dependency?  Not that
it'd have caught this one.

--jQ+AERLI8tlfAZXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdO5eAAoJECTWi3JdVIfQuO0H/iD7FfmC6mQk9p74nBoLFNW5
xjYCDkdQ6JKQQjj9CaKBbAaysU6co5fJGgutMgPKj4IKqWNE1RuvEYSsaPnq3D+M
JnDzXBF+x29hoc/xHcrURjxJK6zRvZdSb31gypq4ovoeE/ojaYVdpZxDRSegozSZ
x8yIdfi0v7ra7v0c2UODyWvXPbhsQ+L6zqpZtPKkbG1+8WXDYsNh9YGXX3gpCscj
5r4mR+tOt+VRAPa7iLSSuI4v2x8rDzUM+h3OX8OeX/FsRkHe/9xdQN8aDIrgyr9e
BHSIwWEkMaFhsKfWn3j/0QwywqiVE7ZJPZzSLVFGAzO6qQHHu7TL1znkPzIzNqs=
=BpI+
-----END PGP SIGNATURE-----

--jQ+AERLI8tlfAZXA--
