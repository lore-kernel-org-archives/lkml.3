Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaBRXZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:25:31 -0500
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:17777
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754443AbaBRXZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:25:26 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rjw@rjwysocki.net" <rjw@rjwysocki.net>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq7qAMA///+lK+AAAEmgA==
Date: Tue, 18 Feb 2014 23:25:02 +0000
Message-ID: <1392765901.3488.4.camel@x230.lan>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <1511662.Ly2fOjCGKz@vostro.rjw.lan> <1392765307.3488.1.camel@x230.lan>
	 <1920764.8Poj9R8nZQ@vostro.rjw.lan>
In-Reply-To: <1920764.8Poj9R8nZQ@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377454003)(189002)(199002)(377424004)(51704005)(24454002)(80976001)(85306002)(47446002)(49866001)(86362001)(87936001)(81542001)(31966008)(4396001)(36756003)(92726001)(19580405001)(74502001)(19580395003)(77982001)(69226001)(81342001)(74662001)(74366001)(56816005)(85852003)(76786001)(46102001)(93136001)(51856001)(90146001)(92566001)(65816001)(80022001)(87266001)(79102001)(94316002)(63696002)(76482001)(77096001)(54316002)(59766001)(47976001)(83322001)(76796001)(50986001)(47736001)(93516002)(33646001)(83072002)(2656002)(54356001)(53806001)(74706001)(95416001)(56776001)(95666001)(81816001)(94946001)(81686001)(74876001)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:FCFAE2B3.2627CCE9.EFFA1D9F.5CD0C130.2011C;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6E8F948C4395B4CB4D02C334751587E@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1INPwRU000393

On Wed, 2014-02-19 at 00:35 +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 18, 2014 11:15:08 PM Matthew Garrett wrote:
> > For example, if you load the ACPI power meter driver before you've
> > installed the ACPI IPMI driver you'll typically get failures (most
> > vendors implement it via IPMI).
> 
> Well, any specific machine from any specific vendor?

The Dell R720 and HP DL385 both seem to have this configuration. I
believe some Ciscos do, too.
-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
