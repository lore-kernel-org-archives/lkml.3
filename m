Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaETWSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 18:18:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34813 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaETWSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 18:18:12 -0400
Date: Tue, 20 May 2014 23:17:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Message-ID: <20140520221758.GH12304@sirena.org.uk>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-3-git-send-email-mporter@linaro.org>
 <20140428115627.GY21279@lee--X1>
 <20140428140910.GB7719@beef>
 <20140520161131.GB32025@lee--X1>
 <20140520190055.GQ12304@sirena.org.uk>
 <20140520202923.GT32082@beef>
 <20140520214439.GS12304@sirena.org.uk>
 <20140520215726.GU32082@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rl31vBGKDBpRqJCj"
Content-Disposition: inline
In-Reply-To: <20140520215726.GU32082@beef>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/4] mfd: bcm590xx: add support for secondary I2C
 slave address
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rl31vBGKDBpRqJCj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 05:57:26PM -0400, Matt Porter wrote:
> On Tue, May 20, 2014 at 10:44:39PM +0100, Mark Brown wrote:

> > I looked at that but it seems I already acked the regulator part of the
> > series and nothing else looked immediately relevant?

> The series has cross dependencies (shared header include) and thus needs
> to have both the mfd and regulator portions merged together. You had
> mentioned in the v1 version that you'd like to take it through the
> regulator tree and so Lee's comments earlier were with regard to you
> taking the mfd portions.

Right, OK - because it depends on the earlier MFD patches (I think?) I
was expecting it to be applied in MFD and merged over to regulator.

--Rl31vBGKDBpRqJCj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTe9SSAAoJELSic+t+oim9QOIP/16xpmlilX1hQbrOrr75vRYK
SkMn8naEAWOn/gphQvLAatKSiAEbpZa0ITzknU3tjszoMNpCxZmiwzP79acJDmJQ
tfD55V279M11FrBLGHkkmkBTaahFclPG16dD3GmdOXPjBya1EOCnAmml3XSnEwF5
i56ZcC+UrCif9dQ64Km86+U95P7DvjVeuh9AaE3ScztzKTroguOmqoIbrVixdcCl
sS6RmaNnXam0aXjiAoyN6kTuFdTk5tAo0u7Gf1ej4CSalKJnwySr5ejcEAYHACkN
aTdHVM6tbnTffWp8bL1VwFc3QyLp3+QKnU7nrRtGPnTHItYCNduGK+IEo9cuMITe
GyEcdfrJ4Z+N7TgHEfbT+H3iC9X59rPgQKz9LBi86gfsnYmeUkGYwDK97HFOXGEv
B9ITG8rbY4xriYtS6FK0em04ylGfaMRGhEZX9eKT3DCSa0OLUdNBUOX3lDCJgMjB
EgwNQ2kVtE7/FtNzHQjak5kB933g3YHCWfgNRB6jqjq3astg/JtGX/yzqGW99uK9
Tumz1a3gBDaDOWpCpxQmjraXdKAAgDsAM2R7DymaFPkE0BDlFaJ2blw6vbNBz90b
8XLLdukw6zYds01xE+R7yMQDG5EHmz0wvb/O/+xEuRd9zKKnUDG76mW3qGGEVVRO
8Q+kUiNRm2WRNOvLtuxP
=Cjmu
-----END PGP SIGNATURE-----

--Rl31vBGKDBpRqJCj--
