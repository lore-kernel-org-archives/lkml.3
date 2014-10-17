Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaJQN5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:57:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33323 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaJQN5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:57:32 -0400
Date: Fri, 17 Oct 2014 15:57:16 +0200
From: Mark Brown <broonie@kernel.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20141017135716.GS1820@sirena.org.uk>
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
 <7hk33yhms4.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U7F658e60E1K4csu"
Content-Disposition: inline
In-Reply-To: <7hk33yhms4.fsf@deeprootsystems.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/atmel: add support for runtime PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U7F658e60E1K4csu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 17, 2014 at 06:02:35AM -0700, Kevin Hilman wrote:
> Wenyou Yang <wenyou.yang@atmel.com> writes:

> > +	if (!pm_runtime_suspended(dev)) {
> > +		clk_disable_unprepare(as->clk);
> > +		pinctrl_pm_select_sleep_state(dev);
> > +	}

> a.k.a. pm_runtime_put_sync() since the ->runtime_suspend() callback does
> the same thing.

Will that do the right thing when runtime PM is disabled in Kconfig?

--U7F658e60E1K4csu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQSA8AAoJECTWi3JdVIfQ4hgIAIRkPMBs9XhakV8+58tgax0e
Ror4gskn0x8g0OPdHaK/aQ05Eg3/2Vm0ZT0CH7aCS2FASA+uy5n3uyKnWWY936xV
WY5iBpwSkqCDkfvonQ5EMa3hoZe8gXSPgn0NZ2n5QKaUSXMBTaMGtGn0jnAZMmJU
QCSn1qZhErRJAd4Wdl1g3Y4YAqC8ijilmNz5fj/RfL/rUSljCPl++wHOTgX/DRWb
7Dw/P93nVrqGDnMCY4ZUrk+0wIeuHbcVyDth9hIr0oSvV023AWm99pbioh35kgX7
+Q7OrE3XLKSICkHpJgNtRBrhCV0BERLZXoXtRlKYyGYcIAeRhRa3U64U5UK3cSI=
=OciW
-----END PGP SIGNATURE-----

--U7F658e60E1K4csu--
