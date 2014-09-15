Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbaIOWhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:37:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43849 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbaIOWhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:37:01 -0400
Date: Mon, 15 Sep 2014 15:36:45 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-ID: <20140915223645.GG7960@sirena.org.uk>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
 <1410722585-13393-3-git-send-email-heiko@sntech.de>
 <20140915165923.GX7960@sirena.org.uk>
 <2905334.044J8r4kOu@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AtnpEaT8eVnHe5fr"
Content-Disposition: inline
In-Reply-To: <2905334.044J8r4kOu@diego>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: fan53555: set regulator name from
 constraints name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AtnpEaT8eVnHe5fr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2014 at 12:08:12AM +0200, Heiko St=FCbner wrote:

> I've just tested, patches 3-5 apply and work correctly without this one, =
so do=20
> you want to apply them like this or a resend of last 3?

No, please implement the changes I asked for in the DT stuff.

--AtnpEaT8eVnHe5fr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF2n9AAoJECTWi3JdVIfQb88H/1gDzN8V9Ru9UsqwW0xvFPdF
tlVq7Ocj7HehPjQcwPcpIWxLmxCCBLBU+PkA6c2++20KbQrz1S8LJ1W+4VfsyT+S
aE0qgLrCuIjr2r5rze5D139uGw2MeVIanYezJXYSkrRYcUIp3ZMMofBWy4csxaw9
rfPwoKXbTz5j0jwZKvgNUoU9vTtiD5IibuTLCCamtchz9kCQTEL0krU/yk9YgDRl
M1KPwcjybDO23glrtKFffcGQgtP4Hu4nAFr4HbBbTv438Yud9GWmgNwOBgtYNNSl
TXSgZ8PJdgWjJVQeETYKLB8lrpTNU+Trf6AZfJf2I+v4ij0qadXnDxeCmJbvlq0=
=x2yP
-----END PGP SIGNATURE-----

--AtnpEaT8eVnHe5fr--
