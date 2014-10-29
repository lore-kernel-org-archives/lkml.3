Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbaJ2MX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:23:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55175 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaJ2MXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:23:23 -0400
Date: Wed, 29 Oct 2014 12:22:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Message-ID: <20141029122204.GG18557@sirena.org.uk>
References: <1414572037-11306-1-git-send-email-pantelis.antoniou@konsulko.com>
 <20141029101420.GT18557@sirena.org.uk>
 <6A3753C0-251A-4645-AD96-CB1D6521175F@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tlm0M+DeSTNuB35b"
Content-Disposition: inline
In-Reply-To: <6A3753C0-251A-4645-AD96-CB1D6521175F@antoniou-consulting.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] of: spi: Export single device registration method and
 accessors (v2)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tlm0M+DeSTNuB35b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 01:48:06PM +0200, Pantelis Antoniou wrote:
> > On Oct 29, 2014, at 12:14 , Mark Brown <broonie@kernel.org> wrote:

> > This feels like there is an abstraction problem somewhere, whatever code
> > is supposed to use this is going to need to be taught about each
> > individual bus which is going to be tedious, I would expect that we'd
> > have something like the bus being able to provide a callback which will
> > get invoked whenever a new node appears on the parent node for the bus.

> There=E2=80=99s a whole patchset that does exactly this.=20
> Look at "OF: spi: Add OF notifier handler=E2=80=9D and you=E2=80=99ll whe=
re this is used.

I deleted that unread I'm afraid; one of the reasons that you should use
subject lines matching the styles for the subsystems is that it's one of
the things people use to filter out things that actually need attention,
if things are busy things that at first glance don't look terribly
relevant (like changes to the OF core in this case) are likely to get
looked at less urgently or just skipped.

A quick glance suggests that this is adding code inside the SPI core so
it's still not explaining why anything is being exported, can you
clarify please?

> > SubmittingPatches says.  Please also try to keep your CC list sane,
> > CCing random people just means that you're increasing the volume of mail
> > they have to process.  I'm surprised kernel.org accepts so many CCs.

> > I have to say I don't recall ever seeing v1...

> All of them are in the CC list for a reason.=20

This is a single, standalone SPI patch - you didn't send it as part of a
series (which is the only reason I read it).

--tlm0M+DeSTNuB35b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUNvrAAoJECTWi3JdVIfQ4A4H/1YvLCCSelky+9svlKbsYNYF
Bxw4veuiONfqqbnjsBNE+hwI5rNaKiJv4d3GgYUYa69i9SlDEU7JXYVE69ZYF3WO
zjFnJCcs4KeYiyzrjcyl5fgU+OACakDtQkOY6Ncn0HZqQPgfT67EU2Ov1fEMv4/f
1ofH7j5QTxaIECybBxF/7vhDWteK00wc0ThYSmtg9XMkGkYC0nOmJaodPktSbneu
OU9/0sFWahryla2pGT3wquGp+WsMWIfi7jZ6UA2v88cgEfuih9lHFY5GKa60KmOz
s7bqj/gNNHqeqGUr51Hdzc87fHGgqrltKeaTcsVZ3uapsAGNk9BQNYWTcRgtLuc=
=3pJ6
-----END PGP SIGNATURE-----

--tlm0M+DeSTNuB35b--
