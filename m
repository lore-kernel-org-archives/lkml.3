Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab3GVT7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:59:34 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:33673 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3GVT7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:59:32 -0400
From: "Chaiken, Alison" <Alison_Chaiken@mentor.com>
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Wolfram Sang <w.sang@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: RE: The future of DT binding maintainership
Thread-Topic: The future of DT binding maintainership
Thread-Index: AQHOhUQGFUX0uulexkaGZaPJsCmPZJluCrCAgAMP5bk=
Date: Mon, 22 Jul 2013 19:59:25 +0000
Message-ID: <60BA5429A0E1584BA3633194F6F993B502B21362@NA-MBX-03.mgc.mentorg.com>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com>
 <20130720034647.2B7B43E14BF@localhost>,<2962401.WRRoYlXkRr@flatron>
In-Reply-To: <2962401.WRRoYlXkRr@flatron>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [147.34.91.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Jul 2013 19:59:27.0235 (UTC) FILETIME=[F86E1530:01CE8715]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> Another thing discussed is that we need to start validating DT schema with an extension to dtc.

Is there a schema out there in the wild that exemplifies what you mean?

> Tomasz Figa has volunteered to do this work and has support from his employer

That's great news.

> to have is that the DT schema will get checked as part of the dts build
> process so that any DT file that doesn't match the documented schema
> will get flagged, and that the schema files will be human readable and
> will double as documentation.

No doubt DTS files are already the best documentation available for many targets.    The vendor's technical reference manual describes how the hardware is supposed to work, but the DTS describes what actually does.   Any errata that the vendor issues subsequent to publication of the TRM must be reflected in DTS, after all.

The schema-check idea reminds me of the W3C HTML validators:

      http://validator.w3.org/

Since device-tree source looks a bit like XML (or maybe more like JSON), will be the schemas be similar in spirit to DTDs, and is it helpful to think of the validator in this spirit?   Or will the checker be more like "gcc -Wall", since it will be invoked by a compiler?

-- Alison
