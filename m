Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab3AMFeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 00:34:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58411 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851Ab3AMFep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 00:34:45 -0500
Message-ID: <1358055265.4514.67.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Oops on aoe module removal
From: Ben Hutchings <ben@decadent.org.uk>
To: Ed Cashin <ecashin@coraid.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Josh Boyer <jwboyer@redhat.com>,
        "mitko@banksoft-bg.com" <mitko@banksoft-bg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fedoraproject.org" <kernel-team@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Sun, 13 Jan 2013 05:34:25 +0000
In-Reply-To: <A7C5A7B8-6494-4D9D-B052-5C623E066985@coraid.com>
References: <20130103132556.GA13290@hansolo.jdub.homelinux.org>
	 <587E85C3-7395-4BC1-B31B-426572B5080C@coraid.com>
	 <50E5910E.7060606@kernel.dk> <50E591CD.40802@kernel.dk>
	 <D2D8353E-8DE1-44A2-BB7F-3FE1E2E794FB@coraid.com>
	 <50E5A51C.3030800@kernel.dk>
	 <32456405-00CA-43EC-A17A-28452C217A7F@coraid.com>
	 <ffc5cf0d1e3273770b65bc7de4a4851e@coraid.com> <50E5DFE4.5020007@kernel.dk>
	 <EE162567-A6C8-4C4E-B96F-5366C8DDDCB1@coraid.com>
	 <6333449B-1F90-4772-A04A-79E123A8A20D@coraid.com>
	 <A7C5A7B8-6494-4D9D-B052-5C623E066985@coraid.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OFZ9Y7LbVNmb9Abd8U8G"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OFZ9Y7LbVNmb9Abd8U8G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-01-03 at 15:20 -0600, Ed Cashin wrote:
> On Jan 3, 2013, at 3:50 PM, Ed Cashin wrote:
[...]
> > Kernels with aoe v47 can use the patch I just posted.
> >=20
> > I'm going to go through the stable kernels and check, but I believe ker=
nels after
> > v47 but before commit 0a41409c5180 should apply the fix in 0a41409c5180=
:
> >=20
> >  commit 0a41409c518083133e79015092585d68915865be
> >  Author: Ed Cashin <ecashin@coraid.com>
> >  Date:   Mon Dec 17 16:03:58 2012 -0800
> >=20
> >      aoe: remove vestigial request queue allocation
>=20
> ...
>=20
> OK.  Looks like 3.7.1 has aoe v50, exhibits the behavior in question, and=
 needs
> the above-mentioned commit 0a41409c5180 from Linus' tree as a fix.
>=20
> The 3.6.11 kernel has aoe v47, so it and earlier stable kernels can use t=
he patch
> I posted in this thread.
>=20
> I'm sending this to stable@vger.kernel.org to ask Greg, Ben, and other st=
able
> maintainers (where's the list of stable kernel maintainers?) ...

There is Willy Tarreau looking after 2.6.32.y, Paul Gortmaker with
2.6.34.y and unofficially Herton Ronaldo Krzesinski with 3.5.7.y.
All stable maintainers should be reading stable@vger.kernel.org anyway.

> Should I send git-generated patches to stable@vger.kernel.org based on ea=
ch
> linux-stable/linux-3.x,y branch?  There are only two cases, really: 3.7.y=
 and others.
> I suppose 3.7.y can cherry pick from the mainline.
>
> What's the best way to do this?

Given that aoe is basically unchanged between Linux 2.6.32 and 3.6 I
agree that the one patch should be sufficient.  However your previous
patch was lacking a signoff or much of a commit message, so please do
re-post it with those.  The commit message should include a reference to
the corresponding mainline commit as you identified above.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-OFZ9Y7LbVNmb9Abd8U8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPJHYee/yOyVhhEJAQonCA/9H0FkAo2TN7K4yjBZKs5QhJ1eddqybvnM
//aBzFOm9oQgTVeT7eVhVA9dDPsCe0cS9XsaKKBJOeB0EeGN4hZsiuwOP5hec37U
wiqL5vZdJF1tzQlaqA3l81GQL9V25MSr0ArN1vvgmkJUuOzjCkPPgDgwQNg/5zTa
Va2bl4ydncEI6KV2PbXar+Fgp+HdLG+wsF0SqEONB0neYYQmpoVnUauO3wW4J8a4
fp+56BpEoW1yTaj1MmswgNtdGB1uqWQO2PPnAy4vciLmOeuDYC2jeOoRZeZRpM/n
edBW65YIqHX0IRdwhidTHTizOQJfvZPxxldouuJThrBwPmkkg69SmA1rPETmY+w5
hHmPkO0QdTGaBYHylLEBJNc6HZdWsYKNZx7llPzw8Hvh8Ft+wMXCmhJ+161F1Fr/
D3RJiwx6NODth8sSq1jDkM6yWm+rE7lQnjyJm6dIwDQ9klTuY6/UP0IU2tbMm6BX
zCLM+qFOO8y/w/oPeX2maA8I5CUNFkDDV6QN4p0dKg+piq+5HQ+kmbo9zyTU89QN
nDk7dJ6P+WCgVLnRNDNvGAoOWleOXT9wS/OIhBl18Yu60e5EpZN5GRRPmYr/b9WZ
1A0xBBTjcdvWXGlh+KAiQq6SXUtCNGaUJ4Ea1DFfk8dyqy3/Ce2V20M1s/7ynnpI
KdIQzlGotOs=
=DVX4
-----END PGP SIGNATURE-----

--=-OFZ9Y7LbVNmb9Abd8U8G--
