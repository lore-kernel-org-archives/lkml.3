Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaCNWxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:53:14 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:8541
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753732AbaCNWxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:53:12 -0400
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
Thread-Index: AQHPP9UxgdFEpLbAD0ahQ2OJgthmsZrhMJwA
Date: Fri, 14 Mar 2014 22:52:56 +0000
Message-ID: <1394837576.1286.27.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	 <1394726363.25122.16.camel@x230>
	 <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	 <1394746248.27846.3.camel@x230>
	 <20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	 <1394762250.6416.24.camel@x230.lan>
	 <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	 <1394801518.6416.38.camel@x230.lan>
	 <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	 <1394820664.26846.18.camel@x230.mview.int.nebula.com>
	 <20140314214806.54a3d031@alan.etchedpixels.co.uk>
	 <1394834193.1286.11.camel@x230>
	 <20140314220840.29a12171@alan.etchedpixels.co.uk>
	 <1394835345.1286.22.camel@x230>
	 <20140314223150.0b49723e@alan.etchedpixels.co.uk>
In-Reply-To: <20140314223150.0b49723e@alan.etchedpixels.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(199002)(51704005)(377424004)(33716001)(97186001)(47446002)(74662001)(63696002)(59766001)(92726001)(33646001)(79102001)(74366001)(20776003)(74502001)(95666003)(94316002)(80022001)(81542001)(81342001)(92566001)(31966008)(85306002)(69226001)(85852003)(83072002)(95416001)(90146001)(56816005)(94946001)(74876001)(74706001)(76796001)(81816001)(83322001)(19580405001)(49866001)(54316002)(50986001)(65816001)(19580395003)(77096001)(46102001)(53806001)(54356001)(76482001)(86362001)(56776001)(93516002)(87936001)(80976001)(76786001)(51856001)(47736001)(81686001)(47976001)(87266001)(2656002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB123;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:FC84F0E6.AD964421.A1F495A8.84E4F165.20234;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DF9F6D16805D64C93E6BA337D63745B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EMrK6T020122

On Fri, 2014-03-14 at 22:31 +0000, One Thousand Gnomes wrote:
> On Fri, 14 Mar 2014 22:15:45 +0000
> Matthew Garrett <matthew.garrett@nebula.com> wrote:
> > The general problem includes having to support this even without an
> > selinux policy.
> 
> Yes. No dispute about that. But equally the general solution should allow
> for it.

Well, sure. The current implementation doesn't conflict with selinux in
any way.

> > some other way. ChromeOS will load unmeasured kernel modules provided it
> > can attest to the trustworthyness of the filesystem containing them.
> 
> See "How to Bypass Verified Boot Security in Chromium OS" 8)
> 
> And it attests the trustworthiness of the filesystem by measuring it. If
> you have a measurement of object X that states it is unchanged then you
> have a valid measurement of any subset of object X for which the same
> assertion is proven. In this case since you know all the bits in the root
> fs are as before, so you know all the bits in the module are as before

You may attest to the trustworthiness of a filesystem by measuring it,
but you may also attest to it via some other means - for instance, it's
read-only and stored on media that requires physical presence to
modify. 

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
