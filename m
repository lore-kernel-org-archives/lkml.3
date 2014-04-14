Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbaDNXuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:50:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33209 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaDNXuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:50:21 -0400
Date: Tue, 15 Apr 2014 00:49:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Insop Song <insop.song@gainspeed.com>
Cc: Jane Wan <Jane.Wan@gainspeed.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Emilian.Medve@Freescale.com,
        kenth.eriksson@transmode.com, thomas.de.schampheleire@gmail.com,
        b48286@Freescale.com, jg1.han@samsung.com, sr@denx.de,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140414234949.GH12304@sirena.org.uk>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
 <20140414205151.GH25182@sirena.org.uk>
 <20140414213853.GF14129@neon.local.cohere.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Gk0KcsbyUMelFU1"
Content-Disposition: inline
In-Reply-To: <20140414213853.GF14129@neon.local.cohere.net>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all
 received data to user
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Gk0KcsbyUMelFU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 14, 2014 at 02:38:53PM -0700, Insop Song wrote:
> On Mon, Apr 14, 2014 at 09:51:51PM +0100, Mark Brown wrote:

> > Please also be sure to CC the mailing list on patches, the sourceforge
> > list has been unused for quite some time now.

> We use scripts/get_maintainer.pl to get the mailing addresses.
> We will double check the mailing list from MAINTAINER file.

This will be part of not using a current kernel - if you're using a v3.8
kernel to check then that's over a year out of date.

--/Gk0KcsbyUMelFU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTHQZAAoJELSic+t+oim9XrIP/2EUXBeqFnI2pF6M0PMTa6Vh
t9z6c1fjYuyPXGnmFI++6rJhnJli+l+A8QVlzk/WsqKTkxdte4qz8+XQVdQRLBQL
CAJBdeOvVimSLdcOstx5lYVpSZIVwwO9a7NCeqNfSmNjRkONEc6joCMkrbC9pq9y
XxBvkrAVomBOC4glicl09zAhHFPkYV5tpb2fIiG0dueB4u7Uiar1YcVHnBR/XjjO
fXVsBZ060PDEH+KQVALnndoU9BV+6BDpATQdHJ/6jvDannex8X11+SPsjvXNVL8I
voTluOWuS1vSM8v+m9WGs79V4PTB8dvb7s1KZR8dxiCkhWZdvbfIcqhVQCEgNZvZ
xO32p5uskTKy1Yfg1uqDGMmQomVqDoYGtXM9MROEf6U3CrsOvxU69VZtTFEIA43G
b9ezTFhyAWf5LzxkciqDq21iVF0p0o+7jhjm0H8jqcNJZv5GqgGo/+3e75d8MsDt
i9TgoqrA4hDsxJmIn4r6+yz/ATZkNrnRRQVLDHp/gHpEBjCGRMrMEfLCkWEFuLXi
aMmotRJDizLJhjdOBwo7+BCnzELzFmjj7rflZbcgrUv8e54WiSTqR4ekooLcnYOl
VcaMbhpRYNzVVeYw68kefLh+mywDOBTes1Pah6LzQDgEaW+eV4OdmTQ9Bwwhfl0S
BN1LjZXlz8Kyfxulaem0
=pYH8
-----END PGP SIGNATURE-----

--/Gk0KcsbyUMelFU1--
