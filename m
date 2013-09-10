Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3IJAEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:04:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab3IJAEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:04:33 -0400
Date: Tue, 10 Sep 2013 10:04:21 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Hilman <khilman@linaro.org>, ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 0/3] ARM: SoC: Second round of changes for v3.12
Message-ID: <20130910100421.5c481df0@notabene.brown>
In-Reply-To: <CA+55aFxNbH+G6DVQNxE9di_btA5hxFH93af_vjN2v0eH8e5W-g@mail.gmail.com>
References: <1378766555-9679-1-git-send-email-khilman@linaro.org>
	<CA+55aFxNbH+G6DVQNxE9di_btA5hxFH93af_vjN2v0eH8e5W-g@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Pe=dWOO=+62hr3+YD0yM_2Q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Pe=dWOO=+62hr3+YD0yM_2Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Sep 2013 16:49:23 -0700 Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> On Mon, Sep 9, 2013 at 3:42 PM, Kevin Hilman <khilman@linaro.org> wrote:
> >
> > The main thing of note (or of potential annoyance factor) here is the
> > handful of conflicts in PULL 2/3 coming from platform changes
> > conflicting with driver changes going in to the V4L tree.  I've listed
> > them in detail in that pull request, and we will work with the
> > platform maintainer on the workflow to avoid this in the future.
>=20
> Ok. I still really despise the absolute incredible sh*t that is
> non-discoverable buses, and I hope that ARM SoC hardware designers all
> die in some incredibly painful accident.  DT only does so much.
>=20
> So if you see any, send them my love, and possibly puncture the
> brake-lines on their car and put a little surprise in their coffee,
> ok?

As you wish.


--Sig_/Pe=dWOO=+62hr3+YD0yM_2Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi5iBTnsnt1WYoG5AQJlOA/9G2a1qgT65vzTZy8Py+2zuibq6kgC1R3b
m8gA8nRD447dASXCqmQxA3jIGgmqnxLGfb2G4YFLMg6uuJFerzFXo9ivnySLF2JG
lzWEp1AQtGs32SmHRCsxyfZnvRwZymHoZBgm4lVCSzNlH8m2iDoEWpDCOtLXlQae
e1zNHHFSQu/Pxhz5H8yx5FHSe4nPuideRuQsTii3h0UsW7uRsfOAGAV5VXu/lGly
MitHnOrO9HK+9UZyDh8AV2tu+8HRZVGbsBAVL36F5Uzv91vUgrDiJW2fwqTV6St3
4DtgLWS+E4nyGW+UTGj1V/3773clOZFGa7Ww6RF6bqTDxgls5w2Dx3fkyDjzZUCc
YNWz0vdjEoNU2PMxm0afej3t13phukxI7mH5FZVmQe4aqlptBL1QlHBEelZkqIoH
9Qbz+QYKTRRUgDp2Jsv9KXM6mSOvoozbml5eO2xMHJ7dyXCASLIopLJOtZAy/qLn
0+9JO2gW7S27jtkwqPsQwOrJchFzqUj85ktncVdNvoYL525f2kok9j7f/B9Om0bs
nUNqrI+c+xnxk+KORdlfs6gnonh0Tj10xtGBVNgugADKSeS0LQbpjGhbogRvyN6N
HrfzLYXtwoxWyLU4VtdESobKvJ5CF7AfCR3W5HEXB//7C0+n75VLaN0UVTD4IPJ4
vsBjuBCp/Zw=
=rVBC
-----END PGP SIGNATURE-----

--Sig_/Pe=dWOO=+62hr3+YD0yM_2Q--
