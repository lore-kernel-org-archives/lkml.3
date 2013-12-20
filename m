Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3LTUcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 15:32:35 -0500
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:22434
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751838Ab3LTUcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 15:32:33 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "hpa@zytor.com" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "jlee@suse.com" <jlee@suse.com>, "bp@suse.de" <bp@suse.de>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "trenn@suse.de" <trenn@suse.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "matt@console-pimps.org" <matt@console-pimps.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Thread-Topic: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Thread-Index: AQHO/I5MSilHVEmHZUOprFBMNOe5KppbnNeAgADbnoCAAASFAIAA0yuNgAA7W/eAAACCgA==
Date: Fri, 20 Dec 2013 20:32:12 +0000
Message-ID: <1387571531.17961.6.camel@x230>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>
	 <52B3C5F0.1060303@zytor.com> <1387552565.17961.3.camel@x230>
	 <83120989-e634-47c0-9bae-0c7899df64ab@email.android.com>
	 <1387558713.17961.4.camel@x230>
	 <a049daea-a713-4d06-b35f-61f3bec06ba9@email.android.com>
In-Reply-To: <a049daea-a713-4d06-b35f-61f3bec06ba9@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [176.35.175.187]
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(24454002)(377424004)(189002)(199002)(66066001)(51856001)(80022001)(54356001)(46102001)(76482001)(90146001)(77096001)(85306002)(65816001)(53806001)(19580405001)(83322001)(76796001)(19580395003)(76786001)(83072002)(85852003)(74366001)(56816005)(74502001)(33646001)(47446002)(56776001)(87266001)(80976001)(54316002)(31966008)(87936001)(77982001)(33716001)(59766001)(81686001)(2656002)(81542001)(63696002)(74662001)(74876001)(69226001)(79102001)(81816001)(49866001)(47976001)(4396001)(47736001)(50986001)(74706001)(81342001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:176.35.175.187;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5181413D5263A742AE3301DEF7603B38@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBKKWdHS015917

On Fri, 2013-12-20 at 12:29 -0800, H. Peter Anvin wrote:
> Yes, but the TZ isn't all that critical, either.  It certainly doesn't matter at all for a pure Linux system.

No, but it does matter for a great number of deployed Linux systems.
Dealing with the timezone over DST changes has been a perpetual problem,
and if we can make that work then life will be significantly better.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
