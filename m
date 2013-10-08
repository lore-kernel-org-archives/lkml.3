Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3JHQT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:19:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34684 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3JHQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:19:54 -0400
Date: Tue, 8 Oct 2013 17:19:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131008161930.GG21581@sirena.org.uk>
References: <CACQ1gAhNFTdG_2OCTnsOCaBozHnGb9EwAGHT5+f=cARRpC_WBg@mail.gmail.com>
 <20131008121326.GB21581@sirena.org.uk>
 <CACQ1gAjzanaYgP-pW0a+ahb+byH1FtAYp-Apfnc_LnUgpAiuCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2ctSxJPqE6GQjdSc"
Content-Disposition: inline
In-Reply-To: <CACQ1gAjzanaYgP-pW0a+ahb+byH1FtAYp-Apfnc_LnUgpAiuCg@mail.gmail.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [BUG] spi/spi-atmel: DMA rx buffer corruption with
 SPI_IOC_MESSAGE
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2ctSxJPqE6GQjdSc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2013 at 02:52:58PM +0200, Richard Genoud wrote:

> thanks !
> here it is. (I hope !! Since this morning, I have a *very*
> discontinued internet acces with small shooting windows)

Got it.

--2ctSxJPqE6GQjdSc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVDCPAAoJELSic+t+oim9n4gQAJFQyyL/8Ie05SNk7SrwmaSD
TiU128XWj0lQJgAr7GDduidML+geCbmPbgOERfDIR7v7zAzFws8qwvEUNqSdw7De
03zgDO5/GefTOdjFiitfievXUrfieolMIusGA8LVNrfI0CYROxTDjRU3KIoA/Czu
2zHCQ9G5fW6iJDxip/8MAeTa5RWDNFkF4eJ0kocPeEOLlJC755pvGQVs5dZ46tgu
eC3gfSHVkOrru2+lNSM2CKSWNv2PG+seGdW7NjYQ/WXFE2hMKnq3yWbsTE4iCsSu
R2QlcEk9AoEIYRvD00NRbEYFxO5pV7LKCI5RuON8BSkwWSWc1NfqHNq1zEsWx9iP
5diJkE5dm98369htNrcw24a9D5jHGq4BKfKcm9OzYyhEgO8uijWYJMGFSDR+UyDn
TZALYDPr5DzwDos2kHI5+KO1gXKacZPue2R943u1pk/wYGcJKPvsyR+yCwKdt/Ug
3fqwsCqZsKAMnroEpStFDco2mqL6RTJsDoCRJkpgpLFvEBGQve9nEYooPwxNXvnJ
21AaAWykmGBsAHBf6LnESrh+CP0R67nhPzT3k1SRrkMSMW4/A9c+VimSlpOZA0wg
lNwiNfFVEUJZP4PWtHhk+tn6fpXrHPpfPOmkM4+yUliufQuf7Jg+OHmv0wmJqYxd
kNXfgyOXPAlGBAJBad17
=wmsl
-----END PGP SIGNATURE-----

--2ctSxJPqE6GQjdSc--
