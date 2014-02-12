Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaBLUh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:37:59 -0500
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:22915
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753769AbaBLUh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:37:57 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "tiwai@suse.de" <tiwai@suse.de>
CC: "david.henningsson@canonical.com" <david.henningsson@canonical.com>,
        "ibm-acpi-devel@lists.sourceforge.net" 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "ibm-acpi@hmh.eng.br" <ibm-acpi@hmh.eng.br>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thinkpad_acpi: Fix inconsistent mute LED after resume
Thread-Topic: [PATCH] thinkpad_acpi: Fix inconsistent mute LED after resume
Thread-Index: AQHPKAewnSz7adOkQUWPbs0OJZ4eaJqyFHcA
Date: Wed, 12 Feb 2014 20:37:36 +0000
Message-ID: <1392237456.1201.2.camel@x230>
References: <1392219165-20888-1-git-send-email-tiwai@suse.de>
In-Reply-To: <1392219165-20888-1-git-send-email-tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(199002)(189002)(377424004)(24454002)(85306002)(74876001)(19580395003)(19580405001)(83322001)(65816001)(80022001)(81816001)(90146001)(81686001)(53806001)(63696002)(92726001)(56816005)(33716001)(87936001)(85852003)(92566001)(87266001)(83072002)(76482001)(95416001)(33646001)(56776001)(54316002)(2656002)(80976001)(95666001)(79102001)(77982001)(59766001)(74706001)(54356001)(74502001)(51856001)(74662001)(94946001)(74366001)(47736001)(93516002)(93136001)(50986001)(86362001)(94316002)(49866001)(47976001)(31966008)(76796001)(69226001)(46102001)(76786001)(81342001)(77096001)(47446002)(558084003)(81542001)(4396001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB421;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:E73F2C12.2760E709.11EEA198.C0E89AA8.20082;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E93242586BB54428127DA1EE84C01A7@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1CKdEA6022850

On Wed, 2014-02-12 at 16:32 +0100, Takashi Iwai wrote:
> The mute LED states have to be restored after resume.

Oh, never mind, we're not doing this through the LED class, are we?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
