Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaIFMzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 08:55:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53267 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIFMy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 08:54:58 -0400
Date: Sat, 6 Sep 2014 13:54:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linaro-kernel@lists.linaro.org, Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140906125448.GB32429@sirena.org.uk>
References: <1406480224-24628-1-git-send-email-broonie@kernel.org>
 <20140817165736.GD12769@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <20140817165736.GD12769@titan.lakedaemon.net>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] irqchip: gic-v3: Only define gic_peek_irq() when
 building SMP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 17, 2014 at 12:57:36PM -0400, Jason Cooper wrote:
> On Sun, Jul 27, 2014 at 05:57:04PM +0100, Mark Brown wrote:
> > From: Mark Brown <broonie@linaro.org>

> > If building with CONFIG_SMP disbled (for example, with allnoconfig) then
> > GCC complains that the static function gic_peek_irq() is defined but not
> > used since the only reference is in the SMP initialisation code. Fix this
> > by moving the function definition inside the ifdef.

> Applied to irqchip/urgent with Mark's Ack.

This also appears to have disappeared from -next and again the warning
is back.

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUCwQYAAoJECTWi3JdVIfQTikH/38Jj+8ZbNTz+6TUopNUPfJU
RO49e/L8u0aRPVhOBJCXKH2DW9HRn7Dk/r/aWg0WJC/FJp3b38URwlEegGPNuGxG
7UNF6AqlI98D3yKpOSbguA60KliTJdBBoUxEtB11wZJjRSWVFN/lhdl70TfPc8A+
lEy6p1rBOqxYJeSfduK5Qo7EMArMNbsPLXKwPNwEubS8cFZRu/kM6JqWfA37Wvma
vEmX7jWFlP+MvM76BAaNXrNBi9/Zm9fDzFFD0rw7qVMUVDAdNOKvHaSgjePS2iPw
MSU+YlxKCH3OO/ZiyAwYgOqMeYhWATVydGs9d9lucaEVPzWMdrwOl1CDEpdrfWc=
=tMF6
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
