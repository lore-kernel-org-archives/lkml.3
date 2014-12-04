Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaLDKnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:43:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47996 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaLDKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:43:00 -0500
Date: Thu, 4 Dec 2014 10:42:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Message-ID: <20141204104236.GP7712@sirena.org.uk>
References: <547F3C96.9070509@arm.com>
 <20141203182659.GG7712@sirena.org.uk>
 <548023BD.8020804@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HgiFDCkkoIStfUUG"
Content-Disposition: inline
In-Reply-To: <548023BD.8020804@arm.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] ASoC: dwc: Allocate resources with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HgiFDCkkoIStfUUG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 09:05:01AM +0000, Andrew Jackson wrote:

> Lars-Peter Clausen had some comments on this patch so I was intending
> to resubmit it.  Would you prefer that I submit a patch to my
> original?

Incremental patches, same as is standard for upstream.  Please also fix
your mail client to word wrap within paragraphs so your mails are
readable.

--HgiFDCkkoIStfUUG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgDqbAAoJECTWi3JdVIfQA2gH/0BVUEQuLWuUrvYgzcb3UMwr
qCPMh0AxWYPfOYHNj3IQXoUh8SfrdqSYB5E2ahBqZrXC6AC8NglaK0c85V2imcCa
yOJh7a5Hgj1wtOk3xDMm64wXuUs/CP/erkbYry2xNsstBFplUg3RPmrNKn8yEtqN
/5XVVl1JA7BEdjK/fAFvjcKAZtA4gZqIDyPV56wvBFNC8CfWnpJ4YT4LFkImN8wK
EeGZiAeh3xZPYq9r8EFfjdD1S+4iCyB9wttBshgKYKwezWaatgk4+HkxMdXpurs2
S6gBp0JSzefjKUJoAXK1FlBf83cYiObQqn57CPyhel49dLzAWjts5+M5h+OmZQ4=
=SzDV
-----END PGP SIGNATURE-----

--HgiFDCkkoIStfUUG--
