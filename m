Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaLRTGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:06:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35872 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaLRTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:06:07 -0500
Date: Thu, 18 Dec 2014 19:05:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kevin Cernekee <cernekee@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        gnomes@lxorguk.ukuu.org.uk, Brian Norris <computersforpeace@gmail.com>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141218190528.GB11764@sirena.org.uk>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
 <20141216130939.166c4369@lwn.net>
 <CAJiQ=7B76vE2ctYd2GK5+_whNnLGKtUY65qkMLdewBqfO7HfPg@mail.gmail.com>
 <20141216223133.GB5656@pd.tnic>
 <20141217051424.GZ17575@thunk.org>
 <20141217095227.GA8457@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pc5/sMjAdU99/gPV"
Content-Disposition: inline
In-Reply-To: <20141217095227.GA8457@pd.tnic>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 0/4] Stop maintainer abuse
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pc5/sMjAdU99/gPV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2014 at 10:52:27AM +0100, Borislav Petkov wrote:
> On Wed, Dec 17, 2014 at 12:14:24AM -0500, Theodore Ts'o wrote:

> >  And what's wrong for one maintainer will be right for another, and
> > vice versa.

> Ok, so what's wrong with "should not expect any feedback during the
> merge window"?

AFAICT the original complaint wasn't about people expecting feedback
during the merge window, it was about people sending things at all which
is a different thing.

> And besides, when one starts working with maintainers, one soon learns
> when they are the busiest and can refrain from sending patchsets then.

Or if that even makes a difference of course.

> I see your point that different maintainers can be busy at different
> times but you also have to acknowledge the desire of some maintainers
> not to get new patchsets during the merge window. So we have to have a
> way to communicate that to submitters so that no explosions happen.

I think it's important to be clear what we're talking about when we
advise people; the advice about allowing for people being busy or
otherwise unavailable applies pretty much all the time - one of the most
common process problems I see is people expecting quick turnaround
times, it'd be really good to set expecations there and it seems hard to
go wrong.

Not posting at all is a bit different, though, and is much more
maintainer specific - personally I'm in the opposite camp to Thomas and
would rather people just sent things whenever so I can get round to them
as I have time rather than getting everyone sending things at once.

--pc5/sMjAdU99/gPV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUkyV3AAoJECTWi3JdVIfQRz8H/ilblhNTggFSeu1jyU947KT3
/+5j+9odzsyYk33nYgTiAxqExaCrEDaTNGsjhdjmLEgv6uc1maQpQTGtsdpHHyrs
jrWGd9aACed0WuDB6YDyfRKtx9IB9dWgkBdkoj/quP5rqHXX1gObLZTJf33wm8Yy
vTolNI60ciiL3Ze9KwApOu7Fg+IqiE4ZLWfiZ7cAAkzuH5KpmwoCMO/JZ5uW21/V
Qlfw0aWa5f1wDa0b3kg3b/9p5eGa0LSYJCOI7DfG6AiIya0BOWA/Vz8u2dJHVVbT
g1WjAORBJlpFNfzozRSs2Z8yAoMisiimqWod6bgecUa0H9WDQqwNfqOgsTGkLXY=
=QGuF
-----END PGP SIGNATURE-----

--pc5/sMjAdU99/gPV--
