Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaCMVbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:31:07 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:42613
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752135AbaCMVbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:31:05 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Thread-Topic: Trusted kernel patchset for Secure Boot lockdown
Thread-Index: AQHPPwKqgdFEpLbAD0ahQ2OJgthmsZrfiPoA
Date: Thu, 13 Mar 2014 21:30:48 +0000
Message-ID: <1394746248.27846.3.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	 <1394726363.25122.16.camel@x230>
	 <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
In-Reply-To: <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(24454002)(189002)(199002)(54356001)(85306002)(53806001)(92566001)(56776001)(76482001)(92726001)(46102001)(87936001)(4396001)(51856001)(87266001)(33716001)(33646001)(69226001)(2656002)(83072002)(85852003)(81342001)(81542001)(56816005)(74366001)(90146001)(47736001)(49866001)(47976001)(93136001)(93516002)(76786001)(81816001)(76796001)(77096001)(74876001)(65816001)(86362001)(19580395003)(80022001)(83322001)(19580405001)(20776003)(47446002)(79102001)(80976001)(81686001)(74706001)(50986001)(31966008)(74502001)(74662001)(97186001)(59766001)(97336001)(77982001)(94946001)(94316002)(95416001)(95666003)(63696002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB121;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:B8F9F2F7.B6106D29.63C29FBC.10CA7A70.2012D;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <40664201D1F7F64294252B11AC6E1473@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2DLVEOD012379

On Thu, 2014-03-13 at 21:24 +0000, One Thousand Gnomes wrote:

> If I have CAP_SYS_RAWIO I can make arbitary ring 0 calls from userspace,
> trivially and in a fashion well known and documented.

How?

> You've missed a few others too - mem= (especially with exactmap) for
> example.

/dev/mem access is restricted, so what would this buy you? The potential
to have the kernel hand over a region belonging to hardware in response
to a userspace allocation?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
