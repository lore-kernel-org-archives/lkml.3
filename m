Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaEACdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:33:13 -0400
Received: from mail-bn1bon0076.outbound.protection.outlook.com ([157.56.111.76]:13856
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbaEACdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:33:11 -0400
X-Greylist: delayed 86546 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2014 22:33:11 EDT
From: "Austin, Brian" <Brian.Austin@cirrus.com>
To: Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Sangbeom Kim <sbkim73@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Timur Tabi <timur@tabi.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben-linux@fluff.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "Liam Girdwood" <lrg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Xia Kaixu <kaixu.xia@linaro.org>
Subject: Re: [alsa-devel] [PATCH 01/15] ASoC: CS42L51 and WM8962 codecs
 depend on INPUT
Thread-Topic: [alsa-devel] [PATCH 01/15] ASoC: CS42L51 and WM8962 codecs
 depend on INPUT
Thread-Index: AQHPZBwr9n+W/dYh4k6F7qQ+0txF0JsrRaCA//+ymgmAAFoUAA==
Date: Thu, 1 May 2014 02:16:27 +0000
Message-ID: <08914164-8CE6-4170-BC21-9E2840FFA05E@cirrus.com>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
 <alpine.DEB.2.02.1404292124270.31465@heelrod>,
 <20140501013103.GK3245@sirena.org.uk>
 <13D36045-EE68-418B-983B-2704C52391E3@cirrus.com>
In-Reply-To: <13D36045-EE68-418B-983B-2704C52391E3@cirrus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [141.131.3.55]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_8BADDBDF-DC81-44DD-AFC5-FABB77EAC2F0";
	protocol="application/pgp-signature"; micalg=pgp-sha512
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.128.20;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(377454003)(189002)(55674002)(51704005)(199002)(24454002)(77982001)(31966008)(46102001)(69556001)(92726001)(80976001)(66066001)(81542001)(81342001)(92566001)(80022001)(33656001)(71186001)(87936001)(4396001)(2656002)(74502001)(83072002)(83322001)(84326002)(99936001)(74662001)(19580405001)(76176999)(19580395003)(99396002)(82746002)(20776003)(83716003)(512944002)(86362001)(54356999)(76482001)(50986999)(44976005)(36756003)(6806004)(568964001)(79102001)(100906001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB013;H:mail2.cirrus.com;FPR:AC86D274.8E1C4DD2.F1ED9344.4A2EE4D.20183;MLV:sfv;PTR:mail2.cirrus.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: cirrus4.onmicrosoft.com
X-Forefront-PRVS: 01986AE76B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_8BADDBDF-DC81-44DD-AFC5-FABB77EAC2F0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Apr 30, 2014, at 8:54 PM, Austin, Brian <Brian.Austin@cirrus.com> =
wrote:

>=20
>=20
>> On Apr 30, 2014, at 20:31, "Mark Brown" <broonie@kernel.org> wrote:
>>=20
>>> On Tue, Apr 29, 2014 at 09:31:30PM -0500, Brian Austin wrote:
>>>=20
>>> I assume you mean the CS42L52 instead of the L51. INPUT is used for =
a BEEP
>>> Generator but when I disable CONFIG_INPUT I do not get an error. Is =
there
>>> any information available on what the error is?
>>=20
>> I suspect it's ASoC built in and INPUT build as a module.
> Ok, I'll try that next.
> Doesn't IS_ENABLED cover that?
Apparently not.
I would like to come up with a better solution than making INPUT a =
requirement. I just need some time.
In the meantime I suppose it=92s OK to apply it?=20

--Apple-Mail=_8BADDBDF-DC81-44DD-AFC5-FABB77EAC2F0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJTYa56AAoJEHdXZdGWfiO75eUH/2wC5eynvf3HIrcEfjHgrXS/
bZgi2r31Mp9wlvgmdLXj4gPgYs6kNIiHM/xMkcP9jnvCallm14WhdZMqy23gEult
40nwiLrJOp5VGTTQl5l5s0XWhG9J1WR1AI1g2mPKw0+6b1Sw1dOf0mOLzppGy8/6
jWRnGb6KULv1aXZJPkDUtl+z8h9E1s6F5TN10eFcONOxBLrFtyEl++obURdBgb/R
YW7QMDmf1cXl7ubuqG6Il2nbZQ6CPzJCcIInrWiHLYTjUDwstdijhvSfJcGoTwjO
7ppEyPmildJbE5mKBZyyq7BwhxDFLc4A33EN6Sk14NBWTb5LlGvhjHyJs6vmq7E=
=wNJa
-----END PGP SIGNATURE-----

--Apple-Mail=_8BADDBDF-DC81-44DD-AFC5-FABB77EAC2F0--
