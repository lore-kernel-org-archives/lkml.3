Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKCN0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:26:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35424 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaKCN0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:26:00 -0500
Date: Mon, 3 Nov 2014 13:23:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20141103132352.GN3815@sirena.org.uk>
References: <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943>
 <1414579362.18868.11.camel@AMDC1943>
 <5450C63B.3000602@collabora.co.uk>
 <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
 <1414681386.26703.6.camel@AMDC1943>
 <CAAVeFuJo1wTyxOo4FEZM3=GTejuSHi+mnr=QV6HUeV5mAOCmqg@mail.gmail.com>
 <1414741898.20071.8.camel@AMDC1943>
 <20141031103217.GJ18557@sirena.org.uk>
 <1415016422.4241.28.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ie5iOtK4e9kgqh2F"
Content-Disposition: inline
In-Reply-To: <1415016422.4241.28.camel@AMDC1943>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ie5iOtK4e9kgqh2F
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 01:07:02PM +0100, Krzysztof Kozlowski wrote:
> On pi=C4=85, 2014-10-31 at 10:32 +0000, Mark Brown wrote:

> > We could always add a callback for the driver to handle any custom
> > properties...  one of the advantages of an OS like Linux is that we can
> > improve the core code.

> I thought about this - adding a callback, called on each child in
> regulator_of_get_init_data(). However the reason behind this callback is
> to parse GPIO and set config.ena_gpio. However in that context the
> regulator_config is const so the callback cannot change it. Unless it
> casts it to non-const... which isn't what we want I think.

> So now I wonder whether adding generic bindings for ena_gpio make sense.
> These would look like bindings for fixed-regulator (with "ena-" prefix).
> Unfortunately this would duplicate a little the ena_gpio in
> regulator_config... but to me it seems more appropriate.

> What do you think about adding generic bindings for ena_gpio?

Well, if you only want this for enable GPIO control (sorry, I'm really
not reading a lot of these long threads when it looks like there'll be a
resubmit anyway) we can always add a way for drivers to specify the name
of a property to look at easily enough.

--Ie5iOtK4e9kgqh2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV4HnAAoJECTWi3JdVIfQeJ4H/iHv+IReYh2qELgYqwBgn4At
1IBM1/+RC0Kwrr6ZC0Lgtk3ooAzMMnc+I0zaKECKKqq8C0S2N1Jy+K3p9eu7vCFQ
OFzpcYnhsadjtnnAfrUZQ1l7atTmEUXvk8Wp7gZwoOcpD9ijNmDHYxZyqyOwDMBF
3pRnwx5vkSWv9mvuMd05Gdc855NCOwTVYdYJELwSgpJO9AQd8czltzkdctoaAh3l
eDyEG+kObWU5Zq9EAL9i4HhDKqi7Isjl3fQIMj1IBMuWRaGh51BtKGcExfn93OSa
vMSq1GDVDeNKl6XKfo/NeDNSt4xICWpnm+P8fjUzqBM5DWmGLLmf85uQkmbZWxQ=
=RRTU
-----END PGP SIGNATURE-----

--Ie5iOtK4e9kgqh2F--
