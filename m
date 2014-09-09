Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbaIIQ6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:58:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59449 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaIIQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:58:04 -0400
Date: Tue, 9 Sep 2014 17:57:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Kevin Hilman <khilman@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Andy Green <andy.green@linaro.org>, Tony Lindgren <tony@atomide.com>
Message-ID: <20140909165730.GE2601@sirena.org.uk>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
 <20140801182656.GJ30458@sirena.org.uk>
 <CAJe_ZhcmEUDD3+xC2mBFnBm7uiMhibtHhBOMxVBhy700BTvYsA@mail.gmail.com>
 <540F299A.6030906@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="81cS/AQiHTJECVaz"
Content-Disposition: inline
In-Reply-To: <540F299A.6030906@ti.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.152.174.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv10 0/4] Common Mailbox Framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--81cS/AQiHTJECVaz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2014 at 11:23:54AM -0500, Suman Anna wrote:
> On 08/02/2014 02:48 AM, Jassi Brar wrote:

> > Thanks, sounds good. Will do.

> Is there anything pending on this series to make it into 3.18?

> This is one of the dependencies for our AM335/AM437 PM suspend support,
> so it would be great to see this in 3.18, so that we can target 3.19 for
> the PM series.

It'd be good to get it in -next, I don't think that got chased after the
merge window.

--81cS/AQiHTJECVaz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDzF5AAoJECTWi3JdVIfQ/y8H/0KjYDRooeHvMnTX/i3IjCz3
zZ//GQZlDJg8PycNItxPDsUdge6bjJFXtLQGZq6KxjBf8E0dEthNhD7c7u5u6xyQ
IWLfIwkgDfAd2S6FW2wF9PV363wSSC0Fc2R/zmUNpILIxCtYStw3gkPbhvSajjLA
PttGezOFUHdfJo2uFyLM67Vi/2UxCNgwrXsQSXDcdLPFsIGwFZ5kK6Lkh4xTKwRv
SY2VTk2FXgQLzACtE72oq/fBWUoJ4WnJNpzMqWgNESI3EfED+CQaiYWWDwRnRRLW
kvkMMkQ/4EtlmtxWnPt/SMyCFD2fNq0tqizUbvxhx8ye0kqTeLIAlKjuYt6V0qg=
=R1Zx
-----END PGP SIGNATURE-----

--81cS/AQiHTJECVaz--
