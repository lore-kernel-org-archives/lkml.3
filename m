Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3LMIm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:42:26 -0500
Received: from sauhun.de ([89.238.76.85]:41840 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab3LMImW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:42:22 -0500
Date: Fri, 13 Dec 2013 09:42:20 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.13
Message-ID: <20131213084215.GA3324@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here are two simple but wanted fixes for the i2c subsystem. Please pull.

Thanks,

   Wolfram


The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to e5bf216a945e7292f8718276372d2b41486bed26:

  i2c: imx: Check the return value from clk_prepare_enable() (2013-12-12 22:48:22 +0100)

----------------------------------------------------------------
Elie De Brauwer (1):
      i2c: mux: Inherit retry count and timeout from parent for muxed bus

Fabio Estevam (1):
      i2c: imx: Check the return value from clk_prepare_enable()

 drivers/i2c/busses/i2c-imx.c | 4 +++-
 drivers/i2c/i2c-mux.c        | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSqshnAAoJEBQN5MwUoCm2qlEP/2cIRPoetMQSLeWQTH6rY8+V
ggiYGKyUa57KZOx8Xn/0V3lGSr7CLbkmF7LSioY0pte/qAUXVxugReJCxmhFr39v
+FhufJ0EKHxtHY9w1HTWaEjongGyaun3OtdfrIgBscvUMNsuJwpjsRiaWIXwurlO
2zKHNvEf0t5NfNkEySGgyRfq2Vmc2iuoXzVIneXaUQWgG2bDpu5ohfmmvw1OG+YH
du97cU2/ZWe/3aObaI/I15RqWBQyAXSsFcBOXstGmP+hMqKuNt0l5xaTme0sXouS
kcMfwHSuVg+ztcLq8Yp25hm3U9mW0iw01KiI4Tmuz8AhA8cgj6A+SDqZl+7EbQu6
P3SgO93J2KWhan3n/14RZ5n0CFqCdusxiju8Qpie3hVXr7DyPWLrzNz3W89SPjQu
S5EPPCJK2vrcWZVflco4ckFmOaMu2UT1hta7YrkX4naxloXXxwOwrGidRpK9j7pt
8XSaLNHTtL7LdoX4dyDDEx9fgeiLMCNUxhL+BrSWFW5/y5j272jj0PWuCcugqwLA
OeP+Gw5NQ/17H57wAw3ie6km+mZ8KFbg1W6QZxN+QVr8Cp7WP+oJ8xgJOOkAYNcK
cUFikbIQaJAkBUDNGUhqR1puAe8gvjXVLROEiPSUq/XovGir5b5oWowHMHVuxzJc
Cq4eKbvrFeSqsKjCeE4C
=Zwor
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
