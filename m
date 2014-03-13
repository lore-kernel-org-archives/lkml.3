Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaCMHYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:24:40 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:18865
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751388AbaCMHYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:24:39 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "pavel@ucw.cz" <pavel@ucw.cz>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq7qAMAgCKMFiSAAIw9OoAAAK6A
Date: Thu, 13 Mar 2014 07:24:36 +0000
Message-ID: <1394695475.25122.4.camel@x230>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <1511662.Ly2fOjCGKz@vostro.rjw.lan> <1392765307.3488.1.camel@x230.lan>
	 <20140312230007.GA1817@amd.pavel.ucw.cz> <1394666568.25122.1.camel@x230>
	 <20140313072204.GA7181@amd.pavel.ucw.cz>
In-Reply-To: <20140313072204.GA7181@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(24454002)(199002)(189002)(19580405001)(19580395003)(80976001)(81686001)(81816001)(83322001)(31966008)(90146001)(85852003)(92726001)(92566001)(83072002)(74662001)(56816005)(53806001)(54356001)(77096001)(76796001)(56776001)(54316002)(76482001)(4396001)(46102001)(49866001)(95416001)(93136001)(94316002)(74876001)(69226001)(74366001)(33716001)(74706001)(85306002)(93516002)(86362001)(33646001)(47446002)(74502001)(59766001)(81342001)(80022001)(87266001)(81542001)(87936001)(95666003)(97336001)(47736001)(47976001)(51856001)(50986001)(94946001)(97186001)(79102001)(63696002)(2656002)(65816001)(20776003)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB124;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:A058D130.3985D629.C3D13BC6.E191B0.2012E;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <180642F4A74F50458ABED3351E139E4F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2D7OiDB006989

On Thu, 2014-03-13 at 08:22 +0100, Pavel Machek wrote:
> On Wed 2014-03-12 23:22:49, Matthew Garrett wrote:
> > No. The power meter driver knows nothing about IPMI. It makes no IPMI
> > calls. There's no requirement that a vendor implement it via IPMI.
> 
> Yet you claim that IMPI is needed for that, and that's why you made
> IMPI default.

I claim that the ACPI spec defines the behaviour of IPMI operation
regions, and so we should default IPMI to Y in order to (by default)
implement the ACPI spec.

> So ... do we need dmi-based blacklist?

I don't see why.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
