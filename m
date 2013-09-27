Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3I0PfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:35:00 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:51976 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3I0Pe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:34:56 -0400
Message-ID: <1380295986.16310.19.camel@scapa>
Subject: Re: [PATCH v3 4/4] thinkpad-acpi: fix handle locate for video and
 query of _BCL
From: Yves-Alexis Perez <corsac@debian.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Aaron Lu <aaron.lu@intel.com>, linux-acpi@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Date: Fri, 27 Sep 2013 17:33:06 +0200
In-Reply-To: <20130927152035.GB4140@khazad-dum.debian.net>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
	 <1380016052-15315-5-git-send-email-aaron.lu@intel.com>
	 <20130927152035.GB4140@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-+j8p4duVHF2ZP2+D9Bhc"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+j8p4duVHF2ZP2+D9Bhc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On ven., 2013-09-27 at 12:20 -0300, Henrique de Moraes Holschuh wrote:
> Some testing on a *60 (T60,X60...) would also be best, I cannot test
> this on
> my T43.
>=20
> Anyway, the code itself looks fine, so:

I can test on T61, would that help?

Regards,
--=20
Yves-Alexis

--=-+j8p4duVHF2ZP2+D9Bhc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQEcBAABCAAGBQJSRaUyAAoJEG3bU/KmdcClGfcH/ilpwErStr6ZuonaoV7Vv4Po
auEw+jydVdKblf9SM9cjPI9wuwAweuLF4GJ523iroaddx23zWYe6myH3kygGmUa8
sMU94IS/RgT93zJNdDbHLB7S0wPmq7P33TffVk4v/hhtEll/GqKyvJ1ihsvQYh0U
iw3ABOG4g4IzOxAsSEFoOGzHFMp9ltYuh3JNmh4gG0vPtGbaTyslsRpZqqfi5LK4
2zfZXKcOE8EeWK+CC3sgyM96cHcZNlbw9FC3IHThaPy30aVF4OHQl6r6e1Ug6RyR
9FxDId5db1m2kYVuDweFeO9fI3axgMAE39ztTM2MO8Fhhb8z4U9SW0qBLdKGZgs=
=u2bI
-----END PGP SIGNATURE-----

--=-+j8p4duVHF2ZP2+D9Bhc--
