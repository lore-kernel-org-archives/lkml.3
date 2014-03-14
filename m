Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaCNTcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:32:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44114 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbaCNTcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:32:52 -0400
Date: Fri, 14 Mar 2014 19:32:48 +0000
From: Mark Brown <broonie@kernel.org>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140314193248.GF366@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AkcDN4P/vcry3ns+"
Content-Disposition: inline
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: Tree for Mar 14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AkcDN4P/vcry3ns+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I've uploaded -next for today.  There were a couple of small issues
today, mainly due to the addition of the new compat tree, and no trees
needed reverting.  This build has been tested with ARM
multi_v7_defconfig and x86 allmodconfig between each merge.

Stephen should be back on Monday and normal service resumed.

Thanks,
Mark

--AkcDN4P/vcry3ns+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTI1ldAAoJELSic+t+oim96DAP/RXaUmkAn99NaOkRBzOMbEgc
hw7pR7Rr/SKDhK2rG03szDaUEcWuPueaLxqlcrK+CRNg6uvOrkLi5NzT45eONpzu
iabr8+slR8DkMah0FkhYBcJIUCASlLCnpgsurfLMqPqVRWzFK7U7tEQX01Cu853i
QoFKfcJwdizcYNt8TRN2PP0AMt+n0jtn6lYuO+Ou6Yra/q8u7064u8KA0EbM8A4f
PckH0uxJ7FC9lHy9HO+51cKchaj0YLqXFJzscB4bXOxtJSI1P5PZtTtnElkXGZhU
2LIpKSuX1JKlzEfM8ZU8Lk1uJEf29JZN/vMTM1bWhGUG2//XbhXRY41cL8Kdzbsx
91vh2B/sPNYQN6P9GxULvbH3umx7KoiQ2Y5giNykBzXEcZChemVAm1xl5qzwqoA2
h/kYDPn1VKGns5ZS14moQEvZW7PdRbRh8xCiETJabeuKvNZ5IXazm0bqTUukccNv
GDtVL5L7qGCGL3zJM2SW9qJQ2k+jmsQyENeFiru+GM4PsaQ8EdVKZBnrK9ogFp8R
FjoHFsZHFOr+QYRI02IypCjA5AxI1IPA43+VGeAWn101nj8+XsfGgh8XrcpDb+b3
vioBFfkNF3ziH5bUoFOv5imdJfplkDPtLMUw5BNq3lzs3d7Sh/lS5aqCKUFzFlke
d+yfuvoV1FGmPU7RjPxP
=cpfV
-----END PGP SIGNATURE-----

--AkcDN4P/vcry3ns+--
