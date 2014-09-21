Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaIUXxI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 19:53:08 -0400
Received: from mail-bl2on0146.outbound.protection.outlook.com ([65.55.169.146]:30055
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751194AbaIUXxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 19:53:06 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: nick <yocto6@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "himangi774@gmail.com" <himangi774@gmail.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: FIX ME in  oxu210p-hcd.c
Thread-Topic: FIX ME in  oxu210p-hcd.c
Thread-Index: AQHP1PgEnm/39G8KQ0aBJF+T0X3g1pwMRAsA
Date: Sun, 21 Sep 2014 23:53:01 +0000
Message-ID: <2d062bb368d94327b89cba3d547bff9d@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <541DB6BF.7090909@gmail.com> <541DB8C1.2000101@gmail.com>
In-Reply-To: <541DB8C1.2000101@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(6009001)(189002)(199003)(51704005)(74662003)(74502003)(79102003)(2501002)(76482002)(107046002)(21056001)(77096002)(90102001)(81542003)(66066001)(108616004)(95666004)(74316001)(77982003)(85306004)(81342003)(46102003)(106116001)(99286002)(33646002)(80022003)(76576001)(97736003)(92566001)(2656002)(99396002)(50986999)(54356999)(20776003)(83072002)(83322001)(31966008)(4396001)(86362001)(76176999)(85852003)(64706001)(105586002)(101416001)(106356001)(120916001)(87936001)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0772;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8LNrX7h025214


 
> Subject: Re: FIX ME in oxu210p-hcd.c
> 
> 
> I found a unfixed FIX ME in the file stated in my above message. I am
> wondering what to set hcd->self.comtroller->dma_mask to as it's now been
> defined to NULL and clearly even as a newbie this seem incorrect.
> Regards Nick

Usually, it is set at its controller driver or pass through through device tree or
platform data.

Peter
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
