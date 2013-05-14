Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3ENO4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:56:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:54511 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3ENO4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:56:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="333896509"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH] x86: add a new SMP bring up way for tboot case
Thread-Topic: [PATCH] x86: add a new SMP bring up way for tboot case
Thread-Index: AQHOUKduon4Pn56HmkychJPawPQVZJkEKT0AgACbFFA=
Date: Tue, 14 May 2013 14:56:05 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9AF06B@SHSMSX102.ccr.corp.intel.com>
References: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com>
 <20130514133834.GA28834@pd.tnic>
In-Reply-To: <20130514133834.GA28834@pd.tnic>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4EEuNai008185

On 2013-05-14, Borislav Petkov wrote:
> On Wed, May 15, 2013 at 05:21:25AM +0800, Qiaowei Ren wrote:
> > diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c index
> > f84fe00..0ec1947 100644
> > --- a/arch/x86/kernel/tboot.c
> > +++ b/arch/x86/kernel/tboot.c
> > @@ -101,6 +101,8 @@ void __init tboot_probe(void)
> >  	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
> >  	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
> >  	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
> > +	if (tboot->version >= 6)
> > +		pr_info("flags: 0x%08x\n", tboot->flags);
> 
> This should be pr_debug like the rest, no?

Well. pr_debug is ok.

Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
