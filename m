Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab3ICMHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:07:32 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:2081
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759968Ab3ICMHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:07:31 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] samsung-laptop: fix config build error
Thread-Topic: [PATCH] samsung-laptop: fix config build error
Thread-Index: AQHOn1GYZM5kx6QF6k20rHUqDSNYppmz/asA
Date: Tue, 3 Sep 2013 12:07:27 +0000
Message-ID: <1378210046.11730.6.camel@x230>
References: <521636FF.7090008@infradead.org>
In-Reply-To: <521636FF.7090008@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 09583628E0
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(199002)(189002)(51704005)(377424004)(65816001)(80022001)(66066001)(69226001)(77982001)(59766001)(79102001)(54356001)(56816003)(76482001)(53806001)(77096001)(558084003)(83072001)(54316002)(63696002)(56776001)(51856001)(19580395003)(19580405001)(83322001)(33716001)(81816001)(74366001)(81686001)(49866001)(47736001)(4396001)(47976001)(50986001)(81542001)(81342001)(80976001)(31966008)(74662001)(74876001)(74706001)(33646001)(76786001)(46102001)(76796001)(47446002)(74502001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <80CFA419E7CE0A4EB1789BD682AB23BB@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r83C7bqU013951

On Thu, 2013-08-22 at 09:06 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build failure when ACPI_VIDEO=m and SAMSUNG_LAPTOP=y.
> The patch prevents that specific config combination.

Applied, thanks.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
