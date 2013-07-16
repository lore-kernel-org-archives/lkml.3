Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3GPJyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:54:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46164 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3GPJyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:54:21 -0400
Date: Tue, 16 Jul 2013 10:53:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20130716095353.GC22506@sirena.org.uk>
References: <1373916476.2748.69.camel@dabdike>
 <1373940029.31067.99.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <1373940029.31067.99.camel@deadeye.wl.decadent.org.uk>
X-Cookie: Many pages make a thick book.
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


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2013 at 03:00:29AM +0100, Ben Hutchings wrote:
> On Mon, 2013-07-15 at 23:27 +0400, James Bottomley wrote:

> > The problem, as Ji=C5=99=C3=AD Kosina put is succinctly is that the dis=
tributions
> > are finding stable less useful because it contains to much stuff they'd
> > classify as not stable material.

> Well, some distributions may find that.  Some distribution maintainers
> have taken on stable branches, officially or otherwise - Steven Rostedt
> (MRG), several Ubuntu developers, and myself (Debian), and of course
> Greg was working for SUSE not so long ago.

There's going to be people using it via the stable kernels from Linaro
too soon (mostly underlying distros provided by silicon vendors for
embedded systems in the first instance).

> ...but this is important.  Also, I'm not convinced that the current
> standard review period (48 hours starting whenever) is really long
> enough.  Especially when there can be 4 large series at once (for 3.0,
> 3.4, 3.latest-1 and 3.latest) or even more if other stable maintainers
> start overlapping reviews.

I definitely agree with this, it can be a bit of a DoS when things are
busy.

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5RguAAoJELSic+t+oim9LPoQAI7oyUSJfrWme3BivLl4/rdj
rkz9A9g+yqziuFFqpc+Q+I0RvDoxpYIhYThlKwdVb/34BWk+u8rBIQU/IveKJ6rs
kkp4bkdDE/dPj5nje+V32Bbaw81SHPqVyg27BE/EgYOYF41EKyQjxNx7ohmJSIJ2
RS3rqf8bH/SCjqY+iJ9dNZuobJAvxNwA2nmeK6XsAMfGto7y9xB558klL9KKFJhH
rB6BiZp30bA9ucUZg7jCWI78Je1fAX1GrvMebzct0xt0kaiCpOmvWgW7+4MU4E4d
VrgV4NoF01GgmOtuB8QRsVKj+8AECgwSKi7Jd6jePWUVoHJdzZdQOJQK8WKORlKW
zM17+Mk5fJynzdmphDJbFjXpMZkw83IUt2eEe4giTUzCEtZWx0agS712oUGtfE4n
lH1dDbttFoZrIf/NJ0Z2Gsshyq/quaDITM/2UFG1BjQhnAlnOhbk11SlnnaBzr+5
jXSbYubPSGPhsmTnw7EN86/y7iDgHvzJk0w4YlwoAi0zs9vx8Y+oc2u7IIksBU3P
+v017mLte5aRhKOMX9+jBEUSxkVGtjKsuwlmW2KbryTbCrZ7EreN5/TN17ev2wff
s8NkY2C01R/JjZDuaiIzqZdVAuf7p62dlNhSyS0P+kxD0vArpLZI3HW5DpeYJGBq
zBkO4cWnXbki9INLwquD
=NHuC
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
