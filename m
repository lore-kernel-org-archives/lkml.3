Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3FFJtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:49:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38120 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3FFJtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:49:00 -0400
Date: Thu, 6 Jun 2013 10:48:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606094822.GB1883@sirena.org.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
 <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com>
 <51AF8730.4010507@itdev.co.uk>
 <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
 <51AFA02B.3000604@itdev.co.uk>
 <20130605210715.GA16013@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <20130605210715.GA16013@core.coreip.homeip.net>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2013 at 02:07:15PM -0700, Dmitry Torokhov wrote:
> On Wed, Jun 05, 2013 at 09:31:39PM +0100, Nick Dyer wrote:

> > It's partly path dependence - it was implemented like this because regmap
> > wasn't in mainline at the point when I wrote it. Having a dependency on
> > regmap would now be a API break complicating support of customers using
> > older kernels than mainline. I would also have to update a bunch of

> This was never a good argument for introducing an interface into the
> kernel.

Indeed, and regmap is very easy to backport - it demands little from the
rest of the kernel and most of that is bus specific so you can pretty
much just copy it into an older kernel.

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsFrjAAoJELSic+t+oim9F9oP/jAxnQX8zJvdJ+YOTClPv+WM
rBgjKPogtuTTHvil5j8HB3adoHG3XhXLteredrZl3FxhyxFaoHwUxN7OPSW1ZOsc
MMzTUgQHJEjnioWWGuvlZ3v9+Jei5f2wnUg0K8tYb5TbM5nsrrFRH0GajK1pH3NZ
Gc52aHlshB6L3j57z/dQsBHJdqyHKkYsrmu/2YoSZeXXE2P0hQjOl9oaEb3b00+E
3zYnA1dhD29+C8pbisfEzZcaQSMDAK5aGfN01+/PyyGmTDHH6B6s99YeojLaYMoi
xcFMACUjhC8bxo4j6fcsPy+Da5oUw6acm+eI8+t6w0TSDXDWJ66GHi8y7VDzD7dE
JN28xPBDW9rngTNXDaxgiH4EnWH1JDEnPZXAy2PS6z/tER75qo9aTX604XGk0EPc
z8q3gaa6XCHrnXa1GjBfeHpX3I4Yq21WT0hE7NXxyw7ju2OsbdwFgJmXSggM/jpL
2FzQj4tL7WoKppLsCsLnYE1B7XukJ7YtvLFHF1WFtmZlWsCVm2mbwt7jRNYpBOAS
rBjhgoO7IaBUNoUgwzP9edVYTphlUC+HvcDjpdFUGAoiFrsfsfR+x/iBHXdtUzgw
msPAjXn0HLpsv3zICIMwxjhEOsvpt7lDs2UxDPHIEBVQCualSKi6VWAf4UGh9ca/
dmc/TFt3ZzXjnfv8gl9P
=HIyt
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
