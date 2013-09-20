Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3ITNCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:02:43 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:60546 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab3ITNCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:02:41 -0400
Message-ID: <1379682099.9746.5.camel@oban>
Subject: Re: [PATCH v2 2/3] ACPI / video: seperate backlight control and
 event interface
From: Yves-Alexis Perez <corsac@debian.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Fri, 20 Sep 2013 15:01:39 +0200
In-Reply-To: <1379409796-29350-3-git-send-email-aaron.lu@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	 <1379409796-29350-3-git-send-email-aaron.lu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-f7eTPuUuyk+b0QmhFQTv"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f7eTPuUuyk+b0QmhFQTv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2013-09-17 at 17:23 +0800, Aaron Lu wrote:
> The backlight control and event delivery functionality provided by
> ACPI
> video module is mixed together and registered all during video device
> enumeration time. As a result, the two functionality are also removed
> together on module unload time or by the acpi_video_unregister
> function.
> The two functionalities are actually independent and one may be useful
> while the other one may be broken, so it is desirable to seperate the
> two functionalities such that it is clear and easy to disable one
> functionality without affecting the other one.
>=20
> APIs to selectively remove backlight control interface and/or event
> delivery functionality can be easily added once needed.
>=20
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Yves-Alexis Perez <corsac@debian.org>
--=20
Yves-Alexis

--=-f7eTPuUuyk+b0QmhFQTv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABCAAGBQJSPEczAAoJEG3bU/KmdcClY8AIAKONX1Vy4r/BxLo1L6CMqbt2
S1d4Mdkhua5mejGYSdYLWdQku554nJpnQ4uSWAHwuJNW21i4GqNhqsNzlADYIYba
KxHtQnL8K2GOaVLMQHf+2O4i1lmWc/yvvOcLGEktGnUHYYCxOJBCTwCuzHuFG14E
XUngsESoWgBrrJGrzL/k9i8CmdtzjMase9wJOU73rT1ujme746qYyF8rLfw7BFOt
2l+PLBwNvTNslu71s5WnUnG/si7HpanSPZhoR/60bbxUNUx/KFhHVFQV4s8EvC+J
yIK50jfNnx+o5iO9lVyLIzcDRzlhDqVvsvMRQXEyK+j5y1/9cSX/LWjmN5ya+Go=
=juvk
-----END PGP SIGNATURE-----

--=-f7eTPuUuyk+b0QmhFQTv--

