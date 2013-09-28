Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3I1M2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:28:19 -0400
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:54550 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3I1M2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:28:16 -0400
X-Greylist: delayed 75285 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Sep 2013 08:28:16 EDT
Message-ID: <1380371282.1300.11.camel@scapa>
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
Date: Sat, 28 Sep 2013 14:28:02 +0200
In-Reply-To: <20130927180516.GC4140@khazad-dum.debian.net>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
	 <1380016052-15315-5-git-send-email-aaron.lu@intel.com>
	 <20130927152035.GB4140@khazad-dum.debian.net>
	 <1380295986.16310.19.camel@scapa>
	 <20130927180516.GC4140@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-BcvpZRNaUsmRVhqK2bav"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BcvpZRNaUsmRVhqK2bav
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On ven., 2013-09-27 at 15:05 -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 27 Sep 2013, Yves-Alexis Perez wrote:
> > On ven., 2013-09-27 at 12:20 -0300, Henrique de Moraes Holschuh wrote:
> > > Some testing on a *60 (T60,X60...) would also be best, I cannot test
> > > this on
> > > my T43.
> > >=20
> > > Anyway, the code itself looks fine, so:
> >=20
> > I can test on T61, would that help?
>=20
> I think so.
>=20
Ok, just tested on my T61 with Intel graphics.

I've checked that on Linux 3.12
(6cac446bd37d9381815fe4c2b0e7b1fd1085000c), brightness keys work fine
like they do in 3.2.

Then I've applied the patchset. The brightness keys still work, I still
have 16 levels.

Regards,
--=20
Yves-Alexis

--=-BcvpZRNaUsmRVhqK2bav
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQEcBAABCAAGBQJSRstSAAoJEG3bU/KmdcClWmAH/RTdN6DO3HksGNFlpmalTdNX
Ukg0YqIE96PKfcdeZYafqbarZAM5+7x9bGdJ1dSZQl0SBKaqvRG7uUsJxuVYiyq6
eZWj8XPXM5w6TC8KlOxMc5zuITG2IhdPEc9geQsWpnHyh5ii0gef4LTQ91Pr4QKJ
6CYqW6iZjY9Ld59CvW0A1eWJNeqy6GIH8ZTTe22nkw8OLLqHGkmToYTsx1Gxk7Ei
dO2I75Zazit80qsKJbFQsyekkMJUVP7kBOpVZSNcxCijvJDuCqYjeIGk1nz+MfF/
mpafIzt+6PEX22veTEfIGg1i+FQmBkFONzsXf9OiE3nbTUuyWgsQ6oitpnKR7YI=
=tIPT
-----END PGP SIGNATURE-----

--=-BcvpZRNaUsmRVhqK2bav--
