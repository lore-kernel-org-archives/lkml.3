Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3F1LPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:15:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49680 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3F1LPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:15:36 -0400
Date: Fri, 28 Jun 2013 12:15:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Ankur Raina <Ankur.Raina@kpitcummins.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        david.chen@diasemi.com
Message-ID: <20130628111510.GD27646@sirena.org.uk>
References: <4B6D9C89CD8BA349A71B74CA32C47E5850DA82AF@KCHJEXMB02.kpit.com>
 <20130627174111.GG20292@zurbaran>
 <1372416519.13538.25.camel@ankurr1-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iwrWpCOd/M6155vD"
Content-Disposition: inline
In-Reply-To: <1372416519.13538.25.camel@ankurr1-desktop>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch v1 1/1]mfd: fix for DA9055 driver initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iwrWpCOd/M6155vD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 28, 2013 at 04:18:39PM +0530, Ankur Raina wrote:

> > Could you please explain what that fixes ?

> While powering up DA9055,events are received of power sequencer.Events are also received on gpio's.
> These events remain uncleared after boot up, due to which further event handling also fails.
> This patch clears all the events received, during driver initialization, so that we have a clean state after boot up.

You need to explain this clearly in the patch description in a way that
can be related to the code.

--iwrWpCOd/M6155vD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzXA7AAoJELSic+t+oim9mf8P/3YMh/gO0hM+XVv094lzr6d/
lb25f8Bg6yQbullK9dObLVkewcqahREStyv/Y3yUT8mf5u1uqmVx0/c066APgaFl
+9kYSJjh+7b5pCcTX8bZ2+kqQPAPb5CtHuj+3sWRMJxFrYN1U6Jl9cpL0QxFTXIT
wjU6J8kEmPHoTEbtuo4hOjGt+fn6WDFVKa8EGFDfNCTWF6fXb03CMgylqakMFUz9
mawN5VsmscqNEv51+9JwHYTMOTPnvql8qK+g6uCDxEG96UmO75BaJ/ZTfogd7Yx/
fAVGde1p836MXMjGMwq+kRQCheXqS6KRsv+TFRKAK5l0d/kAV4kvYZodlpHMXOP9
iZhA9eRN5MTaXPVpxX1yrAKDYixenS8ay1WVKl0H0KNFFuWMwkoEPyy/Nw0+gXia
QI1AERFv8Yh49nXhm8fFiIoyilwudSK9xXwlpSJIxVhS8M4vBROEMDk6J5p/+7k+
bxpNZFzE+RB9YXzCsWrMngTk3f/OuhNbuO0UfxFCORotEABgMWprc7CKGFpVSfzO
Pnd8eHagrShokhlfNwJ5zuPZIg4/Vf80rAnb5lw1xPKUyLNjc+D26AYjY1qXC/Dw
xCNbhJhr+3zW8hXMKXsjudthWQIfWnJU+TdIpB545CuA+6ZDUNLujYzXUrDwL6nB
UrR9ZS59IUUNBgoDc/0R
=MuuY
-----END PGP SIGNATURE-----

--iwrWpCOd/M6155vD--
