Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3JLFyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 01:54:24 -0400
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:59316 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3JLFyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 01:54:21 -0400
Message-ID: <1381557246.3261.67.camel@scapa>
Subject: Re: [PATCH v5 0/4] Fix Win8 backlight issue
From: Yves-Alexis Perez <corsac@debian.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Aaron Lu <aaron.lu@intel.com>,
        linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        platform-driver-x86@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.i>
Date: Sat, 12 Oct 2013 07:54:06 +0200
In-Reply-To: <3899323.lQYrFPeQhE@vostro.rjw.lan>
References: <1381498066-16011-1-git-send-email-aaron.lu@intel.com>
	 <1712683.D4Gy4SDE7p@vostro.rjw.lan>
	 <CA+5PVA4xFQ82FdQ3RfcV4aAzZZ6onfOUWb9Z+ZFBP-Ay7sEsKQ@mail.gmail.com>
	 <3899323.lQYrFPeQhE@vostro.rjw.lan>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-6TKtBSrc+l1kgjxrG52D"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6TKtBSrc+l1kgjxrG52D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On sam., 2013-10-12 at 01:27 +0200, Rafael J. Wysocki wrote:
> If we are to use a Kconfig option, why don't we use one instead of rather=
 than
> in addition to a command line option?  Say, we have
> CONFIG_ACPI_VIDEO_WIN8_WORKAROUND and if that is set, the code will work =
like
> the previous version of the Aaron's patchset (the one without
> video.use_native_backlight)?

Doesn't this mean user will have to rebuild distro kernel in order to
test behavior?

Regards,
--=20
Yves-Alexis

--=-6TKtBSrc+l1kgjxrG52D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAABCAAGBQJSWOP+AAoJEG3bU/KmdcClKIgH/3ITxskPtsfFd2IeRadOYRB2
QX9aI3QYL8OxyHVXEmPH4W1cEbmlLBau2Sm122bkCVrAV7TOnC2vDegJwhrZLqLP
xrPEWU3OW7EajvDEIH3OgJ7SgkudnJE1z31jPY9UzlDyBBFaa3G8S9e32rcNTI9N
ToQxO3+/2pPTkm7DwissFPgOk1Te3Ipj1mFsNwV93d9tpw4k/qOkMOpmJtHxaBeL
0RLEOkrizZ9WbXsyKzIhUz03nhrMgYQn8QkNA1CWqN4zItL+Ptonv0byqtF+gN+K
Yx2OyvVKxNhJCBkeVJi9+rYwlQMxQ5piLCd7BKHdPnWuHv1BF7TNmrMXsEU+Tz8=
=DXHw
-----END PGP SIGNATURE-----

--=-6TKtBSrc+l1kgjxrG52D--
