Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaKIJTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:19:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53162 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaKIJTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:19:48 -0500
Date: Sun, 9 Nov 2014 09:19:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20141109091932.GJ2722@sirena.org.uk>
References: <1415448772-3895-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mFHiwr52TKrxpkjc"
Content-Disposition: inline
In-Reply-To: <1415448772-3895-1-git-send-email-badarkhe.manish@gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.253
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps65218: Remove '.owner' field
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mFHiwr52TKrxpkjc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 08, 2014 at 05:42:52PM +0530, Manish Badarkhe wrote:
> Remove '.owner' field of driver structure as it is
> going to be filled via "module_platform_driver" call.

Same question as ever with this stuff: if we've decided to do this why
are we doing it for a single driver and not as a genric cleanup?

--mFHiwr52TKrxpkjc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXzGfAAoJECTWi3JdVIfQzkcH/0i1D3QyNT9kflBRYJYOwMzY
ObYepZd+TQHG4meY7Kcl3yTa4airYuf1EeKceY0HkiwsMxgaPvccDExYAKrmbgM+
eC211nsf4aTkYjv/PelweSqnTZ30OO3nPJ1h3QaHxU6VCjlEpqvO9J5B2FNuVb9x
18B65Ln65wrrCkljy5EfsCs8CHUmoqB2NdioiIhihKI1KY4fyE+xEXz0D9DRO0ea
Qo4FZillUkZ2SboGHpKUF5gxiJR2zP06miSfWSmPcWLF1Nncamdzuwr7EiJgSo5s
PNMWN6iXcPb9fppZRsDjPioUiIrXLLpFJFNfZhRxljpKT9lK3kC9MUKMvsKdIjs=
=Yo0N
-----END PGP SIGNATURE-----

--mFHiwr52TKrxpkjc--
