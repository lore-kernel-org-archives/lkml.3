Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3GAIoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:44:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34267 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3GAIoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:44:05 -0400
Date: Mon, 1 Jul 2013 09:43:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Keerthy <a0393675@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Message-ID: <20130701084339.GS27646@sirena.org.uk>
References: <20130701141827.8f9122f0b6ca860fa5fd11a5@canb.auug.org.au>
 <51D11C8D.2010400@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UiQbhG36sksrFEkN"
Content-Disposition: inline
In-Reply-To: <51D11C8D.2010400@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the regulator tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UiQbhG36sksrFEkN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 01, 2013 at 11:37:09AM +0530, Kishon Vijay Abraham I wrote:

> commit 1ffb0b (mfd: palmas: Add SMPS10_BOOST feature) had used PALMAS_REG_SMPS10
> and I dint have that patch in my tree. Sorry, my bad.
> Keerthy will send a fix for it.

Resubmit the patch, I've dropped it.

--UiQbhG36sksrFEkN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0UE4AAoJELSic+t+oim9FqsP/2/yWvpxJ5YYENy+AMeYGvos
g0kwXwyxXGtD8WiId/YHTNOL8NY3g6tKLgeEarhCHKZeIUs3MnTCM++d+7Kv9VGV
aBXdqLPNFUL+r3jO3s8G+quWpm6G5E+Rf/zizxFqfUBonKdTmfjehFPvxz0oD0fl
b3fNEFiQ8vHUlY1tmb5fUvts1EL9O7DD4+Zjz7KGmK1bqRiaYuuCbIlXwWGtFPDL
w62fADYaNhAcekEJ2+hZjsd1AYECK/VwwNncpdrInh8beqYQfbRn61LXNNoJ5Bf3
WgxkKAn5WjhSVoan4ac++yg0IH9YR/8bpycHxhZxL+Uxe69gONCOYh4gkQvxpEEw
6+d+mpIPIaEUnvVdaeLZVNZAvyXcfua1KvgxQ/I1VOYaiZxmEdWodixjTNnjDmua
lBuslHhbE3uuK2QM38haj9O64f1JupINNjszLePWRZ6nmcLFPXOC8e3JVUboI3kp
7yBia/tY9gyuPq7nOyEV+gplzw4IdZhvPav5gmbYFe+iHcAGEFARjGDgnKKx40aZ
rWDmNCo7YNR2GdbdAAasrlE7/g3TkP6Aaf8JH+Q1nOS09GS2YIMZvKKJ37fOXonF
Jv7e4nBC1W5sYWZ60pea+YrcjSYduNkvtuXruX7WmUeavBdFZMHxHtoe++GYtoQG
o+mw79Y4/A0MVMIqYJC6
=tCP8
-----END PGP SIGNATURE-----

--UiQbhG36sksrFEkN--
