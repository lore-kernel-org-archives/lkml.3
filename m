Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaKIXUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:20:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39638 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751424AbaKIXUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:20:05 -0500
Date: Mon, 10 Nov 2014 00:17:44 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: AMR: sun7i: CPU hotplug support?
Message-ID: <20141109231744.GC2989@lukather>
References: <545FC215.7010802@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fr7jhMP26BSURKlp"
Content-Disposition: inline
In-Reply-To: <545FC215.7010802@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fr7jhMP26BSURKlp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Sun, Nov 09, 2014 at 08:35:49PM +0100, Jan Kiszka wrote:
> did anyone already happen to look into enabling CPU hotplug for the
> Allwinner A20 in upstream? I'm currently running the sunxi-next branch
> on Banana Pi, and echo 0 > .../cpu1/online just hangs the system. The
> old 3.4 LeMaker kernel works fine in this regard. I can try to look into
> details and port things over, just want to avoid duplicate efforts.

Having hotplug support would indeed be very welcome.

However, it should be done in u-boot, through PSCI, and not in the
kernel itself.

As far as I'm aware, no one worked actively on it, beside some WIP
commit from Marc a while ago:
https://git.kernel.org/cgit/linux/kernel/git/maz/u-boot.git/commit/?h=3Dwip=
/psci&id=3D45379c0f9cf812f0f62722f4015ec907fa5dc144

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Fr7jhMP26BSURKlp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUX/YYAAoJEBx+YmzsjxAgQFgQAL0vddwvTHKLu2ydzPl33tty
l0a7Yxy6Do8EtdLmmJvKvgQ8+lQbPJ7CTVeez2l3/5pwvyi71WOyMZA6Rmv3EL7F
TQn5iuab7lV6P+6kFSRmmeUpAvgfeaYsSqXfAdoFG0uaDXlLd6PzSQ5B0a3tQEe3
ZwoFkICBlFKOzPE1scfuc4cbJCcJzdk0Dmb3GtJ0RpOHo9vvD+zvpOcpsA+OfJy/
pxybeY4StWdn/EU+iLT6WEbN+IOXdxT7N/iNuMPkxwwWj7QnJFzOMg9Qo5CytlHI
t8U3aBCa/YCMZ/TH/YaQw4BSA3fRwe5PO8/OSnQAZ2hx4n0TM7xvSxJScwRpdnXq
j/GKrJKMChHFtSUiXjIwDlkNjC88ZCletP2ZFPa6W+eWpCHJTuBp0Nj/USNrTp+D
/UrUTb2HqFC7oSjolEAKA7Dx9cWzFKL88pX0d68AQoTmBpx9S0PFKLrGt2FxE+wy
A8hru+i/GjDTflEVrMv0UgEIpQywCWEjU7WOxYJ02Ac0fIJ4NSfBdTfcGbNBnVeo
sSYDJbQjHKaJ5IUHnt340UM6p79Dd+3rqfgmd3RMgMq6KTcFsikrKGNqiqv54Zfb
kprtZ7erWFn6OyhSEy8Zd/C8gHmcwecGeU6W24MK/CizgE3FJLtWq69Wd8en+CMk
J3Ho/mYP5h/NTLsnC8vc
=QXfn
-----END PGP SIGNATURE-----

--Fr7jhMP26BSURKlp--
