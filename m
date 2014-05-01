Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaEACK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:10:28 -0400
Received: from mail-bn1on0075.outbound.protection.outlook.com ([157.56.110.75]:34612
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750816AbaEACK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:10:26 -0400
From: "Austin, Brian" <Brian.Austin@cirrus.com>
To: Mark Brown <broonie@kernel.org>
CC: Xia Kaixu <kaixu.xia@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>, "arnd@arndb.de" <arnd@arndb.de>,
        Sangbeom Kim <sbkim73@samsung.com>, "Timur Tabi" <timur@tabi.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] [PATCH 01/15] ASoC: CS42L51 and WM8962 codecs
 depend on INPUT
Thread-Topic: [alsa-devel] [PATCH 01/15] ASoC: CS42L51 and WM8962 codecs
 depend on INPUT
Thread-Index: AQHPZBwr9n+W/dYh4k6F7qQ+0txF0JsrRaCA//+ymgk=
Date: Thu, 1 May 2014 01:54:00 +0000
Message-ID: <13D36045-EE68-418B-983B-2704C52391E3@cirrus.com>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
 <alpine.DEB.2.02.1404292124270.31465@heelrod>,<20140501013103.GK3245@sirena.org.uk>
In-Reply-To: <20140501013103.GK3245@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.128.20;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(24454002)(189002)(51704005)(199002)(23726002)(92566001)(76482001)(54356999)(82746002)(99396002)(50466002)(83716003)(92726001)(31966008)(6806004)(19580395003)(19580405001)(44976005)(83322001)(46102001)(47776003)(97756001)(76176999)(77982001)(81542001)(36756003)(46406003)(74662001)(2656002)(20776003)(81342001)(80022001)(33656001)(4396001)(80976001)(79102001)(87936001)(83072002)(74502001)(50986999)(86362001)(100906001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB020;H:mail2.cirrus.com;FPR:AC864274.8CB48ED2.F9DF1326.4E2EB41.20114;MLV:sfv;PTR:mail2.cirrus.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: cirrus4.onmicrosoft.com
X-Forefront-PRVS: 01986AE76B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Apr 30, 2014, at 20:31, "Mark Brown" <broonie@kernel.org> wrote:
> 
>> On Tue, Apr 29, 2014 at 09:31:30PM -0500, Brian Austin wrote:
>> 
>> I assume you mean the CS42L52 instead of the L51. INPUT is used for a BEEP
>> Generator but when I disable CONFIG_INPUT I do not get an error. Is there
>> any information available on what the error is?
> 
> I suspect it's ASoC built in and INPUT build as a module.
Ok, I'll try that next.
Doesn't IS_ENABLED cover that?
