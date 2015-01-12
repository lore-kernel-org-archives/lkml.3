Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbALR2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:28:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35337 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbbALR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:28:19 -0500
Message-ID: <1421083682.19708.76.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16.y-ckt 030/168] drm/i915: Handle failure to kick out
 a conflicting fb driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        "Nikula, Jani" <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Date: Mon, 12 Jan 2015 17:28:02 +0000
In-Reply-To: <CAKMK7uFDS339qaqaNeRJ-L+XXKBaS8CgDY1CzEB7ugDmOto+Dw@mail.gmail.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
	 <1418653622-21105-31-git-send-email-luis.henriques@canonical.com>
	 <1421012945.19708.27.camel@decadent.org.uk>
	 <CAKMK7uFDS339qaqaNeRJ-L+XXKBaS8CgDY1CzEB7ugDmOto+Dw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gLVVChWCAcLfyoLvATah"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gLVVChWCAcLfyoLvATah
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-12 at 18:20 +0100, Daniel Vetter wrote:
> On Sun, Jan 11, 2015 at 10:49 PM, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> > On Mon, 2014-12-15 at 14:24 +0000, Luis Henriques wrote:
> >> 3.16.7-ckt3 -stable review patch.  If anyone has any objections, pleas=
e let me know.
> >>
> >> ------------------
> >>
> >> From: Chris Wilson <chris@chris-wilson.co.uk>
> >>
> >> commit f96de58fc7e7d3d717c7c63975c3b896c906b5e3 upstream.
> >>
> >> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> >> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> >
> > Should this also be applied to any older stable branches?
> >
> > i915_kick_out_firmware_fb() was introduced in 3.6 and it has always bee=
n
> > possible for the alloc_apertures() call to fail.
> >
> > remove_conflicting_framebuffers() has returned an error code since 3.14
> > (but could silently fail before then!) so this should be applicable to
> > the 3.14 stable branch too.
>=20
> tbh I don't know why this patch ended up in a stable kernel, at least
> I didn't find anything where we (drm/i915 maintainers) marked it as
> such. And there's no bugzilla references added either. Imo the patch
> doesn't qualify for stable (it's not a real-world bug afaik).
[...]

It seems to be a dependency of:

commit 0485c9dc24ec0939b42ca5104c0373297506b555
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Nov 14 10:09:49 2014 +0100

    drm/i915: Kick fbdev before vgacon

which was requested for 3.16+.

So, neither of these is needed for earlier versions.  Sorry for the
noise.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-gLVVChWCAcLfyoLvATah
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLQEJ+e/yOyVhhEJAQrnohAAgK+R0ZTu1lWkpbJkxzjyUenk3Rr8UCPh
7xJCVjORkivRrpLbUaQwptblUdkKCtsQW1Y9aWtEvOxZzYqbjAuveO2LN4uHvTZz
qG4TRCUl8pauoR8DtUd7BRd+MupqLgDFQzCwKm3fm3qmb4HViv1+nFsWyt8ean+9
dCum0auZCzyTnDDAo1j1vECsOtLQzTNPMe3ZzB2l+a1zrOaddem47vjTS5XAean5
WLW6pgzPlxfc2HbE5Xvz4eI4i7wnCxQdB4WuHzZ4TAH8dZERy4qDhGf0If4Lmc7B
KPQmc0uLQncluj6D6PXWSQCffb9Afx1785cu8YSpbGzSxFa5HL3Z8DlMTtykUxb0
EXaooVbfZCJG1zorMcANKCBl/r8KorzeefIyGRT9UDLFyJxozHCsu217WiciLhMt
d492P2iKoUoJVt9Phkd0OZdprDczZG9nw9klLJurdILt1XonH/nLywFizCMLkPKK
pRpL+ZCMbOH2mcaypB9WhSzC+4LVOVdOZuVxn6PTqbPieB/8+ICsQAAhC60sXLhY
CtwPPuPdJKegUoFfgPlBw57fGxNF1z+Z0m2/ngqAhvEZxlRS7fv1sj79IVAlPL8A
Kj50nYc4OnYtvIvsd7389DAzr8xAe7NNAeUXVhYyn+QS2Ip4XtD3ty3PHfUl3j0M
6k2jvEVlrlw=
=PKxS
-----END PGP SIGNATURE-----

--=-gLVVChWCAcLfyoLvATah--
