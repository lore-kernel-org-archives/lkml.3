Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab3EVQDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:03:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54953 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3EVQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:03:16 -0400
Date: Wed, 22 May 2013 11:03:09 -0500
From: Mark Brown <broonie@kernel.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Axel Lin'" <axel.lin@ingics.com>
Message-ID: <20130522160309.GM1627@sirena.org.uk>
References: <007601ce56a8$97232380$c5696a80$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+8GP5RjC/E7LQ/F"
Content-Disposition: inline
In-Reply-To: <007601ce56a8$97232380$c5696a80$%choi@samsung.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3.9-stable]  regulator: mc13892: Fix
 MC13892_SWITCHERS0_SWxHI bit in set_voltage_sel
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+8GP5RjC/E7LQ/F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 22, 2013 at 01:55:32PM +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

It doesn't seem particularly urgent (it wasn't new code) and we've not
seen any feedback from anyone who actually uses the device.

--k+8GP5RjC/E7LQ/F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnOw6AAoJELSic+t+oim9BiAQAJOAbTvG/ZHX87UUUW1LLeuS
GbbSqCNHeFj1nFNy8MtCQio4ULZmfUyu8KbOSSYzmnOCySr/vdMW7vKgkQwuBqvy
emFuxrZjFueg4TKc4D7YyWfj+YMT1zlRJulLplIsPamqwp0iTo5PHGlBcTXt1ef4
6YZT/i4AcyUeGE/i6h3AQz0oWb/pcRzmBf0s7UnC5A1Aaoa7IzMpuq2B6DZZICc8
Ol/O5tzcPeR1BhAJEXLDGTmH6Iy37fp7UL13KT2GYxvuN4F3iNrc4BLgrbdV4p8O
oueJKOUeyI3Xkh/kJFtVE9GhbPVS+d6SUevPPUiw3inhgu1yE6qngQtMknsKapSO
WTJ9IhvWAWM539BNWU4rxv9uql88eBo/TD4yJGCuFaHEY81aYkcwDUBPvfWoVvzm
Wt2yDzqEEVw8VQ1H9e/+6+Xbd0PmtRpJQRYVQB3MoWcZLcDB2iFZreCDIL8qBily
ZAEKr57E48aJrZDCH3m/44HPUeLyE4LM740Q7w+Bl/uMW7oo56n+SMoNdNfKlsPw
AvzRx07yqAMUhPszqN1On/ZzVfryf/wsB8Q3t59FGKHvHSUyjm8/2pmqXFU4aY1t
ylH0fogf2Jr9+x4WIDpHZkDasUSRVl2uIpiPTfIgit8tMfHsMp0n8lQnYozvv5W4
eo0+EIwA1XDTnep7/jqm
=y7BK
-----END PGP SIGNATURE-----

--k+8GP5RjC/E7LQ/F--
