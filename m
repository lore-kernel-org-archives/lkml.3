Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaEZNqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:46:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37391 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752122AbaEZNqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:46:05 -0400
Date: Mon, 26 May 2014 15:40:52 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Matthew Leach <matthew.leach@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Xiubo Li <Li.Xiubo@freescale.com>, "Yang,Wei" <Wei.Yang@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        khilman@linaro.org
Subject: Re: [GIT PULL] clockevents: new material for 3.16
Message-ID: <20140526134052.GA3790@lukather>
References: <537F214C.8000700@linaro.org>
 <20140526194512.032c6630@canb.auug.org.au>
 <53830ED9.9060001@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <53830ED9.9060001@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 11:52:25AM +0200, Daniel Lezcano wrote:
> On 05/26/2014 11:45 AM, Stephen Rothwell wrote:
> >Hi all,
> >
> >On Fri, 23 May 2014 12:22:04 +0200 Daniel Lezcano <daniel.lezcano@linaro=
=2Eorg> wrote:
> >>
> >>        clocksource: sun5i: Add support for reset controller
> >
> >This commit caused a build failure on arm in linux-next today ...

It's weird... of_reset_control_get has been merged in 3.15 by this
commit fc0a5921561c71be2c334a335c1680f7930434d7 ("reset: Add
of_reset_control_get"), and then the commit
b424080a9e086e683ad5fdc624a7cf3c024e0c0f ("reset: Add optional resets
and stubs") removed it, still in 3.15 (probably a mismerge).

Finally, Hans de Goede introduced it back in the following patch:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/246738.html

That should have shown up in one of 3.15-rc's according to:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/252317.html

Philipp, what's going on?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJTg0RjAAoJEBx+YmzsjxAgDwEP+LQG+L7w5dIgGf3b3MOyvm40
vOyj0eRJ4540I5lNkp4Rz79YY9bWFiuR54Lze5N+fF6a/4qcXzcAEwT8pC3ExkKc
3f0VYrBcVcL7QDDN8MczwVckvy8imguXqV/tgFm46oXvBOpCIgqnT/ZxBHiJximq
YVpE0pTFEFHMIEYJwndBmhSRle/XZq+1CsVvTmMHU5iobvxpGYC1hICzYAi0JLtw
liR7cWc3VrJlxCHuzNRt+D9Hv7ZT31BfoCXpwAEUTeY0/km8RoHNCCDFvwnfOG3q
jXg8ON7YTLKBhJkalD07KWVnYMqOP4fEOvcUkUiQh11dHF7D98dPhmDPAtlMLzhs
SD7tF2+u1+uhW1F9N+pSvclMqCMTArHpofifMDs3Doc8IRbuSYFUvpwNFKU5b3JG
xzucC1GN5VOX+QsxGt9GLKduOiOICequKYerBPNN40VTqE1eZtA/kGMIZz/y/Ikh
rNAV9WSq6wi4H3DbYtalKpVr9G490GkiNPr7CM7njhh8EFMcMcsNH4PRuWNdfYew
Hjdc+qNAzxgiCwHak4y0NclI4A6Y1YVBLR3vct3iK09iMdy5wd5Ys8QN50Dd+teF
+YgSlnVDDq8ky/f6e8/g3rUv2Go2eZVvMZEanKkTCGS7+xXw0dvyCTHjWeIDPhRk
Afmx1+MM8XBAFr4G1oM=
=tI8y
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
