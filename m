Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaEAMnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:43:14 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:21884
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750922AbaEAMnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:43:11 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2014 08:43:11 EDT
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
Thread-Index: AQHPZBwr9n+W/dYh4k6F7qQ+0txF0JsrRaCA//+ymgmAAFoUAIAAE/oAgABCmz8=
Date: Thu, 1 May 2014 12:26:18 +0000
Message-ID: <C1FD6191-8850-4BB1-ABA1-BE6D02F9CD84@cirrus.com>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
 <alpine.DEB.2.02.1404292124270.31465@heelrod>
 <20140501013103.GK3245@sirena.org.uk>
 <13D36045-EE68-418B-983B-2704C52391E3@cirrus.com>
 <08914164-8CE6-4170-BC21-9E2840FFA05E@cirrus.com>,<20140501032756.GM3245@sirena.org.uk>
In-Reply-To: <20140501032756.GM3245@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.128.20;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(51704005)(24454002)(55674002)(199002)(189002)(81342001)(85852003)(74502001)(2656002)(47776003)(87936001)(20776003)(99396002)(50466002)(33656001)(83716003)(76176999)(80976001)(77982001)(79102001)(92566001)(82746002)(44976005)(23746002)(31966008)(83322001)(76482001)(50986999)(86362001)(19580405001)(80022001)(92726001)(4396001)(54356999)(81542001)(36756003)(83072002)(74662001)(6806004)(46102001)(19580395003)(100906001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB061;H:mail2.cirrus.com;FPR:FE56D214.8F2E6D41.71E1834C.CA6FDE9.20149;MLV:sfv;PTR:mail2.cirrus.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: cirrus4.onmicrosoft.com
X-Forefront-PRVS: 01986AE76B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Apr 30, 2014, at 22:28, "Mark Brown" <broonie@kernel.org> wrote:
> 
>> On Thu, May 01, 2014 at 02:16:27AM +0000, Austin, Brian wrote:
>> 
>> Apparently not.
>> I would like to come up with a better solution than making INPUT a requirement. I just need some time.
>> In the meantime I suppose it’s OK to apply it?
> 
> Yeah.  Realistically it's probably not going to ever be a practical
> problem - the number of systems with audio but no input is likely to be
> very close to zero.

Yeah, I'm just gonna go ahead and remove the #if's from the drivers then since it's required 