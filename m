Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab3B1R4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 12:56:55 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.88]:23984 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331Ab3B1R4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 12:56:53 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Topic: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Index: AQHOC6xQKsSDc1Q1WkuxN29CXfjd55iP+/yA//+mG/A=
Date: Thu, 28 Feb 2013 17:56:21 +0000
Message-ID: <d7b9ef10e04c4fe3893d5cdcf2f23703@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
 <20130228151641.GA13552@aepfle.de>
In-Reply-To: <20130228151641.GA13552@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(31966008)(80022001)(59766001)(50986001)(66066001)(73894001)(79102001)(46102001)(49866001)(63696002)(56816002)(23676001)(876001)(51856001)(53806001)(54356001)(44976002)(33646001)(54316002)(77982001)(16406001)(50466001)(76482001)(65816001)(74662001)(4396001)(74502001)(621065001)(47736001)(56776001)(20776003)(47776003)(47446002)(47976001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2SR01MB607;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0771670921
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1SHvA70016137

> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, February 28, 2013 10:17 AM
> To: Haiyang Zhang
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org; KY Srinivasan;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
> Driver
> 
> On Fri, Feb 15, Haiyang Zhang wrote:
> 
> > +	if (fb_get_options("hyperv_fb", &opt) || !opt || !*opt)
> 
> > +	strcpy(info->fix.id, "hyperv");
> 
> 
> Here is a mismatch between video=<optname> and /proc/fb output.
> Both should have the same string IMO.

I will make both of them to be KBUILD_MODNAME.

Thanks,
- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
