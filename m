Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaE1Rti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:49:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45792 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaE1Rtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:49:36 -0400
Date: Wed, 28 May 2014 18:49:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Dimitar Penev <dpenev@gmail.com>
Cc: linux-sunxi@googlegroups.com,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org
Message-ID: <20140528174909.GH5099@sirena.org.uk>
References: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140527194932.GD12304@sirena.org.uk>
 <9ed19670-7a2e-4324-a201-6d3c8514bdb3@googlegroups.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Content-Disposition: inline
In-Reply-To: <9ed19670-7a2e-4324-a201-6d3c8514bdb3@googlegroups.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/6] mfd: axp20x: add AXP221 PMIC support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 09:00:17AM -0700, Dimitar Penev wrote:
> Hi Mark,

Don't top post and if you are addressing someone please put them in the
To: rather than Ccs - I very nearly just deleted this since it's a MFD
mail not directly addressed to me.

> I plan to use AXP221 on A20 based system as I require more switchers than=
=20
> the recommended AXP209 has.
> Do you see any obstacles which I may be missing now?

I'm afraid I don't really understand your question, sorry.

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThiGSAAoJELSic+t+oim9gksQAI+TMJ+pTT7LoHKd9H8WE4XE
35CbYrOcuPMmpdDIJS0MLu2fkP1gJWxuTyRkgSeQW94yuZv6P3aBjzXjujcwySej
D7JvH80AtALGlvZ2yrJfo5OPtkS3mAICuCWtGgCb4hkPmStosg+xuVYDhy3M/VKL
gbsAl55YnVenrWCGi6VOI/2z/0mIxIwhoFqfUCkzmdRDjvo3f1rr2RN3MJNxY2OA
DjOAI7yoEMhx4dwJWtz4agywlgkf4VYxWBo1ti5MtusZAodaai4RjMYOrfrD5M/Z
0rZ/ecglYRPwyuf9CHm/tgwB6Yknl60EZvVd2kPdD+IzfsWZm324qTXk3GWwc2Wn
Tl74msnKxJk+YM34Fm8AijwkdkRSKVqtZIjTWUe+AoL5PxMIry7ucpVB0vFwL78R
cXeQUtyYPPs64r4ckRhJr2E4dEJ4wZzImeJYomxI7QeqFRN0sjRhA2C1uRCsJRTx
p80ZQEa7OgjtkXzg07VqGrNLXOkRup1+62a/DejoStPUPRRx1xGSresFYJA2Elk8
a3qEv08v8GaMjMpspHVH95N7VIZUOKq9K7iJlJ/sHCAPMDMZuXyZfcSesI7Z8AKM
XaKPay40VoBvsdKm0YU8Sbhg0sXi+ZpAvqSLpaut7AQCnXV83roHvXPkFPpDwp2U
8dZQs5SEE6l+F13zVYwB
=ls0h
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
