Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3GYSAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:00:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51252 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab3GYSAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:00:35 -0400
Date: Thu, 25 Jul 2013 19:00:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20130725180014.GK9858@sirena.org.uk>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
 <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
 <20130725080443.GB3403@laptop>
 <20130725080800.GC3403@laptop>
 <1374773693.4382.17.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9uRI0oaS4VwOtskx"
Content-Disposition: inline
In-Reply-To: <1374773693.4382.17.camel@pizza.hi.pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mfd: Add Dialog DA9063 core driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9uRI0oaS4VwOtskx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 07:34:53PM +0200, Philipp Zabel wrote:

> Well, most of those lines consist of the register and bit(field)
> definitions and the assignment of those to regmap and regmap-irq.

> I could split this into (core+i2c) and (irq) parts if you insist.

You could probably put the register definitions into a separate patch
too.

--9uRI0oaS4VwOtskx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8WeqAAoJELSic+t+oim93YUP/Asr6YDAI2iqU/zFvZdhvoRg
8QgsPmpj5bFhP/5eFqk/HcIbFUdOyAo5F6hBNWmSRJGEqOWZNyZhqQ9+kLgfRcmm
zttAi53Sw/UtjxWA/aYEyUKLg6CvcgIA/VYY6H7A6BQB85HNY42UsW6gQPbmpiV+
DFshnO22Ja8BVl4dRwXCJ2JHbM4l4zqH/lQX5B06a99hn7Uub3IGQueq5FjW4jRs
ttoSSIrZk8ytcNM1KqaQiWCnJp/HgWLY/xAW9sXEW1GUdKhl6/1XtbaaRgoqEFGT
LPyw93Bu5JUOAIy21b4yulB+skOw60ZmnUo1agj9iAQtp8n9j5d9NEyjmSItPpu2
saSYWaCFB4310wuB5ceF808dz3lLgzOJc3SvR82p7x60iYldU/lCB/s8WkaJOaVM
Aw/Zzn4ooPHqyCXOB0GfmYJkJQkv/UFRvyuoGCyGgzFY91kCkTVun1MzgR1qmaBn
CxVNkAUe+OOTIQfFPCuOwSo3selJ//QW7rXkSaay0j66ITQ2WXXj56e/Ip1luYjN
bDqssZEpTA0rzKJCe51IGi0zUsvT9Zw2w2HTxSXm3f2xbSFOEijAtmMJ1DGjj6Cm
TNBUh41LvSTFYN+N0AiFGi05PVSb9DPm+yRqk0rRm7gyAG10suPRnzmjpg5pzy42
9qGVP+mlRX2oBjCu2Tut
=S38+
-----END PGP SIGNATURE-----

--9uRI0oaS4VwOtskx--
