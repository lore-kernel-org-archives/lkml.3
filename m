Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaDGPk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:40:57 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:10356
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754142AbaDGPkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:40:53 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
 legacy PIC
Thread-Topic: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
 legacy PIC
Thread-Index: AQHPT5v0hZTrqe/+3EGIeADAdCnXXZsFwH8AgACPmpA=
Date: Mon, 7 Apr 2014 15:40:49 +0000
Message-ID: <a8ff34891ad5483ca21a649478db8d3a@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
 <20140407070612.GA7168@aepfle.de>
In-Reply-To: <20140407070612.GA7168@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.160.40]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0174BD4BDA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(24454002)(51704005)(13464003)(199002)(189002)(99396002)(74366001)(76796001)(19580405001)(81342001)(19580395003)(83322001)(74316001)(97336001)(83072002)(81542001)(74876001)(85852003)(74706001)(76576001)(76786001)(2656002)(59766001)(85306002)(77982001)(79102001)(94316002)(31966008)(74502001)(74662001)(47446002)(4396001)(87266001)(56816005)(86362001)(90146001)(94946001)(46102001)(81816001)(81686001)(47976001)(50986001)(95416001)(69226001)(20776003)(80976001)(33646001)(66066001)(63696002)(98676001)(87936001)(97186001)(95666003)(92566001)(93516002)(93136001)(53806001)(76482001)(47736001)(49866001)(80022001)(54356001)(56776001)(65816001)(54316002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:8CCCF502.1C9F4D12.36F0CB3C.5F61B978.2012C;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s37Ff5k9005039



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Monday, April 7, 2014 12:06 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; apw@canonical.com;
> jasowang@redhat.com; hpa@zytor.com; stable@vger.kernel.org
> Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
> legacy PIC
> 
> On Thu, Apr 03, K. Y. Srinivasan wrote:
> 
> > +		printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
> 
> Maybe this printk can be removed as well, unless its valuable info.

I will take a look at this.

K. Y
> 
> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
