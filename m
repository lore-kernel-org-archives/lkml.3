Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934512Ab3BSTFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:05:46 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:49349 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934255Ab3BSTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:05:43 -0500
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
Thread-Index: AQHOC6xQKsSDc1Q1WkuxN29CXfjd55iB8XAA//+EDqCAAJpbgP//f3Dg
Date: Tue, 19 Feb 2013 19:04:48 +0000
Message-ID: <7267f77544c24531b8fcccc2192b9f48@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
 <20130219165118.GA17715@aepfle.de>
 <1ca36b5d55c64ac6b8854c4f216ef8e5@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
 <20130219184009.GA21783@aepfle.de>
In-Reply-To: <20130219184009.GA21783@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(51704002)(24454001)(189002)(13464002)(164054002)(377454001)(74662001)(50466001)(23676001)(44976002)(47976001)(66066001)(16406001)(31966008)(33646001)(47776003)(63696002)(20776003)(77982001)(54316002)(76482001)(79102001)(59766001)(5343655001)(54356001)(49866001)(876001)(4396001)(56776001)(47736001)(51856001)(53806001)(50986001)(56816002)(65816001)(46102001)(80022001)(47446002)(74502001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:CH1SR01MB611;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0762FFD075
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1JJ5lu9031923

> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Olaf Hering
> Sent: Tuesday, February 19, 2013 1:40 PM
> To: Haiyang Zhang
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org; KY Srinivasan;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
> Driver
> 
> On Tue, Feb 19, Haiyang Zhang wrote:
> 
> > The emulated video device is a separate device from the synthetic
> video.
> > The synthetic driver can only take control of the synthetic video, but
> not
> > the emulated video.
> 
> Please add this to the comment above.

Will do.

> > Actually, we already have a similar mechanism in ata/ata_piix.c to
> disable
> > emulated IDE drive on Hyper-V, so it won't conflict with the synthetic
> drive.
> 
> I havent read the vesafb code, but I think it can kind of give up the
> hardware, something ata_piix can not do.

In my test, the vesafb doesn't automatically give up the emulated video device,
unless I add the DMI based mechanism to let it exit on Hyper-V.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
