Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3GALEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:04:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44807 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab3GALEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:04:42 -0400
Date: Mon, 1 Jul 2013 12:04:27 +0100
From: Mark Brown <broonie@kernel.org>
To: "J, KEERTHY" <j-keerthy@ti.com>
Cc: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130701110427.GJ27646@sirena.org.uk>
References: <1372672182-14778-1-git-send-email-kishon@ti.com>
 <20130701100136.GA27646@sirena.org.uk>
 <51D1548E.4080008@ti.com>
 <DC88CAD03C0052499C1907B327FC63229F0F8A@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7Yzp88o1bXvlN4ic"
Content-Disposition: inline
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229F0F8A@DBDE04.ent.ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] regulator: palmas: model SMPS10 as two regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7Yzp88o1bXvlN4ic
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 01, 2013 at 10:19:55AM +0000, J, KEERTHY wrote:

> I had submitted a patch on the same file which was pulled by Samuel.
> Kishon is based on a branch which has my patch. I think that is missing in your
> Branch. This is the reason why it is not applying.

OK, resend after -rc1.  Please also roll in Axel's fix.

--7Yzp88o1bXvlN4ic
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0WI4AAoJELSic+t+oim9q6wP/A8+G11Ag8/r99g2mSZVITFT
nhcNqGkaodKwlgRfTA/Mj8eFJR+4R/H20dngFzd4mGW9c/SJmM+AfPGXCKjWdn3T
1vw2MAsEdwNbNizJB36+8+Mx1SLQroPTMFFOfd98FTlcROwQxSWnFCAZIeL5mRZV
f0LZewKLe+JLCKqUW+TvVMkMKA2UXduFxWzdadOWFpGnzMzID3mmdOGtqzS8GmPQ
JMfxPzgNxY8gKZJEqphhzJh5ptH4Yte7bkXfh3jAX3asszAkGVGf95kMiR1KejDc
9rWWtMQyVdUBL3O32cQ3jNzmVbkbHdpP0i3wkpmigbkV9U5Aw5YEqMuku5WcINBp
xF9FnyMri/sc4tjIxT64JA1BS1u9cV3GiF3AoKvj3HAGAfGXxK8PhHg+zviqOXPn
SK7PPKs4TptyPtNRMZBbs0dCNGS/r1ensc5YjXGLnTX/hithBEz0rpz4J4DZOve/
WepHKrknO5GJwfZDMdMQpf6GF4SAqqmK91rZYo93HeVmi0dW6jP3idb2B62+FC/O
WpkBcKDDJQN5cNFsI/YNcfKeRMb4fFHlsDU0WqQXwyuj21j8PPbSlrxQbF4u7Gnd
pl8C7BmR+4EFuyFe6Kjj75U4aZLcguyeB+DTQ6Q3COi9Sqzco2rtSx1NNG2sk62R
9wUdSGsDCWUT5m/ZkTkz
=O0jw
-----END PGP SIGNATURE-----

--7Yzp88o1bXvlN4ic--
