Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaDWSOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:14:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43114 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaDWSOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:14:03 -0400
Date: Wed, 23 Apr 2014 19:13:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140423181350.GE12304@sirena.org.uk>
References: <20140423113941.GL21613@lee--X1>
 <20140423124629.GA12304@sirena.org.uk>
 <20140423150047.GH6264@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vW+D2DIg1cqRcJ5V"
Content-Disposition: inline
In-Reply-To: <20140423150047.GH6264@lee--X1>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] regulator: First pull of MFD <-> Regulator IB (v3.16)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vW+D2DIg1cqRcJ5V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 04:00:47PM +0100, Lee Jones wrote:

> > Can you drop the last one please, I've already applied it?  I'd have
> > expected just the first two (or probably even just the second one).  If
> > you need it in your tree just grab the branch (or I can tag it if you
> > like).

> > I tend to apply these things early where they don't have dependencies
> > due to the large number of reposts for unrelated changes in the series
> > that tend to happen (and often several very similar serieses being in
> > flight at once); I frequently end up just deleting them unread.  Not
> > sure what the best way to handle this stuff is in general.

> I know that you due, which I think makes things easier for you, but
> more difficult for everyone else (author, other maintainers). Applying
> cross-subsystem patches also makes things difficult down the line.

It's not really my convenience here - it's about trying progress the
serieses and cut the amount of code that people are having to carry.

People were complaining about things getting stalled due to lack of
review but of course one of the reasons for that is that it seems that
the early bits of the series commonly need respins and there's frequent
delays too (probably compounded by the frequent respins).  That creates
a sense that these things are going nowhere slowly (or are just reposts
of already reviewed changes) which discourages spending time on them
until someone actively chases and then compounds the problem.

> Not sure what do do about the last patch now, as it has MFD changes
> which aren't in the MFD tree. All well and good if no one else touches
> that hunk for the remainder of the cycle, but if they do we're likely
> to have merge conflicts.

As I said above just pull the branch into MFD - like I say I can tag it
if you want, in fact I just pushed one:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/tps65090-reg-pdata-v3.16

That's what all the tiny topic branches are for, to make it easy to do
merges when needed - there shouldn't be any great difficulty here?

> > >  Documentation/devicetree/bindings/regulator/tps65090.txt |  4 ++++
> > >  drivers/mfd/tps65090.c                                   | 41 +++++++++++++++++++++++++----------------
> > >  drivers/power/tps65090-charger.c                         | 11 -----------
> > >  drivers/regulator/tps65090-regulator.c                   | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/mfd/tps65090.h                             | 19 +++++++++++++++++++
> > >  5 files changed, 104 insertions(+), 27 deletions(-)

> > Your formatting for these still seems to be messing up.

> How so? Looks fine for me I think?

The lines are *way* over 80 columns, look to be formatted for about 130
or something.

--vW+D2DIg1cqRcJ5V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWALbAAoJELSic+t+oim9ZFcP/RaTgWcrW/71aQfkFZzuWc0Y
YuJn1xdtk0oqXUNoaAJb0yB1xpuaqXlyi5IktPAs/zty17CkTx9urbjN6bBTCu9d
Nut7PoFkecx/HcM+ibv+cPp2UF5SZVZVCpJieDeOoUVnBea+4Qu8D8AZcNf78R0m
k8aIMRCCVbzPisbvcoNyp0cp/bhXKkRVsrTImgcbnWryUGndgG3Ho0VTvabVd8B/
fAW7kcXNqopS4zbhRERnz7DpZNmVzHM9klJ9PFgFtr3wgZcDOdsy7fOAFQESfL1i
dpp8f6CXm4jl7iD0Q21dcMl/y4o9TGe7mZ0BwsvWhFGw8RwgZWIpOVJj2dLjg37+
kh92k5XFqYQfpsU+ZsKfpoTiWjZ1lghcoJ0Io1bz/QD1SGoM6niMsV9paHLvLgWV
q6R2zd+KGMvBkpAxW30x7gNbdFHAA2WU6iTY4NVUPO9IlFYawMnaXwk6k9vtN77O
689KlZfL3qry8v3sP3xLqUbu1DQtKsJvvTitCUD/eVGepImLyP1Gnr58E36Pj66c
C9byaqp8l/HGWKlGizpu4Xw1YOhdm9HCliXWXj/2jjakNIBqll41JY0/9JD0kM1G
IyxdAsoy0xC1zTrT2v31o0NYewIO/3NKVNDB3Z5JAxEyRCbbFrUdXhD7I3l7Dsr2
CJ0WsxxR5acOqaKnxe0v
=M884
-----END PGP SIGNATURE-----

--vW+D2DIg1cqRcJ5V--
