Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaCLXyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:54:23 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:10299
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751191AbaCLXyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:54:20 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "pavel@ucw.cz" <pavel@ucw.cz>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq7qAMAgCKMFiSAAAZPAA==
Date: Wed, 12 Mar 2014 23:22:49 +0000
Message-ID: <1394666568.25122.1.camel@x230>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <1511662.Ly2fOjCGKz@vostro.rjw.lan> <1392765307.3488.1.camel@x230.lan>
	 <20140312230007.GA1817@amd.pavel.ucw.cz>
In-Reply-To: <20140312230007.GA1817@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(199002)(377424004)(51704005)(81342001)(85852003)(95416001)(83322001)(69226001)(93136001)(77096001)(76786001)(56776001)(80976001)(76796001)(33716001)(33646001)(19580405001)(19580395003)(85306002)(59766001)(83072002)(77982001)(81542001)(54316002)(90146001)(92566001)(94946001)(81686001)(81816001)(92726001)(4396001)(56816005)(93516002)(74662001)(94316002)(65816001)(31966008)(79102001)(47976001)(87936001)(97186001)(50986001)(95666003)(51856001)(2656002)(46102001)(20776003)(63696002)(54356001)(87266001)(53806001)(74366001)(47736001)(76482001)(47446002)(74502001)(80022001)(97336001)(74706001)(86362001)(49866001)(74876001)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB122;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:D0EAD2EB.2BA704E9.CDD71C8D.40E092B1.20109;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <38AEFFA628B0AC40BD4EA7B9EC5D7C5F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2CNsWVS005522

On Thu, 2014-03-13 at 00:00 +0100, Pavel Machek wrote:
> On Tue 2014-02-18 23:15:08, Matthew Garrett wrote:
> > For example, if you load the ACPI power meter driver before you've
> > installed the ACPI IPMI driver you'll typically get failures (most
> > vendors implement it via IPMI).
> 
> Would the right solution be to implement dependency between power
> meter and IMPI?

No. The power meter driver knows nothing about IPMI. It makes no IPMI
calls. There's no requirement that a vendor implement it via IPMI.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
