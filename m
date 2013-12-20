Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3LTQ6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:58:46 -0500
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:38308
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753639Ab3LTQ6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:58:44 -0500
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
Thread-Index: AQHO/I5MSilHVEmHZUOprFBMNOe5KppbnNeAgADbnoCAAASFAIAA0yuNgAAALIA=
Date: Fri, 20 Dec 2013 16:58:33 +0000
Message-ID: <1387558713.17961.4.camel@x230>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>
	 <52B3C5F0.1060303@zytor.com> <1387552565.17961.3.camel@x230>
	 <83120989-e634-47c0-9bae-0c7899df64ab@email.android.com>
In-Reply-To: <83120989-e634-47c0-9bae-0c7899df64ab@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [176.35.175.187]
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377424004)(24454002)(199002)(189002)(79102001)(90146001)(47446002)(76786001)(56816005)(81342001)(74502001)(80022001)(33716001)(76796001)(51856001)(63696002)(83072002)(66066001)(74662001)(74706001)(77982001)(81686001)(74876001)(74366001)(81542001)(87266001)(76482001)(31966008)(19580395003)(19580405001)(83322001)(85306002)(33646001)(47976001)(50986001)(49866001)(47736001)(53806001)(4396001)(80976001)(65816001)(56776001)(2656002)(87936001)(54356001)(77096001)(69226001)(54316002)(85852003)(81816001)(46102001)(59766001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:176.35.175.187;FPR:;RD:InfoNoRecords;A:1;MX:3;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <275AD68E36F3BF4B98B6126C092A0EBC@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBKGwqIi014576

On Fri, 2013-12-20 at 08:57 -0800, H. Peter Anvin wrote:
> But we prefer the TAD for that.  The case where the EFI runtime is the only source of that info is problematic as they are known to not work at runtime.  We could collect it at boot and then never change it, although you end up in definitional issues between EFI and the hw RTC.

Most shipping UEFI hardware has no TAD.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
