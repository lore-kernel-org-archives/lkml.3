Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaJEAMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 20:12:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:45701 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaJEAMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 20:12:34 -0400
Date: Sun, 5 Oct 2014 02:12:29 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: ab8500_fg: Fix build warning
Message-ID: <20141005001229.GA5763@earth.universe>
References: <1412465473-13495-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1412465473-13495-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 04, 2014 at 04:31:13PM -0700, Guenter Roeck wrote:
> Fix
>=20
> drivers/power/ab8500_fg.c: In function 'ab8500_fg_probe':
> drivers/power/ab8500_fg.c:2989:27:
> 		warning: 'i' may be used uninitialized in this function
> drivers/power/ab8500_fg.c:2972:15: note: 'i' was declared here
>=20
> which actually points to a real bug.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Thanks, pushed:

http://git.infradead.org/battery-2.6.git/commit/7881c64716f3a7d60b325ed0ad4=
d15f49b474a43

-- Sebastian

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUMIztAAoJENju1/PIO/qa4SQP/AtDh41iGmXqp3r183bdrj7q
7sRHJGILlMODjOkZVr/Th1vLBQR0ojhOXt/CnY30wmM/VuJW2UrEm00LNw8fanf3
s8izCQdsxvKjb9+56JmU8qLUFkcF4to49aVbbIVzFfClrzHLWKwl7PBaOz6m0WSC
F8H1BjSYm8bUUBRkzoJ6eBOyGhWaKp5GpXbnWS0ifQ9G2rf2xbtKdAxctyaPq0Uv
a5ocSJc8iaNf5aW1HLfDFvsOea4Us9PcX5xAI8+lgHT90iY5O27pEFdFW5qDNAnU
6alWrhQFSIjqDiOCc808XRjH6JvQOYrdjSZQJ2R5n/KwEchIBZkvo2hmw5GzXVi6
zIxHqYV7fBSB5+1b1fiqduiKbII6kQMmJErAlhKwx5Sp++cKA20ueloqVSj+rHJK
jfpk9/TAbmJTp1mvlucWI7KXUUDlRq9W1vdZv6hjwk/zSGc7X/qG04LhGvdNXcfC
fLs7uAUydKzCWPqTpUwAbf2bH9X5VrrDntDYFOalvMqY5F4bWaLPQf2+ZPVPzYEQ
kZ57vsXI211Mi+tev7bGJOhV6B/l7fHCMqsT7nTOkr8fKuLF5DvaJGyPVhI3cppj
wInoT6dflKkm4oKjqTr3Poxhwv8OTQ3JUY+s5FOEbT7IB4FJGoKYixBRUQTCgX8K
9PiJ28nt/ilDRFDN11Dl
=XUCN
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
