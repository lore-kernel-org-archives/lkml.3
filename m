Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3IOLSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 07:18:41 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53699 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3IOLSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 07:18:39 -0400
Date: Sun, 15 Sep 2013 13:17:32 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Milo Kim <milo.kim@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Message-ID: <20130915111730.GA9765@ulmo>
References: <1378949441-6073-1-git-send-email-milo.kim@ti.com>
 <20130912152809.GO11227@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20130912152809.GO11227@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 04:28:09PM +0100, Lee Jones wrote:
> > * Documentation
> >   From Thierry's suggestion, detailed driver description was moved to
> >   'Documentation/lp3943.txt'.
>=20
> Really? Why here? Do we really want 1000's of driver docs in /Documentati=
on?
>=20
> No other driver does this (intel gained from a glancing look).

Well, perhaps the top-level Documentation directory isn't optimal, but I
think it's a lot better than the commit description. Perhaps an 'mfd'
subdirectory could be created where documentation such as this could be
put.

Thierry

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNZdKAAoJEN0jrNd/PrOhOOoP/jyU0KhmBc2DLMHUsNyVwW5J
vXal5EKRPwHl/XjdS76/vfgH28htNFOups1PRph60Y/7uRj1ftBFqlXJkV99tbSy
Jq+LL/FFxpDgCJZg5ExzRLksFzc38107m6XbGQhe7Mct5pPehmrAN+fMMTd0SdFs
039IXajUh3oLlx4Oxr//EAhYXWy440yI0YTHbK90bWPjLy17IpzJkRYGQSRf3m6c
ar14icHYMiG2k326GYpEImtrH77DuNNVnvrRM5FJM7u01jsUL81E3qxulAlelAu+
khU+FXUmZCwSNyRMq/Mt0lHKPygXNGz7qj4M/oHo3bFo7B2WzoTc1uFA1w2t8Mse
CZZarCw5lcsPEBlcJdONReAaJLoo5c4cXJV3SaLsCDbjGlWzylu99Cm62wlQoHLl
XJwT+tv4tt+5tZzd2D1ZXWj1QJZrVthDc4WaTk5hXCKQtTnoaNO5GEYxjNPD7cWl
lhh9hmsSoQFuAgHJRi4JkpVyi6vb7vylTUKQPWK/kLTVARlPhW/GyCZltaUzfr5B
LhBmQnQ/Po+CTXuohQlDZXISsLb0UO4pMI6uwBwR54awI/MdKLryetYJuJ1G6ORB
SaF25kZI2yqDCc8TcXhN3JNjRy4A9oY34rpGWedbHQOFeX233BoVfdfd5V5JwS+g
5RlR7IGFM0PmuYO4prSW
=9x/B
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
