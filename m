Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3KRPRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:17:25 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42490 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3KRPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:17:17 -0500
Date: Mon, 18 Nov 2013 15:16:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com
Message-ID: <20131118151651.GE24408@sirena.org.uk>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
 <1384438956-31153-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaccxcTfKc-y7rPEH1H3yua3ubLvuvTzWnMs1rOwjiVNw@mail.gmail.com>
 <20131118093229.GB13640@lee--X1>
 <20131118133940.GC14306@sirena.org.uk>
 <20131118142447.GJ13640@lee--X1>
 <20131118144512.GB24408@sirena.org.uk>
 <20131118145614.GM13640@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="phCU5ROyZO6kBE05"
Content-Disposition: inline
In-Reply-To: <20131118145614.GM13640@lee--X1>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 31.115.204.151
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/10] mtd: st_spi_fsm: Supply all register address and
 bit logic defines
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--phCU5ROyZO6kBE05
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 18, 2013 at 02:56:14PM +0000, Lee Jones wrote:

> I think it's a good idea for people using the m25p80, but still
> doesn't effect us. All of our chips are dynamically probable. We are

This doesn't seem realistic, you're assuming that system integrators
won't go and use chips you've not heard of and at least in the case of
things like quad read my understanding is that the commands aren't
standardised so the host just has to know what to write.

--phCU5ROyZO6kBE05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSii9gAAoJELSic+t+oim97VMQAIr/c+A1QBszwCN/PYourA/2
buiZBEUuCQdCtOa5UfDmXb6FowgakhFvnIQbprHnGD2TeVN6wQT8XFDhw8WIbGvo
G63QVPz9pxGMKBTSSf9Obdlcsw7eBKopuXB75W+der2C3H6nj6mL1naOy4YbJKDv
bf0xYmRiBAKdxlU0gcIWXbx9ddb2q2jTKBO6JaWVhbHmjbASQJ7SQP1G/22SJqka
/Wqc8W2A3R1zyaSIlu6sD3CoNZPSN5fgpml8V+8GCY6k4EQHDlJ9Gh0Pt+f4jKXG
BgMZvyfzlClMXHxMwXnwp0sQ/meSPo7sxY4nr9hGTAvXCvx4ZiVsD4LdLnI32Bgk
cjdhKoUT1IVajvvO8fNtoK5hkwM4bBzRv5GCgu/yrhEtjlZQQTtrqtSTBpG4uo81
XnF4kEX0z9yh39w6e1297xJ+Alm8pVKbVB5pP6KRtyLNh59kZtC6EUdeMBv7FQwn
DYM24YEyeA4p/kuIcT9iCnQssjA7kHivOdVEeP1j1os8aAgYht3g8djiqJ6gC1oS
vMWGCYQm6fgJsW5a6v+uHeEaIrJ7LVWVNig9VMzER0ZEfHX71l+/D2IIeTuyXIYb
pOUvoxNABX24S5ACZNDBaYcEE0XyDSc55hHP4119DJF4JIh2M+XvTIQIaRJxOouE
x5I7vHxlInLnNOL81X7o
=/UnB
-----END PGP SIGNATURE-----

--phCU5ROyZO6kBE05--
