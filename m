Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKZUek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:34:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39784 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaKZUej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:34:39 -0500
Date: Wed, 26 Nov 2014 20:32:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20141126203228.GX7712@sirena.org.uk>
References: <20141021165441.GA1619@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SAbzvNCM/REt5CdL"
Content-Disposition: inline
In-Reply-To: <20141021165441.GA1619@katana>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PULL REQUEST] remove .owner for most platform_drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SAbzvNCM/REt5CdL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 21, 2014 at 06:54:41PM +0200, Wolfram Sang wrote:

> @all: The granularity level is per-directory. Greg was okay with that, speak up
> if you strongly disagree. I am really going for consistency here, not patch
> count (and to avoid patches on per-driver level which I already got a few for
> my subsystem). Also, I have not CCed all the mailing lists, since Greg
> suggested that he'd pull this series. If people prefer, I can resend this mail
> with all lists on CC.

Not sure if it'll come up again but it is generally nicer to at least
tell the subsystem maintainers that there's a patch being sent so
they're not surprised by conflicts, especially with this sort of
stylistic change where it's not something there's been much advertisment
of.  I think there's some scripts that go along with the cocci stuff to
mail things out without needing to spam everyone in one message.

/me just ran into another conflict with this which he had to think about
so is being a bit grumpy.

--SAbzvNCM/REt5CdL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdjjcAAoJECTWi3JdVIfQKAUH/Rd80kLhVKPm/K9vk03yfI9L
fp7wE/qsfwTIvhTGm3rbTqZib0YNDjqszqbUHE1X1Wmy/+tK07Q5OWIAMcSEFANz
kjd7Y7zA2DuzebKVPn7LAds8Hm7vNVgS9X6JFLAhL31Fpt8/unGv2FR13TiS1YW9
wAGxj98Q23Y8atKIwxpQl5T3LaSx4P64rx9OBXRdvbQX/zh/zkCIByovfIuERw7F
PDdJbWktZ8OhAHsvc1/KOUX4POkVlypTa6cgWPGnCAPZtWjlBL5teYcnzPhInS/Y
ifyUaAOnEZ34K6CAGAuaBSUhQz15gNgNa6skhFIUE+PqV4P7gD3q0fY3EPHP8EA=
=E54H
-----END PGP SIGNATURE-----

--SAbzvNCM/REt5CdL--
