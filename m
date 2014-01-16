Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaAPPwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:52:31 -0500
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:52449
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbaAPPw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:52:29 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPEVjnKHWBxAK/ME2641uqAhZ1vZqHG7eAgABnN8A=
Date: Thu, 16 Jan 2014 15:52:25 +0000
Message-ID: <2e6db4b0ae7c42e5afc4b3b1aa5f2c7e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
 <20140116094200.GA16328@aepfle.de>
In-Reply-To: <20140116094200.GA16328@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:1cb1:47cd:959b:a3a6]
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(689001)(679001)(779001)(199002)(189002)(377454003)(51704005)(13464003)(24454002)(47446002)(74502001)(90146001)(19580395003)(19580405001)(83322001)(50986001)(93516002)(31966008)(33646001)(47976001)(56816005)(47736001)(49866001)(81542001)(74662001)(4396001)(93136001)(92566001)(85852003)(83072002)(56776001)(69226001)(51856001)(79102001)(46102001)(81816001)(54356001)(81686001)(53806001)(59766001)(76482001)(77982001)(74366001)(87266001)(76786001)(2656002)(76576001)(85306002)(81342001)(74706001)(80976001)(63696002)(54316002)(74316001)(76796001)(74876001)(65816001)(87936001)(80022001)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:2601:8:9b00:402:1cb1:47cd:959b:a3a6;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0GFqb2b018761



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, January 16, 2014 1:42 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
> 
> On Tue, Jan 14, K. Y. Srinivasan wrote:
> 
> > +enum hv_fcopy_op {
> > +	START_FILE_COPY = 0,
> > +	WRITE_TO_FILE,
> > +	COMPLETE_FCOPY,
> > +	CANCEL_FCOPY,
> > +};
> > +
> > +struct hv_fcopy_hdr {
> > +	enum hv_fcopy_op operation;
> > +	uuid_le service_id0; /* currently unused */
> > +	uuid_le service_id1; /* currently unused */
> > +} __attribute__((packed));
> 
> Is enum a fixed size? This struct is used in other structs, so I wonder
> what will happen to the kernel/user protocol if any of that changes. Or
> with a 64bit kernel and 32bit daemon. Maybe operation should be __u32?

I will check and make the necessary changes.

Thank you,

K. Y
> 
> 
> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
