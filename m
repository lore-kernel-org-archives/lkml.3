Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab3GZCt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 22:49:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51692 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756421Ab3GZCty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 22:49:54 -0400
Message-ID: <1374806984.2480.21.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [62/85] HID: apple: Add support for the 2013 Macbook Air
From: Ben Hutchings <ben@decadent.org.uk>
To: rydberg@euromail.se
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Fri, 26 Jul 2013 03:49:44 +0100
In-Reply-To: <20130725065048.GA3586@polaris.bitmath.org>
References: <lsq.1374674564.753305150@decadent.org.uk>
	 <lsq.1374674565.974236672@decadent.org.uk>
	 <20130725065048.GA3586@polaris.bitmath.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/nkI+9ARRYMKGNSwmPui"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/nkI+9ARRYMKGNSwmPui
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-25 at 08:50 +0200, rydberg@euromail.se wrote:
> Hi Ben,
>=20
> > 3.2.49-rc1 review patch.  If anyone has any objections, please let me k=
now.
>=20
> Because the bcm5974 patch is unsuitable for pre-3.7 kernels, this one
> is unsuitable as well; it renders the trackpad unusable. Without this
> patch, we at least have one-finger mouse emulation, so, please remove
> from the queue.

That's a pity.  I'll drop them both, thanks.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-/nkI+9ARRYMKGNSwmPui
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfHjyOe/yOyVhhEJAQqwwBAAqGEfqcLnz9K1g2hjxzrAXddFhPVtS/Af
Kb0vr4+Tmw4M4pf/QfueXcedRZuJ3YmudG6BGsB3tyUcwnXGlgIcBP4Q2gGDgn+A
wX/S6Ll5m3AbQXYZpaWWdJdxG/E7qvoyrrhWSc64T8JMvUTCS+BRvmYK9KXkc1gK
vvP6iWQGrJ13Wbp8ZXEHjzymlLfQF/Fo5PCqkOJ2LU0m70s+YwjrV4uvBC+ckKRX
mqiG3FMesyT8YrbXsiB3QGuBsCt/cOfjKTfzuZMXO0VdYqy6Eo3I4dr1VhrEg2mZ
b/9gOkH/vvOhAkIhm0WQaR/yYOp61QGe97/trXGbpAqZK2RFhSe19tlEaYWIvPFN
xrtLLZCMj8OaNKNudsQSRi33NcAhgbsFX1b9ksu/mkffD5DqI+Fwjv29Ow+LkVVj
DXLKNJLhBSsiP6EHgnLGG5DLmm/trFVSgyKXjd1ahXBw/e2Avj1vV0Z1uCYhIS4n
z0GEOGzKRQ3Q+dYxA76sICC/TZZeLM/SO0NvyFYRbPQSph8qpdhc7e7xc8Fll2W2
9PYCiToJ2HV5PvfHCcaSYELtAjTgJm92oDeRSq+xD3YYOp52RxsY+FocSsAQYA2D
R9CIBkmdz9GLd35kP9mZEoWqssWnbGMXS6rYtVVPML1KFMiSiospMp7lt45b1qjF
pu0PZLX30PY=
=dbt9
-----END PGP SIGNATURE-----

--=-/nkI+9ARRYMKGNSwmPui--
