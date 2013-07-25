Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3GYOdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:33:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57401 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3GYOdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:33:38 -0400
Date: Thu, 25 Jul 2013 17:33:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <george.cherian@ti.com>
Subject: Re: [PATCH 02/16] usb: phy: phy-nop: add support for am335x PHY
Message-ID: <20130725143330.GK16106@radagast>
Reply-To: <balbi@ti.com>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qd/SZIFVu+MYwfCR"
Content-Disposition: inline
In-Reply-To: <1374516607-2705-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qd/SZIFVu+MYwfCR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 22, 2013 at 08:09:53PM +0200, Sebastian Andrzej Siewior wrote:
> The am335x PHY code is well hidden in multiple places. The glue layer
> uses the nop and does up/down in the background. This patch copies the
> power on / power off part out of dsps so it can be removed later in
> dsps. At this point I am not sure if it is better to write a new phy
> driver for am335x or just add the missing pieces to this one.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

right, I replied to the wrong series, please add a patch renaming file
and functions to phy-generic.c/usb_phy_gen_

or something similar.

--=20
balbi

--qd/SZIFVu+MYwfCR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8Tc5AAoJEIaOsuA1yqREUzcP/2ydCREn600qznnoBoqNztF2
lGL+YiQI69ntxSNlNAFnR2vmnOpCaNYb/OtDntbHhZ8Fbk8gTEBZycD+pBNaLWUS
EW3QvBfIe+1PfRNGdQb8K2m0sJwFr/aSrpOKmY0pQCU83Uuv2LLVUDmRZEByJL1u
QnyuJJu1wqTTPlz4gRjufz2EywRrY70BajXj7zWloyEhJFi/kv405sZBpiT6jayM
vC/xWQrP+5n4gVaepGfzDBkCA4r+hyt1q2X1dJm8MhPdO6nNYplwLZoNr2+rCCcf
ppckUGO/p8KQOTPxzlI8MIzjG69oEpMOO43qPN4j2Ou3hVy89ISb1G6T7x+beCgT
TwBY16U8/9XwAssfxi3J5UzAhiBFyIwIFc2WNTGHsuuxD5Of1OTyoXZZ0fEOJ3v0
YRyhqFW4/ixIqnDRgO83oGcydQZUQ+gJ08u4ny4LRPC0fY7olNfCCU7bRs4VRIFC
2GJRW6B04ou8cMf117RrC6Mtufwl2ZW82W0MaeMtwgNlCR8rgQS4YkeE1l3Zc/+5
GQ8mpp68qwaVti9zmVt6667Jjm+eAQSbv1bHpYS6QngL2ISP9nWl/5OR+XLRDpl7
v6ht3720znD9xejCwRkYoIDY1cBKHAqva+0v08TqWcKLsWdozKRa4O/z2RHcV/tv
t1W/fsRunjE4Lf2jUX5K
=OPdN
-----END PGP SIGNATURE-----

--qd/SZIFVu+MYwfCR--
