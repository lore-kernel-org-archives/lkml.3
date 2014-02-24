Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaBXPwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:52:38 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:10484
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbaBXPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:52:35 -0500
X-Forefront-Antispam-Report: CIP:141.131.128.20;KIP:(null);UIP:(null);IPV:NLI;H:mail2.cirrus.com;RD:mail2.cirrus.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz1432Ide40hzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de097hz2dh109h2a8h839hd25he5bhf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1b2bh1bceh2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2052h20b3h20f0h2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh34h1155h)
From: "Austin, Brian" <Brian.Austin@cirrus.com>
To: Mark Brown <broonie@kernel.org>
CC: Nicolin Chen <Guangyu.Chen@freescale.com>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
Thread-Topic: [PATCH] ASoC: cs42888: Add codec driver support
Thread-Index: AQHPMS1KzgusFkzpNEqgijBE3/gW+5rEqciAgABJRAA=
Date: Mon, 24 Feb 2014 15:52:24 +0000
Message-ID: <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
In-Reply-To: <20140224113011.GE25940@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [141.131.125.90]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_40263A3A-2A6A-4855-9209-EDC777C5FD00";
	protocol="application/pgp-signature"; micalg=pgp-sha512
MIME-Version: 1.0
X-OriginatorOrg: cirrus.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_40263A3A-2A6A-4855-9209-EDC777C5FD00
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


>=20
>> +	/* Disable auto-mute */
>> +	regmap_update_bits(cs42888->regmap, CS42888_TXCTL,
>> +			   CS42888_TXCTL_AMUTE | =
CS42888_TXCTL_DAC_SZC_MASK,
>> +			   CS42888_TXCTL_DAC_SZC_SR);
>=20
> Does this interfere with the manual mute controls or is it a separate
> thing?  If it plays nicely with the manual controls it's probably =
better
> to leave it enabled since it improves performance in some benchmarks
> (that's why hardware tends to have the feature).

Auto-Mute should be enabled by default.

>=20
>> +	if (!IS_ERR(cs42888->clk))
>> +		clk_disable_unprepare(cs42888->clk);
>=20
> Does the device work without MCLK?
Yes, MCLK is required. If you can=92t get the clock you should error =
out.



--Apple-Mail=_40263A3A-2A6A-4855-9209-EDC777C5FD00
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJTC2q4AAoJEHdXZdGWfiO70PIIALSgC5o02guz257kMTsyIXyQ
tT+onHYqqS6ogOZwowzXu18KkX4GqSE/8hrrBf+bBTgGKoo8+TTydpUGfs8pT66B
ttHKs0t+zMml55NzZUVGrejO5+3qy5OTMql9Prv3jMkKpZeGLCIy0dA3gWtwJ0Rl
8R/OL+ti3XtLofZWKUyO4jYNB1+Air0iTX5PBg/jBe4mmi1CUfxhI2xZtiKM8Ut6
OiKn14p9nHiAeojDT3hlnHs1a6mc3wsuE8Hpgc1d2+3llyxgFOrazySsdlEN96x0
0kr5BQJtczTPKl7FQr3CqkmPRC1iSk0KM+oKRYo3x8zIRIun4160mokgX0G0l5w=
=XQjd
-----END PGP SIGNATURE-----

--Apple-Mail=_40263A3A-2A6A-4855-9209-EDC777C5FD00--
