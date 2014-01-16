Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaAPOmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:42:00 -0500
Received: from [207.46.163.185] ([207.46.163.185]:17936 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752685AbaAPOl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:41:58 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "gsi@denx.de" <gsi@denx.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] net/dt: Add support for overriding phy configuration
 from device tree
Thread-Topic: [PATCH] net/dt: Add support for overriding phy configuration
 from device tree
Thread-Index: AQHPEjo8iPjq+YyTXECb5rF9nP7rnpqHYceAgAALcoA=
Date: Thu, 16 Jan 2014 14:40:04 +0000
Message-ID: <1389883203.3720.7.camel@x230>
References: <1389821938-3126-1-git-send-email-matthew.garrett@nebula.com>
	 <20140116135905.GV20094@book.gsilab.sittig.org>
In-Reply-To: <20140116135905.GV20094@book.gsilab.sittig.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(689001)(679001)(779001)(377424004)(189002)(199002)(24454002)(49866001)(83322001)(47736001)(92566001)(93136001)(4396001)(33716001)(46102001)(50986001)(65816001)(47976001)(63696002)(19580405001)(53806001)(19580395003)(77096001)(79102001)(51856001)(54356001)(80976001)(92726001)(76796001)(76786001)(33646001)(56776001)(54316002)(76482001)(59766001)(77982001)(47446002)(74876001)(87936001)(74502001)(85306002)(69226001)(81686001)(81816001)(80022001)(2656002)(74662001)(74706001)(74366001)(85852003)(56816005)(90146001)(31966008)(81342001)(87266001)(81542001)(93516002)(83072002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1D6848520A6B54591A734AE58731706@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0GEg76T018377

On Thu, 2014-01-16 at 14:59 +0100, Gerhard Sittig wrote:

> These properties are booleans, and optional?  Does it mean that
> you cannot _disable_ broken features?  Or does it mean that you
> _must_ specify the non-broken features and thus break backwards
> compatibility?  Or are these properties not boolean (they are not
> used in the example either, unfortunately), and the binding text
> would need an update for clarity?  What am I missing?

They're not booleans. I'll update the text to make that clear.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
