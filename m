Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbaFCPte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:49:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52179 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaFCPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:49:32 -0400
Date: Tue, 3 Jun 2014 16:48:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140603154854.GG31751@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
 <20140603145347.GE31751@sirena.org.uk>
 <CAKohpo=VLCf2nz1WsL-iGw6BWwpmqZ+8JwGFFHFFtjZyAS9LrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0EIE/3F9PxFGTcfe"
Content-Disposition: inline
In-Reply-To: <CAKohpo=VLCf2nz1WsL-iGw6BWwpmqZ+8JwGFFHFFtjZyAS9LrA@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0EIE/3F9PxFGTcfe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2014 at 08:55:25PM +0530, Viresh Kumar wrote:
> On 3 June 2014 20:23, Mark Brown <broonie@kernel.org> wrote:

> > Well, we would need to look at what the drivers were doing and figure
> > out something sensible - it really depends why they're trying to set the
> > regulator and what would happen if it doesn't work.

> For example, few cpufreq drivers are calling it during frequency
> transition and are checking return value as well.. And fail if it failed.

> One way out might be checking if pointer to regulator is valid or not
> and only call it if pointer is not NULL..

No, as I've explained repeatedly NULL is a perfectly valid regulator and
that's not going to work reliably.  As I've previously requested please
think about what happens to cpufreq if we fail to ramp voltages.

--0EIE/3F9PxFGTcfe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTje5jAAoJELSic+t+oim9zjgQAJbSla2qE5KD8j5eBV+zP/gP
1HDwLQ0mP/O8uOaTFcHPiTP/ai/CSCoPQBaoJAHt8SrO9UITHD+KXQT+YeZoErSq
HCPgSh6vepVs4Vt3BhVWVkktrnN6xyUKClYhDGhyLIR0/sawUgGLoPDoGPSBJc9X
vyOGhjA7QjrrM/narFsowurZGSZWu/SRN6aalbDeR24mc+tuqSrI565v5RLkUI+/
ULC8RH6eG60RGJP9fQ7z8/PtK8IxocB6uZZPY+B8zE0Xq0seazBRmUkdEI0gPGdm
4UX/liNt7o0d3xsVTPU+T2vRfp5JxuC6Z6iTPx/PbQHE4wCgQUFjxrqmScekdE0n
qiPxftYrN0f+HOONtsjFe+nbpRxeFE7PKvib85e1pQNx6NDgJtKO4WnJTsVdJjac
qg9sR8PKgPh0F26dS4pOhFFfs6TukC/Jw74bWo66NuHMR/EZnaMzGtiLjZ0abAIa
3Xl+18ue0OsJnW/SQIb/mDJWmfd/5EtRcQ2aYuXTei+pkji80M2OGrLGJtokE3w4
UK3Yf+xniNKescPeG58NLBMuX0qYEUUb2+bqRsfkyBrpf3wcviwtUXGjoBLjL+V7
22hPYYH+qw2MUtxCcC8FfbSPsMllgZGKZ5LtfcbsX6MOQwWZocHKyIFDoLJL315R
dtqDWUbOhOxCHQpA5V58
=95Q0
-----END PGP SIGNATURE-----

--0EIE/3F9PxFGTcfe--
