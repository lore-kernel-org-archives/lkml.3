Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab3IHR1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:27:39 -0400
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:58053
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564Ab3IHR1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:27:37 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Topic: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Index: AQHOqQBlTgRtcELUZ0K5HxHj5bQ8FZm7apqAgACzh7qAAAFEAA==
Date: Sun, 8 Sep 2013 17:27:32 +0000
Message-ID: <1378661252.2300.26.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
	 <1378660541.2300.19.camel@x230>
	 <1378660975.2429.14.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1378660975.2429.14.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:740c:5537:5f2f:efde]
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(50986001)(81686001)(4396001)(49866001)(47976001)(47736001)(74366001)(81342001)(76796001)(79102001)(81542001)(76786001)(59766001)(83072001)(77982001)(51856001)(19580395003)(33646001)(65816001)(33716001)(80976001)(83322001)(19580405001)(74502001)(47446002)(80022001)(56816003)(77096001)(31966008)(74662001)(74876001)(76482001)(63696002)(69226001)(54356001)(56776001)(46102001)(54316002)(74706001)(81816001)(53806001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:740c:5537:5f2f:efde;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2085C08576D76846B95261618AF3E0BC@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r88HRiv3015649


> It's an argument that CAP_SYS_BOOT is too powerful yes, but if you
> recall, I said I keep that one.  In the rather lame analogy, what I do
> by giving away CAP_SYS_MODULE and enforcing module signing while keeping
> CAP_SYS_BOOT is allow people into my conservatory to play with the
> plants but not into my house to steal the silver ... saying CAP_SYS_BOOT
> is too powerful doesn't affect that use case because I haven't given
> away CAP_SYS_BOOT.

Ok, sorry, I had your meaning inverted. Yes, permitting the loading of
signed modules while preventing the use of kexec is a completely
reasonable configuration - so reasonable that it's what this patch
causes the kernel to do automatically. 

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
