Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaCMVcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:32:00 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:59292
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753093AbaCMVb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:31:58 -0400
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
Thread-Index: AQHPPwLwgdFEpLbAD0ahQ2OJgthmsZrfiUgA
Date: Thu, 13 Mar 2014 21:31:55 +0000
Message-ID: <1394746314.27846.4.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	 <1394726363.25122.16.camel@x230>
	 <20140313212647.7412aadf@alan.etchedpixels.co.uk>
In-Reply-To: <20140313212647.7412aadf@alan.etchedpixels.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(24454002)(377424004)(74366001)(56816005)(85852003)(90146001)(20776003)(83072002)(87936001)(79102001)(95416001)(63696002)(59766001)(92566001)(92726001)(94946001)(74502001)(93136001)(47446002)(46102001)(85306002)(83322001)(74662001)(81342001)(87266001)(69226001)(51856001)(49866001)(93516002)(31966008)(47736001)(50986001)(94316002)(86362001)(81816001)(76482001)(81686001)(76786001)(53806001)(33716001)(74706001)(74876001)(76796001)(77982001)(81542001)(2656002)(33646001)(97336001)(80976001)(19580405001)(4396001)(56776001)(97186001)(47976001)(19580395003)(95666003)(77096001)(65816001)(80022001)(54356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB123;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:C151FD86.FE2CF91.F16DA97E.58D5F075.20175;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A008819D12EFFC40A5D6F44E7611F4DD@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2DLW7U8012386

On Thu, 2014-03-13 at 21:26 +0000, One Thousand Gnomes wrote:
> > On the other hand, disabling CAP_SYS_RAWIO *definitely* breaks expected
> > functionality - firmware loading and the fibmap ioctl are probably the
> > most obvious. And changing the use of CAP_SYS_RAWIO potentially breaks
> > userspace expectations, so we're kind of stuck there.
> 
> Actually I know how to describe the problem better.
> 
> Whitelist v Blacklist.
> 
> Going around adding extra cases for CAP_SYS_RAWIO is a fails insecure
> model. Going around adding CAP_SYS_RAWIO || CAP_SYS_RAWIO_SEC is a 'fails
> secure' case.

We've already been through this. We can't add new capabilities. It
breaks existing userspace.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
