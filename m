Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3LaL7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 06:59:54 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58931 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3LaL7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:59:52 -0500
Date: Tue, 31 Dec 2013 11:59:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131231115927.GK31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s6Wo+7iKhEdF4/RK"
Content-Disposition: inline
In-Reply-To: <20131231113138.102044cf@armhf>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: generic: add generic compound card with DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s6Wo+7iKhEdF4/RK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 31, 2013 at 11:31:38AM +0100, Jean-Francois Moine wrote:

> This code was first developped on the generic simple card, but its
> recent DT extension cannot be easily extended again to support compound
> cards as the one in the Cubox.

It would have been useful to have provided that feedback at the time
rather than waiting until after it had been merged - it was in review
for long enough.  It would also be good to articulate the issues with
the binding rather than simply stating they exist, and to consider
adding a second binding to the existing generic card rather than adding
a totally new card.

Please also remember that all DT patches need to be reviewed by the DT
people, you've not CCed either them or the list.

> +  - front-end or back-end: present if the DAI link describes resp.
> +		a front-end CPU DAI or a back-end CODEC DAI

These are Linux-internal concepts which shouldn't appear in a DT binding
or at the very least need definition.  One thing to consider here is
that these things are all about the internals of a SoC and you'd
therefore expect that they would be defined separately from the card so
as to avoid having to replicate information in every card using a given
SoC.

--s6Wo+7iKhEdF4/RK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwrGcAAoJELSic+t+oim9NtcQAIik0Lm39Fm2rP9B8nJABjMT
6o4893uefb8pmXUOEyExafaqFFUUs0hRRMQxzVD6CwAiQMnssE9wAl42phtERtoW
Rygvz9XHjWyEvUxkk7JUkplMdI5Vs1kMqvnc5XZEq7tEG6yCsQchbGwo8Xbk1qn5
LcqLCy/6EA7wmDv6BNHb0D3i8HXFOCkf37EYGjFVOjbZutn2MEAfV7th2rjra4lg
uWnWEwL+b8+ZFnYddPCRjFzG6j7XjSAnMSuMbOYRblJs4eKEcJvsUOWOVJHRBoi+
BiZP5rZf5QFpzd9/jsD2W4N75rB5QYwDHGuFcIWVDoIG+IfGP9pbU1/k6FG9aUkG
4kORL+tUk+ROS0aiZ+vKuesmF7/+pucMj2SRRkHXC8iMdUh3VHaKnQFdTJBEyYBD
9K3XpeAGd9yXvPiJEDMe+psf7H8fnYXG51FDsQbA8OOzeqo9S1jftVVsb3itLt79
D52FbL6hmtFKvf0aDPv2FkBHfjyVA+kf2X74S+hqQy6shZy3Atxw4iv1FXXtBO3n
8w9hUZQQdIHpJQSmLSja43fyOC4HXIogJVetXoRqcHVx/Um+n6CM/mk9dBxU+q02
aAYZ8RTuLkQaSLdfRlPlaKogG8LFdQ+a/nd/q63VCMdGQRck43bf9BQD4Gx38jbL
6xDKvq06JpDycUWNH3me
=Ewah
-----END PGP SIGNATURE-----

--s6Wo+7iKhEdF4/RK--
