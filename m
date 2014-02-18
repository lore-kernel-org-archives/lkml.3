Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaBRXPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:15:20 -0500
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:47095
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754340AbaBRXPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:15:13 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rjw@rjwysocki.net" <rjw@rjwysocki.net>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq7qAMA///89oA=
Date: Tue, 18 Feb 2014 23:15:08 +0000
Message-ID: <1392765307.3488.1.camel@x230.lan>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <1511662.Ly2fOjCGKz@vostro.rjw.lan>
In-Reply-To: <1511662.Ly2fOjCGKz@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(51704005)(189002)(199002)(377454003)(377424004)(83072002)(81342001)(51856001)(74706001)(76796001)(19580395003)(83322001)(80022001)(94946001)(76786001)(19580405001)(90146001)(74366001)(85852003)(81542001)(74876001)(56776001)(54356001)(53806001)(94316002)(74502001)(76482001)(47446002)(46102001)(81816001)(81686001)(74662001)(59766001)(56816005)(77982001)(65816001)(87936001)(49866001)(63696002)(80976001)(77096001)(93136001)(93516002)(92566001)(36756003)(47736001)(69226001)(33646001)(4396001)(31966008)(95666001)(50986001)(2656002)(54316002)(95416001)(85306002)(86362001)(47976001)(87266001)(92726001)(79102001)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:F0FEF1A3.2E0715E9.EBF4B9BE.88E5E03C.201CB;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD61B0A8EF59C54D974E556B5FF0133D@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1INFVwO032572

On Wed, 2014-02-19 at 00:26 +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 18, 2014 11:28:29 AM Matthew Garrett wrote:
> > 
> > The ACPI IPMI driver implements IPMI operation region support for the ACPI
> > core. Systems that declare ACPI operation regions may reference them at any
> > time, including during kernel initialisation. These accesses will fail
> > unless the ACPI IPMI driver is present, and undesirable system behaviour
> > may result. Set the default to Y in order to encourage distributions and
> > users to configure kernels to avoid awkward surprises.
> 
> Do you have any examples of problems caused by that or is this just theoretical
> at the moment?

For example, if you load the ACPI power meter driver before you've
installed the ACPI IPMI driver you'll typically get failures (most
vendors implement it via IPMI).

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
