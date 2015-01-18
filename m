Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbbARLnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:43:07 -0500
Received: from sauhun.de ([89.238.76.85]:53965 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbbARLnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:43:03 -0500
Date: Sun, 18 Jan 2015 12:42:55 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Arend van Spriel <arend@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <mporter@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150118114255.GB1113@katana>
References: <rjui@broadcom.com>
 <1421451737-7107-1-git-send-email-rjui@broadcom.com>
 <1421451737-7107-3-git-send-email-rjui@broadcom.com>
 <54BB795C.6040402@broadcom.com>
 <20150118094741.GE22880@pengutronix.de>
 <20150118110658.GA1113@katana>
 <20150118111759.GG22880@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <20150118111759.GG22880@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 18, 2015 at 12:17:59PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> Hello Wolfram,
>=20
> On Sun, Jan 18, 2015 at 12:06:58PM +0100, Wolfram Sang wrote:
> > On Sun, Jan 18, 2015 at 10:47:41AM +0100, Uwe Kleine-K=C3=B6nig wrote:
> > > On Sun, Jan 18, 2015 at 10:14:04AM +0100, Arend van Spriel wrote:
> > > > On 01/17/15 00:42, Ray Jui wrote:
> > > > >+	complete_all(&iproc_i2c->done);
> > > >=20
> > > > Looking over this code it seems to me there is always a single
> > > > process waiting for iproc_i2c->done to complete. So using complete()
> > > > here would suffice.
> > > Yeah, there is always only a single thread waiting. That means both
> > > complete and complete_all are suitable. AFAIK there is no reason to p=
ick
> > > one over the other in this case.
> >=20
> > Clarity?
> And which do you consider more clear? complete_all might result in the
> question: "Is there >1 waiter?" and complete might yield to "What about
> the other waiters?". If you already know there is only one, both are on
> par on clarity. Might only be me?! I don't care much.

It is minor, I agree: If I read complete_all, I assume there is
something fishy if there is only one waiter. It doesn't match. It might
work, but I'll wonder if this is accidently or intentionally.


--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUu5w/AAoJEBQN5MwUoCm2geUQAJEnu7R/+Jk/gusjSDqXbpJu
CYFKdbI/TrT2YVaSMZBDeUAbv1/TPP3r0hrSxwRNHlUvaM/k/cCj62xm/CG9t2Xq
7YEjjyAFa6jRWeumMbreNcjCLeS2KfeH3L/TNY6C6ZfUJRFlAMyisYJc/Pn4DHdA
vsYSik2pPYF9Q0E15ZxrRiO4ixg3BuPwjbyVfhl0XdcjJafQ1WpetCz4HTxD5SJ5
rOA+sqTeClIQ6HoNalk1HytZdarN+i//C8q+WrIzkDBQA9E09CSkaErwYpqiaDU+
PzfdCzZC+wo9+/Qx0c4G+XTeKyMAi7+Qupp+ckUHQI80QIgT6tb8UB6PLSnX212f
YQVa0dnD1yUMrxwicKDCUholu5OeTmd1YyEYmIWIPZyb3xNwDPp5cs5pLu9vlTOi
Xu6Dw4bqxWQBeKG/RbBTaGunrWA0ALquumya81p6mKhvnCxlWd8B70hdjitD2OXT
TU2JugP1s2SV7LAEnFLVPH9IsoJQMGyNgea+uqBaO6shWP68/SryDhJuFRQxvJXY
2sJY22kOG1YIfQCwIRRymxTGlhRmBkU3b4yWvPgTxKfJQNj4rhgOMeNjUsc8Kcdw
enZVJRV7RCrMEtGbt3Cuk087DI0MzjBcdp+EXuP3MxZoTUf8C3KaiKsMK/4/WtWK
g4tJdmBigKm9ndgaVRRG
=KVgA
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
