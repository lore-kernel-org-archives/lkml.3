Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaL3DD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:03:57 -0500
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:50528
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbaL3DD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:03:56 -0500
X-Greylist: delayed 5731 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2014 22:03:56 EST
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "crmafra2@gmail.com" <crmafra2@gmail.com>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andreas.noever@gmail.com" <andreas.noever@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
Subject: Re: Bisected regression from 3.17 still present in 3.19-rc1
Thread-Topic: Bisected regression from 3.17 still present in 3.19-rc1
Thread-Index: AQHQIs7zn+FVxla+ME6mkETDKfie05ynWisA
Date: Tue, 30 Dec 2014 01:28:21 +0000
Message-ID: <1419902900.25226.0.camel@nebula.com>
References: <20141228185409.GA2015@linux-g29b.site>
In-Reply-To: <20141228185409.GA2015@linux-g29b.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [185.40.134.3]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR05MB422;
x-forefront-prvs: 04410E544A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(377424004)(189002)(92566001)(21056001)(103116003)(97736003)(33646002)(19580395003)(2351001)(86362001)(110136001)(31966008)(66066001)(76176999)(46102003)(50986999)(2501002)(87936001)(120916001)(15975445007)(20776003)(36756003)(101416001)(40100003)(1411001)(4396001)(122556002)(99286002)(102836002)(106116001)(64706001)(2950100001)(62966003)(2656002)(77156002)(105586002)(19580405001)(99396003)(68736005)(54356999)(2900100001)(107046002)(106356001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E4E4ED4E2FD1441996A886987D4AAA2@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2014 01:28:21.2530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9cc6df8-58db-46f5-bf3e-083732d8ac63
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR05MB422
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBU347Po019531

On Sun, 2014-12-28 at 18:54 +0000, Carlos R. Mafra wrote:
> The laptop is a 2-year-old macbook Pro with retina display.
> 
> I use a dockapp called wmlaptop2 (http://repo.or.cz/w/wmlaptop2.git)
> which, among other things, displays battery information (% of charge
> remaining etc).
> 
> With the kernel v3.17 the battery information stopped working and it
> still does not work in the latest v3.19-rc1.

What is CONFIG_ACPI_SBS set to?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
