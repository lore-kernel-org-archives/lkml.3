Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3GPClh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:41:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39523 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349Ab3GPClg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:41:36 -0400
Message-ID: <1373942486.31067.122.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 16 Jul 2013 03:41:26 +0100
In-Reply-To: <1373940594.17876.241.camel@gandalf.local.home>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com>
	 <1373925699.17876.218.camel@gandalf.local.home>
	 <20130716000623.GB26261@kroah.com>
	 <1373940594.17876.241.camel@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pX5aQhEDkpmI3F/lbh8R"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pX5aQhEDkpmI3F/lbh8R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-07-15 at 22:09 -0400, Steven Rostedt wrote:
[...]=20
> > > How important is the stable releases? Are maintainers willing to do a
> > > little more work now to make sure their subsystems work fine in older
> > > kernels? This isn't the same stable as it was 8 years ago.
> >=20
> > And that annoys the hell out of some Linux companies who feel that the
> > stable kernels compete with them.  So people working for those companie=
s
> > might not get as much help with doing any additional work for stable
> > kernel releases (this is not just idle gossip, I've heard it directly
> > from management's mouths.)
>=20
> Hmm, this is new to me. Really, I thought the whole point of the stable
> releases was to help Linux companies.
[...]

I also heard some managers decided their kernel source packages should
have all the patches squashed together to make them harder to cherry-
pick... could it have been the same company?

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-pX5aQhEDkpmI3F/lbh8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeSy1ue/yOyVhhEJAQqRag//Yk4A64nhKIzzSNibQ6VKrTKJSZ6nR22y
SoIPwkAfulgmPiBdrYZcsorezK+jWiFtCa4bQD3EZCb04pUiughPdGlJI9OHJ0KI
RGBNkCu9Ka5g2/ojrrhtcgsrgimLj52mhCcr0ASwknwkcHVS8nQ9e3ktUp8nvgRt
AD8m5SGSWB+D+LtyGTJ5mANhZanV8JkPgpqz8RL3Bk4MnqOK6fdhyLk2irW4eBvb
anqRZyOucBBksmvYzcQA3DF7Ru51XXQfcVC0XTj4nU/Ca7V2Xv3I4owezpmEf/tH
m8pmZ1ZQxarBGH3i7+3fSGG88SA9tb5KT9Dse0Kj1r0kiTXANsg5ceFDp8yvluIO
6XYRWF6VAC7h/34Y10INGvejj9Rea8fjPHpFp5LBwdnGkDns48CFd995W5js1GA4
pV8u9JsoM2KRwOLrWthdEvxxnYvecltlGU+njG6BSL6Qb/rXQSvA7upvk26tUW/x
69K6zR9wm2jV/1I6mICgG6wK40VdmmG48NFbzju5sqt92FkJLO8tNiqZUYjx2v3v
imuZoUEctjfG5Nq3PekloK/umjo7gP+1JA5gGjM0BkXuKWPXsCdY/bEdSQrwOoye
QJynuQ0MR8t37cJcoER2YWA0rwTJ00pmF98Pe6+RA9OrTXWVDGVcTioaexq2+JCx
YTNFKrwMNFM=
=gAU+
-----END PGP SIGNATURE-----

--=-pX5aQhEDkpmI3F/lbh8R--
