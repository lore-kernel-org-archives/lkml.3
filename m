Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbbARN5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 08:57:09 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:50561 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbARN5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 08:57:06 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Date: Sun, 18 Jan 2015 16:57:01 +0300
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Matt Roper <matthew.d.roper@intel.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Thierry Reding <treding@nvidia.com>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Sagar Kamble <sagar.a.kamble@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [BUG, bisect] drm/i915: mouse pointer lags and overshoots
Message-ID: <20150118135701.GA3114@yulia-desktop>
Mail-Followup-To: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>,
	Jeremiah Mahler <jmmahler@gmail.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel.vetter@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	Alex Deucher <alexander.deucher@amd.com>,
	Thierry Reding <treding@nvidia.com>,
	Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
	Sagar Kamble <sagar.a.kamble@intel.com>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20150117100635.GA1281@hudson.localdomain>
X-PGP-Key: fp="21AF 2E6F 04EC 7E11 21C6  E399 2236 2F26 57A3 AEAD";
 id="0x57A3AEAD";
 get=<hkp://pgp.mit.edu/pks/lookup?search=0x22362F2657A3AEAD&op=get>;
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Since next-20150113 appears problem with very slow mouse cursor. This
makes desktop almost unusable. I've just bisected the problem to the same
commit ea2c67bb4affa drm/i915: Move to atomic plane helpers (v9), as
Jeremiah did.

I want just confirm that problem too.

--=20
Best regards,
Andrey Skvortsov

Secure e-mail with gnupg: See http://www.gnupg.org/
PGP Key ID: 0x57A3AEAD



--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJUu7utAAoJEAF8y6L1SLCtmjsP/3h94mfXDaop9ias6YD7blYT
OupkTMFHwGNJ4DkKV1s/M5rA7pW3BtnoJiDN+dSazklp9GtRhCf/faX/mPIznvjH
A7FVEsZr55YsYrrevRdkromwstoBoxNiBLLfyPalrjwRN4Bo1HdPQXaGeiKyYCy6
0Uyqm62KS7dsL/Yf2TBd4FDtR6QWEeU+/S0L+mfD5TmymGil5ccIXbqzSY6+FndZ
p/v87kBIw5Bwtr359Q3GkLnuaWsNIoX99kPcmJG6/6/DbKPOyaVchIXDPW4uigIo
6EnFptAfBCtJiT0wWWUe8IPJx9UMLttMxIIcBVCkq0DGK1P1Igd33qo+QCanUBz+
a3utfJWYtjF4c1w4OPmAw53eV8oNht5O27d0veVWSCZTBicaZA1sT3XHGRY69nmt
Pb760YTrKnP4HWfMvlpoEFkmalwCrGOtlTCa+ysy+bQ/rfY//ybGRestyPCQ7ruX
lQ3aqmKA7e1quD9qb0afuTghUSOlCDTk52tKWGTsznPWTpaAhV85QTIx1L5dbLa1
oTnKD3945XjTi+0egTvl51EYLDnHlV7T7S5nbHMEJQE2had+TSCOHILjR7Pmp2RY
FXACrsjkQl4+LO/HZoyTREAqQaGAqAuofFhXywknrsqL7Udd3KZUdxd4xRE45VvF
UoL6Cu68waeGeTwuKzyZ
=dbG7
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
