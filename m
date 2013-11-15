Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3KOO4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:56:43 -0500
Received: from ring0.de ([91.143.88.219]:60825 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab3KOO4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:56:34 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 15 Nov 2013 14:55:56 +0000
From: Sebastian Reichel <sre@debian.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tony Lindgren <tony@atomide.com>, Luciano Coelho <luca@coelho.fi>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Felipe Balbi <balbi@ti.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 1/4] wl1251: split wl251 platform data to a separate
 structure
Message-ID: <20131115145555.GA23351@earth.universe>
Mail-Followup-To: "John W. Linville" <linville@tuxdriver.com>,
	Tony Lindgren <tony@atomide.com>, Luciano Coelho <luca@coelho.fi>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bill Pemberton <wfp5p@virginia.edu>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1382890469-25286-2-git-send-email-sre@debian.org>
 <20131114185132.GQ10317@atomide.com>
 <20131114230330.GB6383@earth.universe>
 <20131114232217.GV10317@atomide.com>
 <20131115143254.GA7079@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20131115143254.GA7079@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2013 at 09:32:55AM -0500, John W. Linville wrote:
> On Thu, Nov 14, 2013 at 03:22:18PM -0800, Tony Lindgren wrote:
> > * Sebastian Reichel <sre@debian.org> [131114 15:04]:
> > > On Thu, Nov 14, 2013 at 10:51:33AM -0800, Tony Lindgren wrote:
> > > > [...]
> > > >
> > > > If this is not going into v3.13, these will cause conflicts
> > > > with the mach-omap2/board-*.c files for v3.14.
> > > >=20
> > > > So it might be best to do a minimal header patch first that
> > > > can be merged in by both linux-omap and wireless trees.
> > >=20
> > > I guess this patch is pretty minimal. It also seems to be acked by
> > > the involved Maintainers, so maybe just merge Patch 1 without the
> > > other patches?
> > >=20
> > > This does not solve the problem with the struct modification from
> > > the second patch, but I guess it's the more intrusive patch.
> >=20
> > Once at least the first two patches are ready, how about I queue
> > them after -rc1 and set up an immutable branch that can be merged
> > in by linux-omap tree and the wireless tree?
>=20
> That sounds reasonable to me.

So what changes do you request for those patches? I will try to
update them as soon as possible.

-- Sebastian

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJShjX7AAoJENju1/PIO/qaOgcQAIFxSRKg6g82sFajCuGZfI7s
t34ArIr0cWzxtFnPw0TE4lGaCPKmUpxdCj3568m6ejI7ZjZvZTD0rO02SS6v0jWM
7tAgYLXjoBmP4haZ1OfjJitZuQmk/YsBckAjegd3dIGeKO0xroNuIe3yfTIuVFR8
pFc6cOhFESwT2oPxjh6rAxkHBhhubXIDFnscJWc85JdhN37s8kEfIJPRpDkYWNzE
6Wun2h3/QzYPPQeVfCLUEL956Vif3Qp/KlKfPRhhd9/5LVUjKzCRij/B2jnB1Ufq
aZJrRgXq8k9EvIMCUamIgtRwvi3RvhNrE3gET6F0dy9qnwYb1Iqg0CLX1tW5Rrc5
D1iAFNeYSXXyl3TtnEaoJjMjTHxIGQJhrh27eTD/ChC59kssmNCwpMEDUq13Z4NT
Ve5tzgbOt3om4RVLdDux443wVbdPwNqjdnDQkLX52yQmMOec33deFTxzNtMEVakN
+vSdwLhHVgdd27llrqpePQGu7ELRVPRwGAKw7JBZzFkE8kbJSzNFvevpMZHe1dDX
xacBI4c4oiOPgjd7AuEepXeEIaTJ5F+Evzw7ZZPOs4A9vWpPaPm35c0dzQoswAjH
MHYdO5tuUU6Tm95Fy6jj+SOTjgSlHhq0XS0HbrdgC1pC97ROoLjet3j8fV/aK/mc
pTx51yqDqRfkjjWgkydn
=QcUk
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
