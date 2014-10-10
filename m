Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaJJGQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 02:16:29 -0400
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:1489
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750982AbaJJGQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 02:16:27 -0400
X-Greylist: delayed 72345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2014 02:16:27 EDT
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>, Joseph Lo <josephl@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] serial: of-serial: fix up PM ops on no_console_suspend
Thread-Topic: [PATCH] serial: of-serial: fix up PM ops on no_console_suspend
Thread-Index: AQHP46dGRJKFTuLoMU2a/EicZwVioJwoyCKAgAAOnFA=
Date: Fri, 10 Oct 2014 06:16:24 +0000
Message-ID: <01583b7f252b4f81a5655009f6f73aba@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1412845852-26157-1-git-send-email-jingchang.lu@freescale.com>
 <543768F3.6090703@wwwdotorg.org>
In-Reply-To: <543768F3.6090703@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB467;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(51704005)(13464003)(199003)(479174003)(377454003)(76576001)(66066001)(120916001)(97736003)(76482002)(20776003)(2501002)(101416001)(31966008)(64706001)(19580395003)(19580405001)(99396003)(50986999)(85852003)(99286002)(95666004)(76176999)(54356999)(108616004)(92566001)(40100002)(122556002)(106116001)(86362001)(105586002)(2656002)(87936001)(85306004)(74316001)(4396001)(33646002)(80022003)(107046002)(46102003)(21056001)(106356001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB371;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9A6GdfP003930

>-----Original Message-----
>From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>Sent: Friday, October 10, 2014 1:05 PM
>To: Lu Jingchang-B35083; gregkh@linuxfoundation.org
>Cc: arnd@arndb.de; Joseph Lo; linux-kernel@vger.kernel.org; linux-
>serial@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>Subject: Re: [PATCH] serial: of-serial: fix up PM ops on
>no_console_suspend
>
>On 10/09/2014 02:10 AM, Jingchang Lu wrote:
>> Mandatorily disabling the uart clock will cause register access hung
>> on "no_console_suspend". This patch add condition check on it and only
>> disable the clock with console_suspend_enabled true.
>
>It would be useful if the email/patch subject line said "V2", and there
>was a changelog below.
This is not a v2, patch "serial: of-serial: add PM suspend/resume support
(commit 2dea53bf57783f243c892e99c10c6921e956aa7e)" has been merged into
linux-next tree, this is a fixup on that PM ops.
Thanks.

Best Regards,
Jingchang 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
