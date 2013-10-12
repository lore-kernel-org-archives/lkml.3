Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3JLGAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:00:31 -0400
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:59357 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3JLGA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:00:29 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Oct 2013 02:00:29 EDT
Message-ID: <1381557623.3261.69.camel@scapa>
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
Date: Sat, 12 Oct 2013 08:00:23 +0200
In-Reply-To: <1712683.D4Gy4SDE7p@vostro.rjw.lan>
References: <1381498066-16011-1-git-send-email-aaron.lu@intel.com>
	 <CA+5PVA5RfbJjLaZNDN81tvWYhm1pLuu9OpMTwMfUpC4ma4ac4A@mail.gmail.com>
	 <1712683.D4Gy4SDE7p@vostro.rjw.lan>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-hk57K5Ex5bD5LhQDByw5"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hk57K5Ex5bD5LhQDByw5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On sam., 2013-10-12 at 00:10 +0200, Rafael J. Wysocki wrote:
> On Friday, October 11, 2013 12:42:43 PM Josh Boyer wrote:
> > On Fri, Oct 11, 2013 at 9:27 AM, Aaron Lu <aaron.lu@intel.com> wrote:
> > > v5:
> > > 1 Introduce video.use_native_backlight module parameter and set its
> > >   value to false by default as suggested by Rafael. For Win8 systems
> > >   which have broken ACPI video backlight control, the parameter can b=
e
> > >   set to 1 in kernel cmdline to skip registering ACPI video's backlig=
ht
> > >   interface. Due to this change, the acpi_video_verify_backlight_supp=
ort
> > >   is moved from video_detect.c to video.c - patch 3/4;
> >=20
> > That's a fairly untenable position for distro kernels to be in.  They
> > now have to ask every user that reports an issue with the backlight to
> > try setting that option on the command line.  While I appreciate the
> > setting breaks things for some people, doesn't the Win8 issue impact
> > far more people?  Shouldn't it be defaulted to true?
>=20
> Well, we have a rule in the kernel not to introduce regressions for users=
 even
> if they are minority.

Well, for some users, the regression actually happened when support for
Win8 OSI call was introduced.

Regards,
--=20
Yves-Alexis

--=-hk57K5Ex5bD5LhQDByw5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAABCAAGBQJSWOV3AAoJEG3bU/KmdcClCvwH/i78Wc1sG+ChWdsYJw3TLfzQ
MnyOfElTe2YqEc49bQ8/lwbBBaCInE7Og//SSGLE6bNeS2y6UTGyRWhqTA9WQ6tb
3Y4fWvk7l5qtB1SsaT3s+TxSIICscrU6QWB1R7TXiIOOZweDH6nKMt6EJcqNjpIQ
QU2Hp3tthcJlOnAzTMDTsxv/sibLvnGlcHJEFnr1Dxcr1et59HeDiYFRbexcaO1j
PGjt28NY1I4NokWCe+Y1iVPfE/bQH6MaVhmalVarIya/0QFR/C+zbEmatyiykec6
EVWxQ4dRAUWbnp8IXt97+UsTGY5gaVL0KsIq2qyBLNEX6vWqBD1fA+mehy87kXE=
=XicM
-----END PGP SIGNATURE-----

--=-hk57K5Ex5bD5LhQDByw5--
