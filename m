Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaJGQUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:20:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38884 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaJGQUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:20:13 -0400
Date: Tue, 7 Oct 2014 17:19:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20141007161933.GH4609@sirena.org.uk>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-2-git-send-email-mpa@pengutronix.de>
 <20141007115335.GW4609@sirena.org.uk>
 <20141007130320.GF5042@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Shs6nLsUBL77Lfu"
Content-Disposition: inline
In-Reply-To: <20141007130320.GF5042@pengutronix.de>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: Add ena_gpio_valid config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3Shs6nLsUBL77Lfu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 07, 2014 at 03:03:20PM +0200, Markus Pargmann wrote:
> On Tue, Oct 07, 2014 at 12:53:35PM +0100, Mark Brown wrote:

> > This should be part of the patch adding meaningful behaviour for the
> > flag, it's pointless separately.

> I tried to keep the series bisectable while having different patches for
> the drivers and the core. By splitting this 'ena_gpio_valid' field into
> a seperate patch, the rest of the drivers will still compile and work
> until the core condition was changed to ena_gpio_valid.

> But I can squash the three patches into one.

No, I think this is missing the point a bit - if we need to introduce
this such that all drivers are instantly buggy without an update that's
probably an indication that we're introducing compatibility problems.

--3Shs6nLsUBL77Lfu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNBKVAAoJECTWi3JdVIfQbo4H/RK2DLpZNkwsJoQxTcD8zBZu
EY9IrM/RL7jObSY6CuhEXhrJntGzV2FyfvG8ysAHimejyc/CpL+1P7e2luqAJ/Ll
zWSE0knVg63XnjTFUfJCSqKb7BMkGuP40J7td0fIl8YTVt/P/keF3o1E8GqrnBVq
Wr2ekOeyq5kHqOta0vLA2YXYXq2p8/WwR/OZzJ0Yg/lhBhhHu16MIxeZ94xSkSdb
s477UMYHy5WZ5mAf3kelZ3jQA2eslFAz+TDcCnd/UW5rV44J4+ZD8ynSr3PPcEOz
5UFqodnLmhm5nnvLDZ0eyETIonFm2zuxfZbGxKWrtHJdbP4IK7QhjDIm6gHHFLg=
=LaTt
-----END PGP SIGNATURE-----

--3Shs6nLsUBL77Lfu--
