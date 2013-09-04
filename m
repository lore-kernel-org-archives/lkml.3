Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000Ab3IDFvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:51:48 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:41867
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755924Ab3IDFvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:51:47 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas.Mingarelli@hp.com" <Thomas.Mingarelli@hp.com>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 1/2] Move and rename HP watchdog timer driver
Thread-Topic: [PATCH 1/2] Move and rename HP watchdog timer driver
Thread-Index: AQHOqS/cw8QEpiygLECLA27YDSjc6pm1EPwAgAACTIA=
Date: Wed, 4 Sep 2013 05:51:41 +0000
Message-ID: <1378273901.11730.53.camel@x230>
References: <1378272591-9755-1-git-send-email-matthew.garrett@nebula.com>
	 <5226C880.8010704@roeck-us.net>
In-Reply-To: <5226C880.8010704@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(189002)(199002)(377424004)(74502001)(47446002)(33716001)(76796001)(76786001)(74662001)(77982001)(59766001)(54356001)(79102001)(81686001)(33646001)(65816001)(74706001)(80022001)(74876001)(77096001)(56816003)(69226001)(31966008)(19580395003)(74366001)(4396001)(81542001)(50986001)(47976001)(51856001)(83072001)(46102001)(63696002)(80976001)(81816001)(76482001)(54316002)(56776001)(53806001)(49866001)(47736001)(81342001)(19580405001)(83322001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <88237D708F7B1C49BFFFC5CA274CA19A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r845proG019959

On Tue, 2013-09-03 at 22:43 -0700, Guenter Roeck wrote:

> If that is the case, wouldn't it make more sense to have separate drivers,
> one per functionality, plus an mfd driver to bind them all together ?

It'd be an option, but I don't think there's a huge benefit - the
functionality's reasonably related and there's no real internal bus
architecture on the device.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
