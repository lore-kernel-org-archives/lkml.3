Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3LTPQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:16:09 -0500
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:1141
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753087Ab3LTPQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:16:07 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "hpa@zytor.com" <hpa@zytor.com>
CC: "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHO/I5MSilHVEmHZUOprFBMNOe5KppbnNeAgADbnoCAAASFAIAAtraA
Date: Fri, 20 Dec 2013 15:16:05 +0000
Message-ID: <1387552565.17961.3.camel@x230>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>
	 <52B3C5F0.1060303@zytor.com>
In-Reply-To: <52B3C5F0.1060303@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [176.35.175.187]
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377454003)(51704005)(377424004)(479174003)(189002)(199002)(24454002)(56776001)(87266001)(87936001)(31966008)(77982001)(33716001)(54316002)(80976001)(47446002)(74502001)(33646001)(81686001)(59766001)(47736001)(47976001)(49866001)(4396001)(50986001)(69226001)(81816001)(79102001)(74706001)(81342001)(81542001)(2656002)(74662001)(74876001)(63696002)(65816001)(85306002)(77096001)(83322001)(76796001)(19580405001)(19580395003)(76786001)(53806001)(80022001)(66066001)(51856001)(90146001)(76482001)(54356001)(46102001)(74366001)(85852003)(56816005)(83072002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:176.35.175.187;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <ADD3457D3BECB8438116E392D1A7B5BD@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBKFGGh6013912

On Thu, 2013-12-19 at 20:22 -0800, H. Peter Anvin wrote:
> On 12/19/2013 08:05 PM, joeyli wrote:
> > Can we use EFI time services on x86_64 after Borislav's patches accepted
> > to mainline?
> > 
> 
> No.

We will want to use them to (at minimum) obtain the clock timezone.
Using them for general RTC access is less attractive.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
