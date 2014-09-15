Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaIOWGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:06:04 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50106 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbaIOWGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:06:02 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Subject: Re: [PATCH 2/5] regulator: fan53555: set regulator name from constraints name
Date: Tue, 16 Sep 2014 00:08:12 +0200
Message-ID: <2905334.044J8r4kOu@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140915165923.GX7960@sirena.org.uk>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de> <1410722585-13393-3-git-send-email-heiko@sntech.de> <20140915165923.GX7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart88178596.ehuDfZBYF4"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart88178596.ehuDfZBYF4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 15. September 2014, 09:59:23 schrieb Mark Brown:
> On Sun, Sep 14, 2014 at 09:23:02PM +0200, Heiko Stuebner wrote:
> > There is a high potential of more than one of those regulators existing
> > on a board, so name the regulator according to the name provided in the
> > initdata instead of statically.
> 
> No, this is pointless and broken.  The core will already use the
> board-specific name to identify the regulator in diagnostics and so on,
> the name being supplied here is supposed to describe the regulator
> within the device.

ok, sorry for the mess-up

I've just tested, patches 3-5 apply and work correctly without this one, so do 
you want to apply them like this or a resend of last 3?


Heiko
--nextPart88178596.ehuDfZBYF4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABCAAGBQJUF2NMAAoJEPOmecmc0R2BeIUH/RUFG3vid9y+h/NuqkQ4HkzL
LJRW7icM4XWxcrbOYrTfhLvTB6onOQofZJnDrA/NrkR1mCA5hctBbZT0IhZuaZvG
P13xYLWh7bT4BXmQCVJzama41Ykt88IP+BZMmquzpSlnJp+plVYS6XE0PyVxKWZE
pEHHaEm1FCYgAuv5Bl+XXyq0sqfF84Y+sMRHyKQkIR6khREHUqEzo8H39TqCObYb
EWK7eCgKUaWE8hJgITMM6ARy558e9993SJkQHQE8ks0vJvjkSkvlGsnl/ff5Qzd8
eDU4k3/tLL3wGz002a2ihuZ9hy0ihTSfIwYdRWBiRCUueZ4uTZ404hjAjDNXnlU=
=X14d
-----END PGP SIGNATURE-----

--nextPart88178596.ehuDfZBYF4--

