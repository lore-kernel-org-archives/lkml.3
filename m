Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3GOUQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:16:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39008 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3GOUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:16:06 -0400
Date: Mon, 15 Jul 2013 21:15:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20130715201538.GE11538@sirena.org.uk>
References: <1373917517.17876.193.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zljh9u/ceMLi+8mf"
Content-Disposition: inline
In-Reply-To: <1373917517.17876.193.camel@gandalf.local.home>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zljh9u/ceMLi+8mf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2013 at 03:45:17PM -0400, Steven Rostedt wrote:

> Have Greg, or whoever, change his script to not take commits marked for
> stable, but instead, forward the commit to the maintainer. Or as it
> already does today, to everyone on the Cc, and -by: tags. Change the
> script from being "stable review" to say "Look to see what you want, and
> resend what is needed for stable".

This sounds fairly close what James was suggesting, though with central
automation of the mail it out stage.

> Then the maintainer needs to look at all the patches that were marked
> for stable, and resend them to Greg saying which ones should go into
> stable.

One thing I don't particularly like about this is having to resend the
patches in response to mail; it seems cumbersome to do that rather than
reply to mail or something.  Requiring a positive acknowledgement or
action seems useful but the particular one seems a bit annoying; I'd
rather either just send the patch as part of the mark for stable
workflow or ack something in mail.

> Also, we could mandate that the maintainers do the backports too.

That's what happens already isn't it?

--Zljh9u/ceMLi+8mf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5FhmAAoJELSic+t+oim9b8MP/0/FN3ADnlU11gziqgq7dM15
sNElUix9h2yiPeBl9Uh3nJYOBMM2Ul4GMDaHRL9dmgnq/mqBH5muHi5dsyiuh8zs
Te88zYi8Y4kTOJBnlt8wm7gf5W6McR1yF0CFAOv4/tttWrWgOjPWGnAG3KH6bvcN
gpWXyeb+YlRAwcv8QMfH5x90R5UPgF3dcEx3XzirO5rnpr1rcgSM4s5VhjJEMoeb
ibqv/iU4yKaG56RGpX3j42/1z1QSkJAnITWHi1MhFe/Qzjnwbm+4scfHF7dWd47r
oczupTRpJggLCo0i4yco7Puw4lIwwBATBDpgIO14SKndOgl8xXe+kMUDq0p7HjGp
MDccOzkTZqVSOsef6wJWCPEorSXdl1624epXJT1WmSF5ts0C9aW+sgO2hTpiS6j+
PvLD3oPuDWuaPKnTwkHTEZFrrXOlQTLgdoczFyN3+B2yS/0KLjO/zGqSxEW4lFHu
TP1b+L8KaPgWsElmnIhxdvyLGUH+iDRS/ihXPrgWIrkTcnEbWABj4cMwhfXj8cDJ
h/343AUllG9Vk9+bJGvbPxf/uLPzJgRgdhVPVkwRhXe92QlgfkY0WPgkm+tyOzFG
msqp9lMRAz1xcgla4Ed8fhLYK2bWYsNN09iVAvZojQfYizJ9eqPg6VxSjV15XaqJ
abMPYu5OmrPOstNGB1I4
=zcw4
-----END PGP SIGNATURE-----

--Zljh9u/ceMLi+8mf--
