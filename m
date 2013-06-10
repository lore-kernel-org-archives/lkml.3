Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3FJPZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:25:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58916 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3FJPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:25:11 -0400
Date: Mon, 10 Jun 2013 16:25:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Message-ID: <20130610152507.GF1403@sirena.org.uk>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdbygDNdsO=EzigPiBSnMmF-NVnF95HeBBavkry93i+ubQ@mail.gmail.com>
 <20130610151208.GK20297@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qp4W5+cUSnZs0RIF"
Content-Disposition: inline
In-Reply-To: <20130610151208.GK20297@gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/10] regulator: ab8500-ext: Refactorings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qp4W5+cUSnZs0RIF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 04:12:08PM +0100, Lee Jones wrote:

> The 'ux500: regulator_supply' patch, relies on the 'regulator:
> supply_name' one however. Mark has taken two of them, I don't know why
> the others were missed/intentionally left.

> Mark, was there a reason for this?

IIRC they were more involved and since you decided to pick a random
e-mail address to send them to that goes nowhere near the mailboxes I
use for upstream they're not going to bubble up particularly quickly.

--qp4W5+cUSnZs0RIF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRte/QAAoJELSic+t+oim9QrIP/jXzThhKqrc63wNG/pVaC0Iz
TdZ1a6CDGGYT4azvcAVj1B8tusXyX+HBIpFJfwbzQ+ywH+jCj82lKCOOotAzQIiI
Gw/q4q5pGZBGZyf7zlZtn2hcRVHeFnUn51pDP8jrQz32S520orB1Mp6pHCvecM8M
Y5WCNkVXfL0Wc1xmp6QtNzohkeJA1SwSlkqUUlHRr+yXWoSAk+kkHyhCLKHCORfG
g6uuyjAnsbqw2UPupQD9pfgsWvcOsV5Rflxrl0Qf/r7lqtht9FFA+2wN9Km0bkTu
7KKAQbzplQNZysNrpBDPzYCcFm7QLMOsXrgE5ZklmKPqGU3BaY0wmcmZOzy0prwD
KZBFlavV1CYwATB8suhliZwUsxWFEPtHTrNvQMXnC7w5lXv1WzGUp/10DXgY8sKP
6QB1n2Bn8ZnS1Y+nQKc/Fm9QQoxkbl6PT+nbyq+a51uANBMJhzRlI3CsnHQh4q/g
OmsOPaW2uk0Z/znSvRx/9xirveHmRpzncOb+sVoshREsvQJ+hRPokfE/8gStE00J
WgDwYKHIlqYLaRjeYhdSA0hqlv9pvTUA4pRdMaT5uXE+gMBnQUOml1T6WjpbloxL
ZyrpQqAPQKrZ80OTF6tnIp/y0sMnQhjATboZZA/NgEVoFpN2iqcFVnlJ8DVxLjIK
n0MsGamPTmjdJOUAVwXy
=UjbP
-----END PGP SIGNATURE-----

--qp4W5+cUSnZs0RIF--
