Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab3GRL0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:26:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34581 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182Ab3GRLZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:25:59 -0400
Date: Thu, 18 Jul 2013 12:25:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20130718112538.GM22506@sirena.org.uk>
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
 <1374133720-27362-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0DcgAuOrObJpcAxl"
Content-Disposition: inline
In-Reply-To: <1374133720-27362-1-git-send-email-b.brezillon@overkiz.com>
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


--0DcgAuOrObJpcAxl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 09:48:40AM +0200, Boris BREZILLON wrote:
> clk_prepare/unprepare (and indirectly clk_prepare_enable/disable_unprepare)
> may sleep and thus cannot be called in critical section.

Applied, thanks.

--0DcgAuOrObJpcAxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR59CuAAoJELSic+t+oim9uD0P/Rizqwd6w1R1jav9/7eQU7s8
obtlowQjYTn36dfgG2jiOB3+XkUxiJl7aEhqnZQNcEYfBY/Ri64awQgoUbgiNKl7
p8wYyboC7NFRQAZ/Zs+hcHmz6jbJnOSbopgRooKi4qzBTBbO2XrmOqyRpRITYIiA
0yaMet7BYQ5Qgs8yjK63wZHkwAejv5nwtcAKYbYMXLGAAUMd3T2ptEhFCZAgEfnt
wHs5HYfq5R1EEumrIHiRMe97VGInn8WIdUFARu4Y8AjF6D0ZUs50oGr9RiK6jbK4
IbElDdf1/lztXfI5GMUW3KBaW4ldjXStN3IdUzcNDB9ROwl7VqQ0dvU5n2Wp9WDb
+9xoHfEsXF1SedGQqNAkEUx7O/cXd8lpuh49YxqhO15o0yuIXHEMRlzd7e9sYONJ
JAabeoRZTYNfXLn5eN8sq7+VH05HtXPZ0MCCgdWf4gadZE0BlBr1FP6sNYXUUaXo
gRtbntuluw2BZV0zlQCJIcz0wbYHzmd5sWUjsh4DhQYzLfEpDBkRAKIMZyDLY1rn
nW8YAftPj3zuE/V+6fH8WDG20dxdfX2VnLmEbP7TTvCAzF/V3LL/cRojTHsa/T7s
yikGqvRGNi1RFtYUs3iGi1/XvaK5uX0XchhvLSNywINH72xzJOAks+vBxZ8shEdJ
UuyamAbMzV92EaUfi3Pz
=xndv
-----END PGP SIGNATURE-----

--0DcgAuOrObJpcAxl--
