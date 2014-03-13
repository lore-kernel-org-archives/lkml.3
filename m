Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaCMVcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:32:54 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:6241
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753060AbaCMVcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:32:52 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "hpa@zytor.com" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Thread-Topic: Trusted kernel patchset for Secure Boot lockdown
Thread-Index: AQHPPwKqgdFEpLbAD0ahQ2OJgthmsZrfiDOAgAABTwA=
Date: Thu, 13 Mar 2014 21:32:42 +0000
Message-ID: <1394746362.27846.5.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	 <1394726363.25122.16.camel@x230>
	 <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	 <532222E1.2020405@zytor.com>
In-Reply-To: <532222E1.2020405@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(51704005)(377454003)(479174003)(24454002)(189002)(199002)(47736001)(81816001)(81686001)(83322001)(4396001)(47976001)(19580395003)(49866001)(50986001)(80022001)(80976001)(86362001)(95416001)(74706001)(93516002)(94946001)(94316002)(97186001)(74366001)(81342001)(95666003)(33646001)(69226001)(19580405001)(79102001)(65816001)(87266001)(92726001)(93136001)(92566001)(53806001)(54356001)(74662001)(2656002)(56776001)(74876001)(47446002)(76796001)(76786001)(85852003)(83072002)(56816005)(90146001)(85306002)(63696002)(51856001)(46102001)(33716001)(77096001)(31966008)(59766001)(87936001)(74502001)(97336001)(81542001)(77982001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB454;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:76097075.710CD09.41D21FA8.50D9117C.20124;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <D38BDEC1528D6848B298D54523D79E9A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2DLX4eB012390

On Thu, 2014-03-13 at 14:28 -0700, H. Peter Anvin wrote:
> On 03/13/2014 02:24 PM, One Thousand Gnomes wrote:
> > 
> > If I have CAP_SYS_RAWIO I can make arbitary ring 0 calls from userspace,
> > trivially and in a fashion well known and documented.
> > 
> 
> ... and once we eliminate CAP_SYS_RAWIO a bunch of the patches become
> redundant.

We can only drop CAP_SYS_RAWIO if we change a bunch of the existing
CAP_SYS_RAWIO checks to something else. How do we do that without
breaking existing userspace?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
