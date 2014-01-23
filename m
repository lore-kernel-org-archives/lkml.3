Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaAWSE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:04:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58649 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaAWSEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:04:24 -0500
Date: Thu, 23 Jan 2014 18:04:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20140123180410.GA9571@sirena.org.uk>
References: <20140123131936.GK17314@sirena.org.uk>
 <CAADWXX-EZm-=cUqR54bWoLyCBo16ErOpAV7DSu5Ne9bhBG532A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <CAADWXX-EZm-=cUqR54bWoLyCBo16ErOpAV7DSu5Ne9bhBG532A@mail.gmail.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] SPI updates for v3.14 remerged
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 09:40:44AM -0800, Linus Torvalds wrote:
> On Thu, Jan 23, 2014 at 5:19 AM, Mark Brown <broonie@kernel.org> wrote:

> > spi: Updates for v3.14

> gmail hates you. I just found four of your emails in my spam-box.

> I don't know why, since it's not the (somewhat) common issue with bad
> or missing SPF information. The only thing I can imagine is that gmail
> thinks you're not you, since your "From:" line says

>    From: Mark Brown <broonie@kernel.org>

> but then the SPF is validated as coming from
> smtp.mail=broonie@sirena.org.uk with that as a return path:

>    Return-Path: <broonie@sirena.org.uk>

> so gmail may be dinging you for not using your real "From:". I dunno.
> Nothing else looks odd about the email.

Possibly - I've noticed the same problem myself in incoming non-upstream
mail hosted on gmail, they seem to have recently introduced new checks
there which aren't playing well with some mailing lists and e-mail
forwarding either.  For some mails it's explicitly saying that it thinks
it's forged.

Dunno if the fact that one of the VMs that handles my outgoing mail is
now in Japan (so I can have something a bit less laggy when I travel in
Asia) is hurting too but that'd be a bit odd.

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4VmXAAoJELSic+t+oim9PIgP/3wcQ/KCi2aDxAkzosX1XUQa
kxjWPWg1AHa9pyq/uVQMMW2oC7bj0Ou9tuLoJl0uTAMxWsyrCgFO/OreheJmo6ha
PX5bhR2Gi2VuFUvZqchRR+aQIth8zg8Eg5+e5NbsF8TAkfn5qlpoXlAA4+3tIgAz
HuJK0o6R2CEyaSLvPLJqZjLG70S5rYYvZdmxPCV2VW153wXGqPobapEaoUw7kWGG
JLqIcYzjCa4T0x/YXA6d6YQOTwuikk9joczAd6+KOo7IhMNT6iLPoTfJrwgW5MQi
m6BKYE9aCq6sJjQLbdsjixuxhjHuIBvgj9fjmEIj7o4asXYLN1djxrHCww10bLcD
CPkd/uMVbAFbXyGS11mT9gn8FW28P8QHm4Z8iJR3WGzeYP99pjiN3gE/r8HG/rH4
dSkN6rB6sGvBNyvXRQs6x722xUw+quVB3TA7zVcdMih76CMmNSzbCDU1S+2e19if
boW911U048qHvGKARSMtVqz2yUV1Vw7p1lTpqQt0JLqCQPyd9sxCx4tCMcFm5jGt
pOg4+RL36ZA8e19O9wB33yuHactJy+/F5vgiT2B6cJAnGcGLJIzFH89tx6JSVZd0
TJIiO1tVJxWCYobzVGVGW7kZwSWO5nKiHjFpzjT00mqJoelRprSUYMH9XJlmFkDL
ptC2U5QfMOHLwK45UzXA
=N/8A
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
