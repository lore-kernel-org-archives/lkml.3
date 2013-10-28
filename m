Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab3J1Rxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:53:53 -0400
Received: from ring0.de ([91.143.88.219]:36332 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab3J1Rxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:53:50 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: get_maintainer.pl]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 28 Oct 2013 18:53:42 +0100
From: Sebastian Reichel <sre@debian.org>
To: Mark Brown <broonie@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [RFC 3/4] ASoC: Allow Aux Codecs to be specified using DT
Message-ID: <20131028175341.GA28136@earth.universe>
Mail-Followup-To: Mark Brown <broonie@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jarkko Nikula <jarkko.nikula@bitmer.com>,
	Grant Likely <grant.likely@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org, alsa-devel@alsa-project.org
References: <1382909086-10493-1-git-send-email-sre@debian.org>
 <1382909086-10493-4-git-send-email-sre@debian.org>
 <20131028163721.GJ13643@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20131028163721.GJ13643@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 28, 2013 at 09:37:21AM -0700, Mark Brown wrote:
> On Sun, Oct 27, 2013 at 10:24:45PM +0100, Sebastian Reichel wrote:
> > This patch adds support for specifying auxiliary codecs and
> > codec configuration via device tree phandles.
>=20
> This doesn't apply against current git, please check and resend.

Can you give me a git url to rebase against? I used current git
master from torvalds.

> Please also consider your CC list more carefully, there's an awful lot
> of people on this...

I added exactly those recipients, that were returned by
=2E/scripts/get_maintainer.pl for the patchset.

The list of involved people is quite long, because the patchset
touches devicetree, documentation, boardcode, asoc and the specific
driver.

-- Sebastian

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSbqSlAAoJENju1/PIO/qaluYQAJv4mQoI/HEx6KKDzuESNbNk
30kLQO8ZSUOJlyxTTqGqX47V/xqS8WSnDX9VpZuPUeKh2QUAxjCCokcGIAkq1hng
Ff913f5hbATBPcXhzyjXDkPGBlu/GS/eI5b2d76BwEAAQYfwND7Kz4FHVSDS3Kt4
36RsKMYCd3O+9Vb6WMW/0AjsNO7vXBLSRjCuXj3+1KyhcCoRzckEjtPyadh5kE4o
m7rgrHfYN1ZX1zzzsVDKG2cyI0kKaEHXku5e+UL49dJOd/Yu458y8FAsAwWztmSL
yLr8Dg5mHL7FxCAl677c83nbdCQHVuUcw+0xjxOatlDcCJo/R51vnD7NRpKFHFW0
TT0EDPw/2hYR4GsDsmipALRTRSvho38nLmJYH7wLbLx/FXWQ1Nz6pvtajNMxr658
98f68/L2Uq3hVl0ZCird6bbkwoeQ30ByGsdsiSxAs+WUc30eRN7K6C20ALucon7i
iQileFKS0lPenfKyEIiR7v1me1Zdb0eo6K/wGWFKGPPy6hSIgCsCvlJ0KIHyUsbm
k96g4Up6hgmmu03jLqjjAXqllOq8kGPSizAQqtm8svuWMDXVRxr3c8la1ukeq0/k
aihPi+OCtLTSjcVtEaVvMHNpxzDvsIF4Bu8+fxuO//uhitFPFHHs/Si4TOlP9Ziq
wKGwo4V/abcb3iSp5TpD
=L4OE
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
