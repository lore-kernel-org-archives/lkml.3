Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaCNTZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:25:03 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:56833
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754486AbaCNTY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:24:59 -0400
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
Thread-Index: AQHPP7sUgdFEpLbAD0ahQ2OJgthmsQ==
Date: Fri, 14 Mar 2014 19:24:55 +0000
Message-ID: <1394825094.1286.1.camel@x230>
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
In-Reply-To: <1394820664.26846.18.camel@x230.mview.int.nebula.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(377424004)(189002)(199002)(59766001)(83072002)(93136001)(19580395003)(19580405001)(83322001)(33716001)(85852003)(77982001)(46102001)(92566001)(81342001)(80022001)(92726001)(65816001)(51856001)(33646001)(81542001)(94946001)(87936001)(95666003)(94316002)(79102001)(2656002)(87266001)(20776003)(95416001)(74366001)(93516002)(49866001)(63696002)(90146001)(47976001)(50986001)(56816005)(47736001)(74876001)(4396001)(74706001)(86362001)(97336001)(97186001)(69226001)(77096001)(74662001)(80976001)(31966008)(47446002)(81686001)(74502001)(53806001)(76482001)(56776001)(76796001)(76786001)(81816001)(54356001)(54316002)(85306002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB453;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:BC32C22B.8D255E01.FA609408.44E279A1.20125;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2290C0ED0C7929498E01598672FDE139@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EJPCaQ018982

On Fri, 2014-03-14 at 14:11 -0400, Matthew Garrett wrote:

> The fact that you keep saying measured really does make me suspect that
> you misunderstand the problem. There's no measurement involved, there's
> simply an assertion that the firmware (which you're forced to trust)
> chose, via some policy you may be unaware of, to trust the booted
> kernel.

As an example, imagine a platform with the bootloader and kernel on
read-only media. The platform can assert that the kernel is trusted even
if there's no measurement of the kernel.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
