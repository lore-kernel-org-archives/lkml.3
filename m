Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3G3KVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:21:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48377 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3G3KVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:21:36 -0400
Date: Tue, 30 Jul 2013 11:21:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: Axel Lin <axel.lin@ingics.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130730102110.GK9858@sirena.org.uk>
References: <1375152388.4265.1.camel@phoenix>
 <20130730032310.GC1430@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8eIslA+Uj+SZ7jYk"
Content-Disposition: inline
In-Reply-To: <20130730032310.GC1430@Robin-OptiPlex-780>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: pfuze100: Fix n_voltages setting for
 SW2~SW4 with high bit set
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8eIslA+Uj+SZ7jYk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 11:23:11AM +0800, Robin Gong wrote:
> Ok for me.

For Linux kernel process you should say

   Acked-by: Robin Gong <b38343@freescale.com>

or

   Reviewed-by: Robin Gong <b38343@freescale.com>

to say if you are OK - the first means you didn't really review but it
looks OK, the second means you did a proper review.

--8eIslA+Uj+SZ7jYk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR95OTAAoJELSic+t+oim90tMP/jXbXWSrKaVgQJ6q/g16Y65G
PnuyJx6eRv4o+ilPq9RXiVoxlWEK8SQINrt1BpePC2qJEakAUPMOCWbYV8HT0Uyd
WbYYgWoQQpQGij2AlruyKS5S1ID6MkOyhbDe1D9DW6SbOkKuNhqSpc2hfOJVYbwj
tkL+gZiLr3kPPj2DwuZte+0yZRA7J/tYFXiyTzlnu1/HiAIsoRrechLNmvCd5IWl
MEER0rLRRa81Q48esLgmvOsPOi3OUOq9DtTSFFwnGHJt7LRl9Ff3Ov4eM7sGzSpl
RU/4UIcKXVISpbZ5D+GREy+1RKdTCDJUH8B4Fiaw9lTWkf5P/9JdzhIKLNSjqQfa
vppGOcUJ8m2YAPCQ3r9HrJlMKLGl8EmYF5QGRKpoSjBWV+otYZ8K8JJmC3j3SH13
Bwq4a9USCRgLGaL74PO5RCGzoSsENJDtu3vtDfgoNoouGyzwKIwTimBLMABrl0L8
x916fHoqRQ2J9CjQuOvrYLosUB1l/lDUZ6vbAjprmlC/CX6R8fGd/gF07wKgA2cv
YgKiqMiH3lIRvgGTLtqKjSs7MImonPPm3tn/9juoygs2EHti4a5E81f4EvyrnDpS
XiLxraVuo/xSoLlUuRIZe+8ZRwFg3cl7D/yDpWUDfwAWH8XsioQTg20xazQ5vkiY
yWndj4Jl4ZQpwzsIaB8k
=11R0
-----END PGP SIGNATURE-----

--8eIslA+Uj+SZ7jYk--
