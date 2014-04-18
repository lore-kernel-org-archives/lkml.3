Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaDRRHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:07:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38082 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaDRRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:06:39 -0400
Date: Fri, 18 Apr 2014 18:06:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140418170622.GM12304@sirena.org.uk>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
 <1397751967-20250-2-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n6oL1CxvjBDs4F0r"
Content-Disposition: inline
In-Reply-To: <1397751967-20250-2-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi/pxa2xx-pci: Add PCI mode support for BayTrail
 LPSS SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n6oL1CxvjBDs4F0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2014 at 12:26:06AM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> Similar to CE4100, BayTrail LPSS SPI can be PCI enumerated
> as well. Thus, the functions are renamed from ce4100_xxx

Applied, thanks.

--n6oL1CxvjBDs4F0r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUVuKAAoJELSic+t+oim9l4EP/j042IXNTvY1lKh1UAed6t+Q
NucI8DI6QkkM760VdE16leQOg/VuwQZepAHWwLNvwU0SdVPuu6mHzD3EJQPBjrdh
w6UZOYWfgTfHx2qrzERRydFPF74D8USNp/wMCrmn4N9miV/zcQHcEtTFvQLi6ETr
KZCDQ2ovxRoRqxkU7GPK44jlYdb8VShHLX0/SYpP8DzUrMVaEVZSPY6GYxyq4WTS
c4noqVkCfR9SSUxHYVet2PYa00VaGR5kaWFpwdUhQtMXffrB95DNOHoEAfDsOutD
X7rNHrlpHfVy5T2XO4ocDIE5KIHRJ03GySK8HCPxmAGWBWBnrcaJA8Ya1l8oYAyF
8ikDpkjtrLvNJYqEIgCmnzv9ele9NP2+UBDr9qJjjfPB/YT07RVmob/6oJufrQyl
ItUuSZG2s4A5K7nKU1OVBVf/mzayV3uqspoageVkaj6HC/TU/BDxx20u+Ju41Ow0
7KY5Mes1q4E4NN3OSVW49DBMjNguiF2ipVUY4MKlOdwM366ERgt22QHmIZPJB2wE
7Pb9OVDui7+yqI73CkcjOuQlwRL7Mrv0YUwG0EonO0W5oiPcGzy/ackDJ/zVHrbm
q7qUTtDCvtR1PQfN3UAZ0EYOf2NqyZCmkVhetBG71usmsfxxdfqi+wnpO8c1T1qP
F21F8HmdvMl2pU8KZ5cf
=MkO4
-----END PGP SIGNATURE-----

--n6oL1CxvjBDs4F0r--
