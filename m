Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3GRK65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:58:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48167 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab3GRK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:58:56 -0400
Date: Thu, 18 Jul 2013 11:58:46 +0100
From: Mark Brown <broonie@kernel.org>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20130718105846.GJ22506@sirena.org.uk>
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
 <1374133720-27362-1-git-send-email-b.brezillon@overkiz.com>
 <20130718095337.GD22506@sirena.org.uk>
 <51E7C1B2.8000206@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V9E4GD/88frki9uz"
Content-Disposition: inline
In-Reply-To: <51E7C1B2.8000206@overkiz.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 5/5] ASoC: atmel-ssc: remove clk_disable_unprepare
 call from critical section
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V9E4GD/88frki9uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 12:21:38PM +0200, boris brezillon wrote:

> I can send you the whole series if you want (already sent to LKML
> and LAKML).

> But I'd like to understand who I should send patches from this series to.

When you send me patch 5/5 with no other information on the rest of the
series I've no idea if there's any dependencies on the other code or
anything like that.  The key thing here is to make sure the people
getting the patch can understand the interdependencies somehow.

If you're sending a bunch of unrelated changes with no dependencies
you're better off sending them all separately rather than as a part of a
series.

--V9E4GD/88frki9uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR58piAAoJELSic+t+oim9rnIP/jrPFnmFAnocqH0df+CKoI6o
oI7RDWuMcmusIi2qOqknVIRJoV9o5pWSQMA00LppcNjDJDD1DErb4JKFFInmoLYS
0AnKepYXn7MoidjVymPbblZlVQILbpD1ryxsWd+NwmM24RGhB/wTXEKxtWzvlRk+
FQ85AWpDkg9Ewp5oPOl7km2Xvfm42StjCuo61IgZaC1O+M+C6f986Oiv8CnnRzLW
ChKBTk3k2gMiZHogbxaO+wMDkW3uUF0HFlBFwKRimoC2tImStEI1YcNzogfWZWMB
fuygYPDa7s8WXsysdE0gpO7QK3jZdMmOcHdtEq+FfaUC4W+Q/rg4GKyADYzFLAam
VW+cPqjhkGphA7xuvdmJ9dJGd+Cij2BROOdWFTzEkyz9JK5FXK/D89DTfrBsAY8V
SBCJMsB6OuQKvA+P5Y2ckPPjfMnOopsCCaErtMtLgVbSjTEeoqd2OqmwU9qyDlM5
tp7Gw51pKPQhLmMzQaWi1qSMD7IAKn2S7N8JT50DKCYTW/1FK3NJdGN6BHAc636l
3s+mWUZ5Q6GTXwZlDp6H1CF8RyiyWxPim6lhrfCGfEfe0QLokEERyuRHszqhMJVO
ekZ192YUTc+ygz8r0/WuiNndIYYRLpGOqZIfwt2XhrYB85U+1myXj+Xp2211PKGz
M7yRVKM/hiqG22k+QdPH
=yCaG
-----END PGP SIGNATURE-----

--V9E4GD/88frki9uz--
