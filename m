Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3ELOvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:51:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58552 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3ELOvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:51:06 -0400
Date: Sun, 12 May 2013 18:50:40 +0400
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130512145040.GB4046@sirena.org.uk>
References: <20130512144249.GA4046@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20130512144249.GA4046@sirena.org.uk>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] regmap updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 12, 2013 at 06:42:49PM +0400, Mark Brown wrote:
> The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24a=
d1:
>=20
>   Linux 3.9 (2013-04-28 17:36:01 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-ne=
xt
>=20
> for you to fetch changes up to ecdd483531cc72aecbc711c75d3e29cf1502240f:
>=20
>   regmap: debugfs: Check return value of regmap_write() (2013-05-09 14:32=
:36 +0100)

Gah, sorry - ignore me.  I had intended to rebuild one of these fixes on
your tree due to a slightly fiddly conflict but completely forgot about
that during the merge window :(

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRj6w9AAoJELSic+t+oim9vhwP/A1oLMOl4I+HNftul3bIoJuB
J5V1mhhHXZds/NsvfFnXymcHJb3Hwe80HMsgUoH0L1fu7SoQfTKjCmQ/lenU4H9E
aHvgzIJB3a9b9GWTTqocXdHH6hOgY2J6plt3RnPBRbpHLvyEI9V7T/4jcf6VSV7Z
5sDfLTCTJGbeoaPXL/+eu/DlnDGu5U4PccY1yj6uCHIBmMIhERBoFbeXznp1MmpS
E6zbXW8gu8HCp9TJM5dMofUh5SQsyapDA81jIMeYuuT+qvqJ9BdZte3C9YmUmtTR
VxfX3Qhg5P9RY/wFAyvY05BLeC/Ar/DihoHFvzb0xhC6i6kKU7HvOvoqVaXh5rr+
Eei+c5+Ar4VXwN+q8+/y9OywQNOJP+y+ZRfg8VTGziu/crxWu19pf1aYBIINOmlM
umuPtAdvremCeoVmLxXGz0v5rQI0if7c46fOPynpaGSIHC5BDTZy4E6ZLTq1Eg73
eEBs/WPW8FAoeHivIR7bQY5TLvwrQjin7dwMcTjcqgB7bRcLtodZNcHuQgaCUGlJ
MbrGM80tokAw+V8PA1AREfvBeyZVbFsNtKCMJGg1LDxIOtbZZao23A4Q/x/C2AMN
OVMUaIjCYyFGv6rLnGRUtqwKSR/cJ9glG0ELw5zDukqKLzj3VUU+/Ce521zYSBRF
sh61GhOLF9CqZQKk+uTt
=hyVD
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
