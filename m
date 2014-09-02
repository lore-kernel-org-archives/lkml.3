Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaIBUkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:40:15 -0400
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:42587
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755182AbaIBUkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:40:12 -0400
X-Greylist: delayed 7166 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2014 16:40:12 EDT
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>
Subject: Re: [PATCH] platform/x86: toshiba: re-enable acpi hotkeys after
 suspend to disk
Thread-Topic: [PATCH] platform/x86: toshiba: re-enable acpi hotkeys after
 suspend to disk
Thread-Index: AQHPxthjo7nvPexNjUyJAU6TWqL8u5vuI8YA
Date: Tue, 2 Sep 2014 18:07:19 +0000
Message-ID: <1409681238.11717.4.camel@nebula.com>
References: <1409681059-6493-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1409681059-6493-1-git-send-email-benjamin.tissoires@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2602:243:200f:a924:6267:20ff:fec3:2318]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0322B4EDE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019013)(6009001)(24454002)(189002)(377424004)(199003)(51704005)(76482001)(107046002)(87936001)(2351001)(81342001)(95666004)(77096002)(74662001)(74502001)(31966008)(92726001)(92566001)(83072002)(85852003)(106356001)(105586002)(99286002)(77982001)(110136001)(79102001)(106116001)(46102001)(2656002)(36756003)(103116003)(85306004)(4396001)(33646002)(90102001)(99396002)(20776003)(50986999)(64706001)(81542001)(21056001)(19580405001)(83322001)(19580395003)(80022001)(76176999)(54356999)(101416001)(86362001)(2501002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <66DFC075F5AC3E4390690B19BBBA0B0F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s82KeLRc016097

On Tue, 2014-09-02 at 14:04 -0400, Benjamin Tissoires wrote:

> we noticed this problem on a Toshiba Z40. I kind of brute-forced the thing, and
> I ended up that calling "ENAB" was making the keys working again (rmmod/insmod 
> the driver was sufficient, and the only command which was different from the
> resume was this ACPI call).
> 
> I am really surprised some toshiba laptops do not need this, so I'd prefer that
> an ACPI expert (Matthew???) gives its wisdom regarding that.

Looks good to me. I'd be surprised if this breaks anything.

Acked-by: Matthew Garrett <matthew.garrett@nebula.com>

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
