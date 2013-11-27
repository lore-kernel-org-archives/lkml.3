Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3K0MEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:04:08 -0500
Received: from ring0.de ([91.143.88.219]:48638 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab3K0MEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:04:04 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 27 Nov 2013 13:03:58 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: viresh.kumar@linaro.org, egtvedt@samfundet.no, jesper.nilsson@axis.com,
        linux@arm.linux.org.uk, swarren@nvidia.com, andrew@lunn.ch,
        nicolas.pitre@linaro.org, tianyu.lan@intel.com,
        rafael.j.wysocki@intel.com, kernel list <linux-kernel@vger.kernel.org>,
        tony@atomide.com, pali.rohar@gmail.com, arm@kernel.org
Subject: Re: omap-cpufreq compilation breakage in 3.13-rc1
Message-ID: <20131127120327.GA31130@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>, viresh.kumar@linaro.org,
	egtvedt@samfundet.no, jesper.nilsson@axis.com,
	linux@arm.linux.org.uk, swarren@nvidia.com, andrew@lunn.ch,
	nicolas.pitre@linaro.org, tianyu.lan@intel.com,
	rafael.j.wysocki@intel.com,
	kernel list <linux-kernel@vger.kernel.org>, tony@atomide.com,
	pali.rohar@gmail.com, arm@kernel.org
References: <20131127115407.GA6773@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <20131127115407.GA6773@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 27, 2013 at 12:54:07PM +0100, Pavel Machek wrote:
> Commit d4019f0a92ab802f385cc9c8ad3ab7b5449712cb broke compilation for
> omap-cpufreq.c . Given impresive list of ACKs and Tested-bys, I'd not
> expect such problem. This fixes it.

This has already been fixed in 696d0b2c786161ddc1e80dcddce7d34c2a709566:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/cpufreq/omap-cpufreq.c?id=696d0b2c786161ddc1e80dcddce7d34c2a709566

-- Sebastian

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSld+tAAoJENju1/PIO/qaW9kQAIaHsvYw0we9TKf66o1yUhZG
b+w3dhV37EMfLs2ASkOU5BudGudu6x6sRjdU7YlT1j5LAHB2HNm9KAj+P8/TJOTj
VxyoL9MCLphwPsZv4yykHYS1qqJWSR7G41slp5NzGYum/o1ECT/XYuywbfKO8Hjt
No3GVdBNLnpmgOUFmcGPqYiCSHl9BoxS6mCLb3SzLgJrwG3Yh8Ppn2Mtfkiod2uI
w+t20/i/7nOgfGZtiyS88+Ot2R4DNbn850ke/tCfQn/ud6eO9HFFP0Isk9Wdnoxu
6tw5jxJg5Pg66zaB+ZnSbL/7vgspb+r7Z6JTMVA+IVbSsD5P3a0VfUlwY4aXmXPY
WEFfBWAAUVvr5++HsRcYsUeA4h+/FpVKFpKjyUOn8edvUNJIQ8M0WKQLdR7YYFFR
WBnPnnk6Q/moT/1/OhXET5Hhw/LPvnSGd+2zimSkdEqtrGYo9zl4Xky1DTg2MWa8
7HVtVNA9uugpy3TJAaqzMbu0LoJzXoCZOHP2Gz2hLbrlBPs1LAZB7wrnxZs9rrEr
fN6TQpwUufOvPanV2vMUjszEJUjcYUpVObFWZwK3WyHisHZqHa6beUqzL7Qhthjf
3YYp3BZJ0H8967oGcE1mNypS379iMp8ePCQhuOXBYzaseYOdMixdSf4CCu6ZtUCz
DQB1GhjiiQhCjJa5Gz/2
=8ghl
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
