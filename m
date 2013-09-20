Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3ITJwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:52:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47552 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3ITJwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:52:00 -0400
Date: Fri, 20 Sep 2013 10:51:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, swarren@nvidia.com
Message-ID: <20130920095128.GL21013@sirena.org.uk>
References: <1379662982-21327-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jvwwc3lboJHenLjr"
Content-Disposition: inline
In-Reply-To: <1379662982-21327-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: core: set current constraints while
 setting machine constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jvwwc3lboJHenLjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 20, 2013 at 01:13:02PM +0530, Laxman Dewangan wrote:
> Machine constraints is configured during regulator register. If current
> constraints are provided through machine constraints then it is observed
> that sometime the current configured on rail is out of range what machine
> constraint has.

Applied, thanks.

--jvwwc3lboJHenLjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSPBqdAAoJELSic+t+oim9gPMP/jffWClOiv6z7CmNNXJzuUvt
uWUsFRys0L49phWWNFU5c8m6SPQ3o/XftH+AjOv/wZKoixz7AYMWVXkSieJNVL+k
FN0um8oPmAN+A7DsBEv2OBSluAiM9w7Q6LIWnO9WgAyj8AEuaGXVqNZplsMcMQig
ZJlSwCxkUzHsBNlTU3MhSEPBRDqgNAqFY8McIJMTxzDu74u9af8I3lPLBa3w5jNI
fE2ZMwDXIBJirC6mDTUP/hzmfLxJu7czE7if4lQJWM3R5FqgXU0xrMWvVm5KYAYF
iWf3OkOkHgurxt3OTx3g9deb+GQ4KBOKo+S1Ok1hG9qeig5LZYBNdJdwWm9klonW
Rja8UEsr6bPznXOsYwRzKELi6KreDQa3JuGnm6DMayEySpwjNIAB1bxeAL0Ika+I
LTFwOcw4eiSqR2Bh7+eeMN1QP0EK9dZbbQ6DQjeX95JZ4PkoTWEIDKB9RPnlc07B
dplFizJAAjvTEjC0/RYlG+2xmpeGasPAKdiRNi45B1T0wZj4AlYe7RlIwZy+gHug
nW+psdc+4k9AjfHYIGt8CTml5Vz3poFcSufKEV2hARcKX0YdUxtDtI4eddK1NTZB
91VCmF0PIRWz2khRzqeVgcmQfGEM4sShD9wdfMMYUg4ME3y6VyIMQUnsnuergqog
06tfXCA6Afhgwz9m+z0o
=DK2T
-----END PGP SIGNATURE-----

--jvwwc3lboJHenLjr--
