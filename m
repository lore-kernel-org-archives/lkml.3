Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3F0JnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:43:12 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54126 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3F0JnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:43:10 -0400
Date: Thu, 27 Jun 2013 11:43:07 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
Message-ID: <20130627094307.GC8437@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <51CC0566.8010302@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <51CC0566.8010302@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 11:27:02AM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 06/26/2013 11:16 PM, Maxime Ripard wrote:
> >Hi everyone,
> >
>=20
> <snip>
>=20
> >It also finally adds a clocksource from the free running counter found i=
n the
> >A10/A13 SoCs.
>=20
> Hmm, have you benchmarked this? There have been reports from linux-sunxi =
kernel
> users (xbmc project) that the waiting for the latch is quite slow. Note we
> don't have anything better yet in the linux-sunxi kernel.

No. I didn't.

Do you have any pointers to these discussions?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzAkrAAoJEBx+YmzsjxAgmKAP/0OLB2fESm3IJoEkIh5RJlEG
VPEEEKGt5vfdamhowyv+I5CAyzOOFDL1ySql1hWjDXZclvIMaN1Lw5QvuXKpZlf9
lWZ2aTaibKef7rrHa8Hx2piTpmgE0psdlnAyvkaQNu9RaLJkZGhfmsHcUAfOe/tD
wZ60aQj9hTdGy7ZPE5oHU/9obBZJ1ov5se3atOZA2kFDR//C6hXjvtc1PBREmR0L
g9BOOkWN6REWpoJHzeH5feRdl0ek+bKxBI1CtRxL3E2WYbFUXQeoHiPJxMmELuxT
IRQFv/zyoYqxbSKz4fVklnigI52s/knabHxTc1bYhVK69gsc/4X7JJQQRwNHJnhb
1Mnq2437P15MEOCNE5WablK7MThLDxmfsgOsXBq8VA5hrHJnGlKB8i4REdoFjHCq
DjES5muzKB46EXUjXEI9TQ8bI0Ga+oeg4nKkpr3zoVgY7sSQjkn7K1nxaDCMyIb3
Z4KQl8dig0SWeeqSk+E5OFzBdJMVyX2RJSEovMHqQ7TIOsiQ1wwyva96g6hRbsDK
Uo5s6Zpw8Wk0O2OVSOibSN3Dz4xPUoo1G0DG6mDF9xp9RkLqn4jHhPTkm3535lg0
Xcdwsdh2KSnG4udUYSNMMQ13JclF/psYBM71g1KF3+QpIq9DyIN7Grp3s9spSqvh
O3WJ/YreRYquDK6jDRA4
=8OKQ
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
