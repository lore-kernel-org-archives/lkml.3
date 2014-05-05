Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaEESn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:43:59 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:26092
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751753AbaEESn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:43:56 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "patrik.r.jakobsson@gmail.com" <patrik.r.jakobsson@gmail.com>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH v2] mba6x_bl: Backlight driver for mid 2013 MacBook Air
Thread-Topic: [PATCH v2] mba6x_bl: Backlight driver for mid 2013 MacBook Air
Thread-Index: AQHPY7ZlKonnJSr2kkWANaJkxe8S4ZsyGv4AgAA9LYA=
Date: Mon, 5 May 2014 18:28:24 +0000
Message-ID: <1399314503.17557.0.camel@x230.lan>
References: <1398781312-3607-1-git-send-email-patrik.r.jakobsson@gmail.com>
	 <CAMeQTsYA0tGQ1SfhNhMctPW6H_y1NGjGXsM5ZcMSwOqE-bApyg@mail.gmail.com>
In-Reply-To: <CAMeQTsYA0tGQ1SfhNhMctPW6H_y1NGjGXsM5ZcMSwOqE-bApyg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(24454002)(189002)(199002)(74502001)(81542001)(31966008)(99396002)(81342001)(74662001)(80022001)(46102001)(101416001)(4396001)(76482001)(20776003)(36756003)(33646001)(79102001)(77982001)(83072002)(99286001)(86362001)(76176999)(50986999)(54356999)(19580395003)(92566001)(2656002)(87936001)(83322001)(19580405001)(85852003)(92726001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:48AB6B6B.EF05CFA9.63E3B1BA.C4E8DE60.200E4;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <54BB4096199C4146AB881DD6EA09B48C@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s45Ii99O004756

On Mon, 2014-05-05 at 16:49 +0200, Patrik Jakobsson wrote:
> Hi Matthew,
> 
> This seems to be in good shape. Do you have anything to add?
> If not, can you pick this patch up through platform-drivers-x86?

I'm a bit reluctant. Do we have any evidence that this is the way OS X
behaves? What's the actual difference in state before and after suspend?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
