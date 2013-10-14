Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3JNPse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:48:34 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:25299
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750814Ab3JNPsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:48:33 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "mzxreary@0pointer.de" <mzxreary@0pointer.de>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aaron.lu@intel.com" <aaron.lu@intel.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video
 detect blacklist
Thread-Topic: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video
 detect blacklist
Thread-Index: AQHOyPTTwoZocAQWI0+DUE6MP47EFw==
Date: Mon, 14 Oct 2013 15:48:28 +0000
Message-ID: <1381765708.24317.1.camel@x230.lan>
References: <20131014005505.GA30503@tango.0pointer.de>
	 <525B44C0.3010204@intel.com> <20131014022325.GA2248@tango.0pointer.de>
	 <525B58BE.5050009@intel.com> <20131014034927.GA3638@tango.0pointer.de>
	 <525B703E.7080102@intel.com> <20131014153621.GA7758@tango.0pointer.de>
In-Reply-To: <20131014153621.GA7758@tango.0pointer.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 0999136621
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(199002)(189002)(19580405001)(19580395003)(83072001)(83322001)(80976001)(36756003)(74502001)(47446002)(31966008)(74876001)(74662001)(66066001)(74366001)(80022001)(49866001)(79102001)(46102001)(51856001)(56816003)(63696002)(77096001)(47976001)(50986001)(81816001)(65816001)(47736001)(85306002)(54356001)(74706001)(4396001)(54316002)(81342001)(56776001)(69226001)(81686001)(53806001)(76796001)(76786001)(33646001)(81542001)(76482001)(59766001)(77982001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <482529D0A601B84388C191DD4F19FDEE@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9EFmeXI016328

On Mon, 2013-10-14 at 17:36 +0200, Lennart Poettering wrote:

> Sorry, still not getting this. How should this ever work if the intel
> video driver is compiled as kmod? That means that it isn't clear at all
> when the kmod is going to be loaded or if it is loaded at all, you
> cannot delay the registration of the acpi backlight that long, since the
> time you'd have to wait is basically unbounded...

See the intel_opregion_present() code in drivers/acpi/video.c. The ACPI
driver won't bind to Intel hardware until i915 indicates that it should
do so.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
