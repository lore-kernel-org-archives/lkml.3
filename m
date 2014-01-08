Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbaAHVtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:49:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49036 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbaAHVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:49:13 -0500
Date: Wed, 8 Jan 2014 21:49:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20140108214906.GB31886@sirena.org.uk>
References: <1389201738-31406-1-git-send-email-lpapp@kde.org>
 <20140108180747.GT31886@sirena.org.uk>
 <CAOMwXhN8x0xHstrwsrxqXoE+n19TP=r1HJDCFOHs2O024HaY1w@mail.gmail.com>
 <20140108190758.GY31886@sirena.org.uk>
 <CAOMwXhMh6A8wZa3rtQHH1HpYU6PoZuWkPuSki64hOAnAZ-QZoQ@mail.gmail.com>
 <CAOMwXhNLN-gDHt=UKmmbA0VM1f6PnjcZWkZSDncemVZuxEGF1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IIbt9kHO0VqlT224"
Content-Disposition: inline
In-Reply-To: <CAOMwXhNLN-gDHt=UKmmbA0VM1f6PnjcZWkZSDncemVZuxEGF1Q@mail.gmail.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] include/linux/regmap.h: fix a couple of typos
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IIbt9kHO0VqlT224
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 08, 2014 at 09:08:44PM +0000, Laszlo Papp wrote:
> On Wed, Jan 8, 2014 at 9:02 PM, Laszlo Papp <lpapp@kde.org> wrote:

> > That being said, I will not have time, nor the motivation to argue
> > over such a nuance, so feel free to reject the change.

> Of course, this is just on top of the vim spell checker error as I
> wrote in the commit message...

> Oh yes, and one more factual data in here:

> lpapp ~/Projects/linux-staging $ grep -rn "e\.g\." . | wc -l
> 3447

> lpapp ~/Projects/linux-staging $ grep -rn " eg," | wc -l
> 18

That's not the issue - it's dropping the comma.  It's either "e.g." or
"eg", the comma is a separate thing providing a break between clauses.
Strictly it should have the periods since it is an abbreviation but
their use is more vauge in fixed point text since they look ugly, the
thing that made me complain was that you dropped the comma as well as
substituting in the expanded version.

--IIbt9kHO0VqlT224
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzcfOAAoJELSic+t+oim9dj8P/R4bwJnWypNsMgQdCbq0umYs
qvyt4jD4a+52+g6wY5S9eH19hteIvXIlEVJQQ6GETPoKNQNyy66klTw0O1bJo9uk
HA8657TERC63GxafjzrCPWXdWRWX9sV8U3dvZJfT+qqVvV8CJjkfjgmVVYkU0dO9
mgdPNyBS6z7OL/ios+3Dt8iId9kO3y0w0k0u9a2vsXJqtnoWt3JIYjvhPFS5lieJ
cw0rD+swYNrKTlgtTZYLkzgmYhctTs0/GuKinq3rRCd+yEqvX6gJihUDFYsZMMyK
lTL27/yafhnF9JDZG1z7hFsR3yG/J5Cz18g/DPAdiLV8M2XvwMKjvLXJuivcUWOk
eeUrktaMrY5ckk+r+3Q7e9ChcUj3u1Am5wIRIDnrNu/MbnvvTAG2ckuMYimIUlPH
bX7icltJn5e1T8q5lpGxgfkbMCTmyFgfQ3GNcXiqTBC7nGFoQAXtiKybXz/ZHmeA
gbo900RoSZ2qIu6BHed+DCPLN6VV17nlvAxdFL+g5Sza3Dcrr+wS2LzcagrnlUzt
kw9LLdHvG8G8SlntfXI15PWsVyp86GbftmnqWc+iIEQGyylZ7LVMtLnqYaOt+tiG
KN7AqBaw58fRTdr3lmPGtOpVQ8VmPOGhgjMhKd9c3/lU7Yp36r9vn4Aa4oVbVRJA
zN4XQN2l+Cm9R941Mt0z
=wgZj
-----END PGP SIGNATURE-----

--IIbt9kHO0VqlT224--
