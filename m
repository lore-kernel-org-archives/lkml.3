Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3FNNyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:54:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45766 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3FNNyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:54:35 -0400
Date: Fri, 14 Jun 2013 14:53:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Message-ID: <20130614135358.GR1403@sirena.org.uk>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <1370950268-7224-2-git-send-email-bigeasy@linutronix.de>
 <20130611142336.GE29135@zurbaran>
 <51B7358D.7000605@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mu1Tvth33Vj8K2q"
Content-Disposition: inline
In-Reply-To: <51B7358D.7000605@linutronix.de>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/22] mfd/ti_am335x_tscadc: remove regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mu1Tvth33Vj8K2q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 04:34:53PM +0200, Sebastian Andrzej Siewior wrote:

> >> Therefore this patch removes regmap part of the driver.

> > NAK. Using regmap is better than open coding your register accesses, and
> > the children not using this API is not a reason for the MFD driver to do
> > the same.

> There is no advantage over using regmap in the first place. It goes
> through a few layers, uses no caching because almost all registers are
> volatile and this is a direct bus. In the end it complicates more than
> it helps.

It does give you tracepoints and debugfs.  If it's making things at all
complicated we need to look at why that is and figure out how to fix
that since it's probably an issue for other users.

--5mu1Tvth33Vj8K2q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuyBtAAoJELSic+t+oim9BbYP/1+zKwt1iB3j76z88fQnyubj
KOiwAO9mDpaTdX69TCrRyhSfL/soylTxHBvHpHv7WNhWGF/MAaz7ivhOJ7ENBojg
fX8LAMSFhWRq5KpCOKKWQGcdiyaQhqBknfHMAIoahBC+1Y9v/k2sNnuHogOLzybp
rb+bewLZIcoo6eSMeuxauwvXukkQNWJTL8NB92LME2toFntazY0uPshwDVbbZjCs
bFAyv0RXkljqlfUGwYe6rubfaGYR+6GNCIWMl1A1aiWhKW4tspktsk0aI+uEVznk
5YCtpfAm4dsQecaoQtsgIRmK0978Zrm0R5buj8pkbiv6kYBmpGQ8BMV+CXRqOXjp
4CGKn2mHOnvHJdQ518xmnvxUhYP0j9bh+GzvMLM5Mbuou/P9vf3SSMFTO+FKvGJ7
Ee51mW0d5u/NBUKtcTyjp4zytuvh0yHteX/L3f+XONT6izUCg9z/LnmuaTrv9x7A
dQ8LLORyqGtgL/rUGZ6cb8fSRfPKa82noi8dXm5TSp5eQbDlPLsRg48XDPqCkOYl
W8ns1GUVu0+xIEjHET8w+Ff/LttXYG9if8Y6S6tKziohfizX46X9PIabiFpeKO3u
x66j6t9ui+HEtklLKgRYtbOzAIvExgmNMnx81fA3HpmduSoarhtOJzECkdFZt6od
QdyKhuqOeBEmM4YA/3lK
=mCoi
-----END PGP SIGNATURE-----

--5mu1Tvth33Vj8K2q--
