Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaATWXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:23:38 -0500
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:25945
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750942AbaATWXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:23:36 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPEVjnKHWBxAK/ME2641uqAhZ1vZqHLleAgAcH9OCAAAGDAIAAAeYQ
Date: Mon, 20 Jan 2014 22:23:20 +0000
Message-ID: <4c24066612cc4b5bac8efe9d075d421f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
 <20140116104841.GA21768@aepfle.de>
 <b29b3b91ff654abab607fe7b689bbfeb@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140120221622.GA25947@aepfle.de>
In-Reply-To: <20140120221622.GA25947@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.159.229]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(24454002)(189002)(199002)(377454003)(13464003)(86362001)(56776001)(76796001)(85306002)(59766001)(77982001)(76786001)(33646001)(76576001)(83322001)(81342001)(19580405001)(19580395003)(49866001)(93516002)(47736001)(80976001)(4396001)(92566001)(69226001)(50986001)(74662001)(93136001)(74316001)(31966008)(80022001)(81542001)(74502001)(47976001)(54316002)(90146001)(81816001)(87266001)(83072002)(76482001)(74706001)(47446002)(2656002)(87936001)(65816001)(53806001)(56816005)(63696002)(85852003)(66066001)(46102001)(74366001)(79102001)(51856001)(81686001)(74876001)(54356001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.159.229;FPR:;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0KMNkUr006556



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Monday, January 20, 2014 2:16 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
> 
> On Mon, Jan 20, KY Srinivasan wrote:
> 
> > I am cleaning up the code based on your feedback. By the time I am
> > done with my cleanup, I doubt if this patch would apply. Do you mind
> > if I were to include your changes here as part of my cleanup?
> 
> Yes, thats fine.

Thanks Olaf.

K. Y
> 
> 
> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
