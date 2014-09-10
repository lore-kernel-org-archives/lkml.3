Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaIJTvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:51:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33669 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIJTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:51:31 -0400
Date: Wed, 10 Sep 2014 20:50:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Stefan Wahren <info@lategoodbye.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140910195052.GN7960@sirena.org.uk>
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de>
 <1410089869-6611-3-git-send-email-info@lategoodbye.de>
 <20140909182211.GG3896@leverpostej>
 <540F523D.4010904@lategoodbye.de>
 <20140910141853.GA4994@leverpostej>
 <20140910151316.GG7960@sirena.org.uk>
 <54108B34.6010701@lategoodbye.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aIbcA3MSwnGacr4f"
Content-Disposition: inline
In-Reply-To: <54108B34.6010701@lategoodbye.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC 2/3] ARM: regulator: add Freescale MXS regulator
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aIbcA3MSwnGacr4f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2014 at 07:32:36PM +0200, Stefan Wahren wrote:
> Am 10.09.2014 17:13, schrieb Mark Brown:

> >Ugh, this looks like it might be a regulator driver but since the
> >subject line was "ARM: " I deleted it unread - if your changelog looks
> >different to all the other changelogs in the subsystem it probably needs
> >changing.

> sorry about the confusion, i will remove ARM in the next version.

> Changelog? I didn't send a changelog because it was my first version.

The changelog is the text describing the change you are making, not
something describing differences between revisions of the patch set.

> Should i resend this version only to you?

It sounds like this needs a new version anyway so may as well just wait
for that.

--aIbcA3MSwnGacr4f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEKubAAoJECTWi3JdVIfQ0DMH/1n5R03w2Rfis1ldaJ8pZWU0
uWxgCQI5HR+nRhBTQgenNAr12EMh2q+dgcM3+IAjgJssYgsEfWgLT6LNIE4kOeaO
fpP41wGGMaMCDKtdvgncVHcusM+8jW3ChLjMEKQ3KPMJh6q6EpgfW0DKrcTIfQ7k
5OyeB/GdwXzicb//+E+Kn8xyG/xQcKIU5bJVN9nxeQEkokO2HpunA3b1MpmY3S2K
6As4vMxcg/+XurgFZiIU72lkA0Y7ZrUxJpDGGfTd732DCKkeHwSOL2PJn4NZ2MqV
ZIBQtTAC5tb7F2tJmxRBkinHot52PJckchBAVO291JSESCu55buyrbjqktTp5i8=
=yAhr
-----END PGP SIGNATURE-----

--aIbcA3MSwnGacr4f--
