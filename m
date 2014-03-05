Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbaCEEA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:00:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55903 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889AbaCEEA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:00:57 -0500
Date: Wed, 5 Mar 2014 12:00:45 +0800
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140305040045.GC13126@sirena.org.uk>
References: <1393990141-3157-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k/A+UfywgnnvevLW"
Content-Disposition: inline
In-Reply-To: <1393990141-3157-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: atmel: add missing spi_master_{resume,suspend}
 calls to PM callbacks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k/A+UfywgnnvevLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 05, 2014 at 11:29:01AM +0800, Wenyou Yang wrote:
> The PM callbacks implemented by the spi-atmel driver don't call
> spi_master_{resume,suspend}, fix that.

Applied, thanks.

--k/A+UfywgnnvevLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFqFqAAoJELSic+t+oim9s9kP/io0JQ7rTaDLy979yeHLK+56
jNQ6ObYhIGVqTl/8XTIUAdNGkfAnyD8UIlEm0yOa8tgJSaazIsROdlx6iRdx+fd8
+989/HhgKfXDZROGBR8f6Vs67OgkU0iS+tAe7sNR0pmAnZj5A+Y33D120VM1l7rN
gXFcqoPRIaRbE8k3NrAaF02XSW7KiB1QeLJvn+scZg5yuASJoWkCHNQgMTWbvsAV
5LRnFU0muUbveZfH9a7nqsUQAbA8PJQRxlaH1186VcMidFLa/Tgro1I+oR/GM3pZ
vsnQJZFkIhhBfCey00IvAODnGhwmWPef+vGurePvtmYNhL6okBSXTmlqZTBZqJq0
810BbpCS89sPhI/YG5AwEvlOido1SaUdQYZh4s34wEW7emBW2guMNlxDLtZMuMki
bNqtx9gQjtEQ9FBsJOA6t6bRmjb9vUAmEqqd0ax/ID+/mv/IxE0/L0DQIdgRueIJ
UZQVWcDPkyF/fZl540XRl1z14FNA2aLzt0psq+cpxnk24yJrnhq0Z8KZJwkVg7KJ
uFBL/LFXIKJBdybncJPUVK2kC6rzLh5bDGczUtmOnbd0VBowVYrCbVjZYki62Blj
DMudbdHrM5tl855eFqF1GHKy5NpVypWlb9FXxNOMlAkc2GHiYJISQ6DMEfkFX8pw
QNCF7mO+rNogDVRuYHDb
=VvZg
-----END PGP SIGNATURE-----

--k/A+UfywgnnvevLW--
