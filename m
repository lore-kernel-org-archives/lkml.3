Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaFZWJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:09:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60542 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaFZWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:08:59 -0400
Date: Thu, 26 Jun 2014 23:08:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net,
        shawn.guo@linaro.org, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Mark Rutland <Mark.Rutland@arm.com>
Message-ID: <20140626220823.GA23300@sirena.org.uk>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
 <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
 <53AB1CC1.4010907@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBYWXwvsCkEY5LOm"
Content-Disposition: inline
In-Reply-To: <53AB1CC1.4010907@codeaurora.org>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SBYWXwvsCkEY5LOm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 25, 2014 at 12:02:25PM -0700, Stephen Boyd wrote:

> I don't think this driver should be using regulator_get_optional() (Mark
> B. please correct me if I'm wrong). I doubt a supply is actually
> optional for CPUs, just some DTs aren't specifying them. In those cases,
> the regulator core will insert a dummy supply and the code will work
> without having to check for probe defer and error pointers.

Since the cpufreq driver is actively working with the regulator,
changing voltages and so on it's mostly OK, it's kind of on the border
of something that should do this but there doesn't seem to be a
reasonable way for it to handle not being able to read the voltage
cleanly.

--SBYWXwvsCkEY5LOm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrJnUAAoJELSic+t+oim92ToP/1adATu1Vz3pLnwXdvk2tjW+
elwWYdTUVwGzSM6shgqo8CxkbLyiqCNJgdHUUCXPEDvZDTyBDq9zmMVTyGKNY1o6
dbWma1DbTk98kB0DbfQsePSv0N8JyW/D7TSMZfFD+40wS7ZQ8Ue971gjiyY3xewJ
ascenpiRLyrbzgEZoBBbCJ9wXVlI5ZGqiR7y8Aj983iAFDOtj4OBBBTF+O5YC3it
L+0yNCVcJY6H0vyaJ2YuFqmZh0ojDJmryIZ7yC6nd4VE0nYk9b74vjj+NX92xE9V
P9CtufSXWXneD6yuYei2PE1HmfWnB9ZC973EgXdnI2ikq9ow9BuBjz2IF/qD2m93
QfcI2DDjN1fL6KoYW0rY3LFkfW9X7078wn6ZmaDCL361NFx1g8d8ZZMhtMNxte/A
LVLgzdgvB5u9Kxz1BwXgEzTLfSqLg6W2yEJOAyK6DNyrcNtOrqRTmigAeneIPbMu
8u94gSNcLqhDuw0Fr3ye88XoK/u9KYP5W6/UqBCieR6rEOXac8exVcnPBkOK2Xe3
tZpA8hRnHG88zOGGyAw2pF1pFzqQ19oEZ4qrlcYG8vOYIzZS0VmM86qVucbgH8I0
s7GBPV2ckfZgQ46k2uZ0AYFYXCFwG2mitYILzq/MqVFwsck6uMYDbB/suyIIF6H1
SyQlUF8RgDxlONuUtMM+
=MWWT
-----END PGP SIGNATURE-----

--SBYWXwvsCkEY5LOm--
