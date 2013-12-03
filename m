Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3LCSE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:04:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57399 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3LCSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:04:55 -0500
Date: Tue, 3 Dec 2013 18:04:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20131203180430.GI27568@sirena.org.uk>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <003001ceefb5$c418c600$4c4a5200$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48DfXVLS5QXSkCLu"
Content-Disposition: inline
In-Reply-To: <003001ceefb5$c418c600$4c4a5200$%han@samsung.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 27/39] spi: remove DEFINE_PCI_DEVICE_TABLE macro
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--48DfXVLS5QXSkCLu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 08:25:19AM +0900, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.

Applied, thanks.  It's on a topic branch by itself so I can easily drop
it if we decide to do something else.

--48DfXVLS5QXSkCLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnh0rAAoJELSic+t+oim9GC4P/Rw8raDhr206VlAvoJdTOCXR
auyX6BQMhxgC4rBRUTH8SVXl8orVFzPFBnkeDvZHBFV5j+YbiG1CV7eJvJ5Eu2xu
qcQAmvt0FNWvy3Gr39MfvMLI4rGoz1a0P8BI6A24/gDHNlntCcDJTgCSeNUUD1/U
WXQqttCYJvS1HtEbIZhC/H4Ep065rNWrhscNC8J/dqCTrBmpU4Ufyivryly6FNgG
M6OgPOB5O0Zab79R3YlkfLWQGudw8bdPzCaa4uaZjMmITnSax7xVivNEbo1rMyip
chigavIra1pTLXlG3m4DV1EOwlSj3heF4Leg+N2bUquKsDsNp1lx8foCY7aQDPnS
9zKYGJKd0QMr3uPiO/82BYn9s1ApfmdyG+VKaO6pq8BVJ9Tt2rRK8YvxUuYxBtBs
cIShJs8in76GWq47EFq27exPko8rTbd1gkye38PKAv4+WZQOodU6zh7cCTF55Je1
ps3UtwEUh7jplycHSaF3RyL/XW9e7k1NnbA9STblW1MOS/k6K1Uuub7CdmS+n7RK
Okztb8KcgqIhmmrQmPu3sLW8VGH5DMEfakl7+tgL2q1UoCvGLfmjSUyTbmYxcxmW
tR92v4ONCJqEUzJYrBP9akdcNe5JgtIr1cj3GhX2IjwfxZfk5NWVxowrjOm+erfb
GENRPH1hYqYfxGO0jDV0
=wXhR
-----END PGP SIGNATURE-----

--48DfXVLS5QXSkCLu--
