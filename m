Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3LTPLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:11:51 -0500
Received: from mail-bn1lp0156.outbound.protection.outlook.com ([207.46.163.156]:45527
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab3LTPLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:11:49 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>
CC: "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlee@suse.com" <jlee@suse.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "trenn@suse.de" <trenn@suse.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "matt@console-pimps.org" <matt@console-pimps.org>
Subject: Re: [RFC PATCH 07/14] rtc-efi: add GMTOFF support to rtc_efi
Thread-Topic: [RFC PATCH 07/14] rtc-efi: add GMTOFF support to rtc_efi
Thread-Index: AQHO/I+I6Xu+pUQVakCBIBYtZZRdZ5pdMncA
Date: Fri, 20 Dec 2013 15:11:45 +0000
Message-ID: <1387552304.17961.0.camel@x230>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-8-git-send-email-jlee@suse.com>
In-Reply-To: <1387439515-8926-8-git-send-email-jlee@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [176.35.175.187]
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377424004)(189002)(199002)(24454002)(56776001)(87266001)(87936001)(31966008)(77982001)(33716001)(54316002)(80976001)(47446002)(74502001)(33646001)(81686001)(59766001)(47736001)(47976001)(49866001)(4396001)(50986001)(69226001)(81816001)(79102001)(74706001)(81342001)(81542001)(2656002)(74662001)(74876001)(63696002)(65816001)(85306002)(77096001)(83322001)(76796001)(19580405001)(19580395003)(76786001)(53806001)(80022001)(66066001)(51856001)(90146001)(76482001)(54356001)(46102001)(74366001)(85852003)(56816005)(83072002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:176.35.175.187;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B08EDECAD988A4C894B0F7DEF3D9B82@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBKFBuS0013890

On Thu, 2013-12-19 at 15:51 +0800, Lee, Chun-Yi wrote:
> This patch adds 2 new iotrl: RTC_RD_GMTOFF and RTC_SET_GMTOFF to
> rtc_efi support get/set gmt offset that mapping to the GUN's tm_gmtoff
> extension (Seconds east of UTC).

Shouldn't this information also be exported via the rtc-sysfs interface?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
