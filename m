Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaLDQqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:46:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48307 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612AbaLDQql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:46:41 -0500
Date: Thu, 4 Dec 2014 16:46:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Darren Hart <dvhart@linux.intel.com>, Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com, Al Stone <al.stone@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20141204164612.GW7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <2580837.YI0IvfXqRR@vostro.rjw.lan>
 <20141125202722.GA25261@sirena.org.uk>
 <1926483.B4ieFnCBlM@vostro.rjw.lan>
 <20141204104819.25015C40992@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PZ+ncX79j/Ht6R2F"
Content-Disposition: inline
In-Reply-To: <20141204104819.25015C40992@trevor.secretlab.ca>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PZ+ncX79j/Ht6R2F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 10:48:19AM +0000, Grant Likely wrote:
> On Tue, 25 Nov 2014 22:40:53 +0100

> > We absolutely need to start registering the existing bindings in there, but
> > that needs to be rate limited somehow, because the process may not be very
> > efficient to start with.

> Beyond having the document point to the existing DT binding
> documentation, I think this is a non-starter. It won't be helpful for
> anyone to have two separate repositories containing the same bindings.
> They will get out of sync and we will have pain as a result.

Right, I think we have to pick one and reference it from the other.
Having the one place be inside the Linux kernel doesn't seem super
awesome.

> For existing bindings we need to have a way to share the documentation,
> and I don't think we can even talk about whether it makes sense to
> migrate the documetation to the UEFI managed repo before the UEFI process is
> fully flushed out.

We definitely don't want to start dumping everything in immediately but
but starting the conversation to both provide urgency and requirements
and and be engaged in the process seems sensible.  Let's try to take
advantage of the recent changes in UEFI governance to help shape the
firmware interfaces we'll be working with.

--PZ+ncX79j/Ht6R2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgI/UAAoJECTWi3JdVIfQygAH/RwaWasDgHAAKZaL4hW501Gs
Z9GKGbsR9V0DXMr54C1Gas1d+PNBBuRMrjyMbjLvWwe6aFj2MNhwpbCyIYGKrOQr
3Nvl2iFvFmKgECphBnE6g7paj0PvgQTpvNOXGV1XuzX6XWnpB+fFOHtLMgIrKeZ9
5ykT/Fdo7CnKROL0H2TaSTnqhELkagozLjvMql43S7xlN7QyWmEiVNPeV883mtKG
4H25QcuoyQEnPm3kxspRFkCTOtJhCBgtIX2KkT7Lr0d2Rw0PDVVB03smfWxQXNq/
0kLsYlL0SaO+VeqGVPKVlNBf1m9MLVfh3OvCblj5YFNgMCOz/7gijvwxkHq0mgg=
=cBb6
-----END PGP SIGNATURE-----

--PZ+ncX79j/Ht6R2F--
