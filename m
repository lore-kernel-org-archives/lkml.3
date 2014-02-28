Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaB1ExI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:53:08 -0500
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:51502
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751100AbaB1ExG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:53:06 -0500
X-Greylist: delayed 108252 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 23:53:05 EST
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "jmorris@namei.org" <jmorris@namei.org>
CC: "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Thread-Topic: Trusted kernel patchset for Secure Boot lockdown
Thread-Index: AQHPM+Zewn81VXyVQUqKeXDjEOJQ8JrJ+2UAgAAeoIA=
Date: Fri, 28 Feb 2014 04:52:42 +0000
Message-ID: <1393563161.5607.0.camel@x230.lan>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(189002)(199002)(24454002)(81542001)(81342001)(33646001)(74366001)(74876001)(79102001)(74706001)(69226001)(76796001)(95666003)(65816001)(77982001)(76786001)(93516002)(95416001)(76482001)(93136001)(94946001)(47976001)(92566001)(92726001)(87936001)(90146001)(56816005)(80976001)(83072002)(85852003)(19580405001)(19580395003)(83322001)(49866001)(47736001)(50986001)(85306002)(77096001)(47446002)(56776001)(31966008)(81686001)(4396001)(51856001)(80022001)(63696002)(36756003)(94316002)(59766001)(81816001)(74662001)(54316002)(87266001)(74502001)(2656002)(53806001)(54356001)(86362001)(46102001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB766;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:BD8AC51E.12F2A52D.A0F7C5FA.54D8AEB3.200DD;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8706313ECD16CB4DAF429CAEBE77DD10@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1S4rKGY012679

On Fri, 2014-02-28 at 14:03 +1100, James Morris wrote:

> Ok, which tree should take this?  I'm happy to, although most of it is 
> outside security/ .

Security might make the most sense - I don't think any of the additional
restrictions (beyond kexec, and I think we've hashed that argument out
now) are terribly controversial.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
