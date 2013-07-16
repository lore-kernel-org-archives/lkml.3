Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab3GPCaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:30:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39493 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab3GPCaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:30:12 -0400
Message-ID: <1373941801.31067.113.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 16 Jul 2013 03:30:01 +0100
In-Reply-To: <20130715214422.GA2478@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EkKYqLVjr/DKVzmxzbiH"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EkKYqLVjr/DKVzmxzbiH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-07-15 at 14:44 -0700, Greg KH wrote:
[...]
> The second one is almost always due to security issues that were unknown
> to the distro.  The announcement of security problems to the distros has
> now been addressed, and since that has changed, I haven't heard any
> problems about this.
[...]

I'm not elite enough to be on these security lists, though sometimes I
hear about embargoed issues through the Debian security team.

Anything that's being reviewed on the stable list is public.  I know
this is an old argument, but if you point out a fix you *know* has a
security impact then you'll help general distribution maintainers and
users a lot more than you help the black-hats who are quite capable of
recognising such a fix (if they haven't already spotted and exploited
the bug).

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-EkKYqLVjr/DKVzmxzbiH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeSwKee/yOyVhhEJAQpCfhAAkEeytswXz72PF2ZEJ4de0D7aSUzqkYgP
JNbEp5ejseSwLytK3qLMLy3RNPGrzrJ9gbUxNlK5P1Y0Z3EHah2Dr2cIsnR0A9Ya
iv94Vv55ouHy88dbUzbSddIjRT8D4kHG/ovOejWTnK3lHArKQtvoEifzOqzn8J/9
AuHnqg+hHU6HKOXeu13xnq+I/RjLkSUClP45ddSxc3MvhvueZUTnqeDvUMf7TpgJ
WCvgcP2C9el3+tY48rfn0GM2TzVYjhrM1ZhK2UCQCPksbA/Qiwg6x5arP9DKJmZt
Ijlmq/Wpu0peju+am/Vng8ocnnASVUFqlWYK5+VXoJf82fmWAB1MdAjE7/2KpCMc
4X3rIhAYn/zCMANrmZp2ccZ5xGf7yUklYlL1F5OyF7FOpQxuNl3gWFkVFcHfi9A5
2/FcCSPWBxWuG+humNweRfZONMpq7xS3pAxOMDXXoNvMJnwsKVVcE+Dmte020Vj4
uRftgqqrjGwT3tUFBCrB7pkYqp4XVjyU0noCOuSSjtHsw6MjRS1e+JvEtHZYXtVS
1Zbb3k6ir083xQ/Dwzp6dj2S6q6zaR6HDHDy+gYlPSR5XIi6hbj5Qakfak34W6Kk
oaw2BW0bNVvAnBpZwR6k8n9N3ys1U5YHxIj4mWle5+o4gwOHw8i5u0j8SKYuZUxR
NjGFkqbZBek=
=CYMM
-----END PGP SIGNATURE-----

--=-EkKYqLVjr/DKVzmxzbiH--
