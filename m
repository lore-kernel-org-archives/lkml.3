Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3BRQKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:10:14 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.87]:3355 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366Ab3BRQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:10:11 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Topic: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Index: AQHOC6xQKsSDc1Q1WkuxN29CXfjd55h/9GAA///YYWA=
Date: Mon, 18 Feb 2013 16:09:10 +0000
Message-ID: <bd3dbe05baa54c81a5a84eff257b0cb7@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
 <CAMuHMdXJ+waZJ95bRLPYYsneXf98c=9d9n1jdkWMKhUpAAB_RA@mail.gmail.com>
In-Reply-To: <CAMuHMdXJ+waZJ95bRLPYYsneXf98c=9d9n1jdkWMKhUpAAB_RA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(24454001)(51704002)(164054002)(13464002)(199002)(189002)(31966008)(23676001)(16406001)(33646001)(74662001)(44976002)(46102001)(47446002)(74502001)(50466001)(50986001)(47736001)(47976001)(51856001)(54356001)(80022001)(66066001)(65816001)(4396001)(49866001)(53806001)(876001)(56816002)(54316002)(79102001)(76482001)(77982001)(56776001)(63696002)(47776003)(5343655001)(59766001)(5343635001)(20776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2SR01MB607;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0761DE1EDD
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1IGAHnE024496

> -----Original Message-----
> From: geert.uytterhoeven@gmail.com
> [mailto:geert.uytterhoeven@gmail.com] On Behalf Of Geert Uytterhoeven
> Sent: Monday, February 18, 2013 5:29 AM
> To: Haiyang Zhang
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org; KY Srinivasan;
> olaf@aepfle.de; jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
> Driver
> 
> On Fri, Feb 15, 2013 at 8:09 PM, Haiyang Zhang <haiyangz@microsoft.com>
> wrote:
> > +/* Allocate framebuffer memory */
>
> Please instead reserve some memory at boot time, or allocate it very early
> (cfr. ps3fb).

I will look into this.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
