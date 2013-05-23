Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab3EWPSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:18:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50003 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844Ab3EWPSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:18:20 -0400
Date: Thu, 23 May 2013 10:18:16 -0500
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Message-ID: <20130523151816.GB6406@sirena.org.uk>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
 <20130522155347.GJ1627@sirena.org.uk>
 <20130522165353.GB18714@gmail.com>
 <20130522174516.GT1627@sirena.org.uk>
 <20130523070905.GD18714@gmail.com>
 <20130523142419.GG2412@sirena.org.uk>
 <20130523144453.GL22683@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20130523144453.GL22683@gmail.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 03:44:53PM +0100, Lee Jones wrote:

> Well, whatever happens I'm going to be able to refactor the driver in
> the -rc:s, so we still need this fix, or the world will end.

Why is it so invasive to have the driver cope with absent constraints?

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnjM0AAoJELSic+t+oim9F8EP/1QR2124X4VqHaWbxkP+m4vG
W0byQ+cIrgfFTPjKsBXCE9BiWptMpfcrnFzUEquGkFpSEQVPibn6KAvBiE4ncUTk
9hBQhnzhJW8cLtEzdZzwd6/GoJu4oto7KU4iJh6EZw9RpYpBPSEMTWoXZMbizcwy
M/BGJGvMuKEr/78zECgZSMnosARnBgqeogYfOWQdw0XTYrGSbEv/1LuRf7EhPEjZ
3v45YNNsTlYgw9f5wJZ2Pcql4qQ/7NahIfLY+9YQ5T9+BGqpY6V2LlSq3TObiunx
4yl4ZZq5eEVqYLR/7FtxD+o6Rtr5d1RzvCU+vWzRIBxxj1ybGODhXDeTpjrWsbhp
XdAr1c0RODXDz29vnX0KCed5lH0aodbBrG2FOyKxA1OppkpYlv06ebUBZUCB4KeR
HJ4Rha6onaea/9qJdMsszYaSqyDILi0YLn0NS1/ZzgXx1+gBiGhAiMQ+/VOb4WzX
D2QAKR5RGdinu1Ts8rsOzTSbIkM7/HOgaKNss3g6I1/iSSEiJjZtdqMqtWugYw54
qVSB6YN0eayPj3ocdwa7ed0E9qRlLlKlySVSbeh9Yz2IIX1pNyzyDfVXAcTREJZJ
ZGVA/VRNHybpCphjkBW0J73Cm74guj84r9NEP+7Y/7tP6Hre2lT74pmXauBatFyd
R8piKuRREZTHX8SUIssS
=Hp/g
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
