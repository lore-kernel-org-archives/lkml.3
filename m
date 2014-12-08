Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbaLHSkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:40:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39010 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbaLHSkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:40:04 -0500
Date: Mon, 8 Dec 2014 19:38:53 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141208183853.GG8739@lukather>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141208061746.GD16827@intel.com>
 <20141208141807.GC8739@lukather>
 <20141208162843.GP16827@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vSsTm1kUtxIHoa7M"
Content-Disposition: inline
In-Reply-To: <20141208162843.GP16827@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vSsTm1kUtxIHoa7M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 09:58:43PM +0530, Vinod Koul wrote:
> > > So bit sceptical for merging now. I will send the patches which I have
> > > applied on top of this
> >=20
> > Which is why I wanted to merge this at the *beginning* of the
> > development cycle in the first place....
> >=20
> > These patches have been sent more than 2 weeks ago, and were exactly
> > the same as the ones send at the end of October, rebased and updated
> > to take into account the drivers that were merged in between.
> >=20
> > In short, these patches have been hanging around since 6 weeks. I
> > relied probably too much on the intel's build bot. This is not a
> > mistake I'll repeat. But blaming it on me because they came too late
> > is *very* unfair.
>
> as a first step one is expected to compile the patches we send. That is v=
ery
> basic stuff which should not be avoided.

Indeed. My mistake, it won't happen again.

> given that we had build failures on v5 rev of the series and serious
> failures flagged off by compilers doesn't inspire a lot of
> confidence.

v5 that you never reviewed, just like the v4, v3 and v2 before it.

> And lastly noone blamed you for being late, if things were rosy they
> would have been merged over the weekend and been in today's next,
> but...

I totally understand your point. And I actually am a bit uncomfortable
merging this so late too, and I'd actually prefer to have it merged
for 3.20. But this is a huge patchset, and I'd really like to avoid
rebasing it forever.

I'll send a v6, with your patches, as soon as 3.19-rc1 is out. This
will be my last rebase of this serie. If these patches are not merged
then, then I will just give up on this cleanup, and probably any
subsequent ones.

I'm sorry, but I just don't care enough.

Maxime.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vSsTm1kUtxIHoa7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhfA9AAoJEBx+YmzsjxAgzdUQAJpRNet20gGke0GchPJyL86r
2GhDNx04AWFxEkAwzFQj16zEgW3iQPnSXT8pVMxJ5/pkcOTRCuXXoYPsRLWGOYJ/
aXw1nS9fcFSHKXWiVU7VCHyaHTzcTNCrkGWHQPwUzUYqMn8tpiZGEICSJyVwuPrh
33SAg9+uNTJ1ZtXHnfu24D1EmmxTl1wGJWwHTDZsW5+v1dp9rogMiEXRK43cL5SQ
ZfrKSF+LIdGldylaGSFKFClTCyE5tBm7M6vO/fOTg4A9sYwWhTqtdKLsQrpEprQT
kRQuQjbUkqFXLzSlSCZwuGfnyi9qdRg0bMram76GtSp6GE/aA+HCjWj6oAcYRQpQ
qmG/l8PT0+HZ8wwH9t+9lZ0/buDKQkl4bejj8bcSrM8jB9raMSPBC9e4ZW4abHJD
B8JpdCXfc3cVg3nUBaHTpESEm3/EHS8ErwtqCuWPPzpsU/NzGvPG3TiaIulna4gp
IFFNwOgpaY9RzdQ+6MZNNY1RpTfxa7QchFYQISMB6vVsTdnX06Q8NKFl17dIvZSE
D6AQAmTci3JM3B6iLxB5n55A+hLLXtKNwtwTHQVI4TGytQsKsw27jN1bWvhzfJ0f
TNHQ/ZQzH88YozqEyMRm01XyxWAuzjcQJtB9S3QQdSLWizkmC4tI2Chbd5A010xW
umiHgJymQE9bg6p9EiSv
=maXJ
-----END PGP SIGNATURE-----

--vSsTm1kUtxIHoa7M--
