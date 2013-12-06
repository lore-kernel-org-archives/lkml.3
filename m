Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3LFQMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:12:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:11674 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab3LFQML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:12:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,841,1378882800"; 
   d="scan'208";a="420522744"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Xudong Hao <xudong.hao@intel.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>
Subject: RE: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
Thread-Topic: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
Thread-Index: AQHO8neZfx07qtPJJki+2rKfZdg4T5pGopUAgACswDD//3/FAIAAhv6w
Date: Fri, 6 Dec 2013 16:11:49 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014A43A6@SHSMSX102.ccr.corp.intel.com>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
 <20131206132648.GB6694@pd.tnic>
 <9E0BE1322F2F2246BD820DA9FC397ADE014A4322@SHSMSX102.ccr.corp.intel.com>
 <20131206160607.GE6694@pd.tnic>
In-Reply-To: <20131206160607.GE6694@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB6GCHSP020279


> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Saturday, December 07, 2013 12:06 AM
> To: Ren, Qiaowei
> Cc: Paolo Bonzini; H. Peter Anvin; Ingo Molnar; Thomas Gleixner;
> x86@kernel.org; linux-kernel@vger.kernel.org; qemu-devel@nongnu.org;
> kvm@vger.kernel.org; Xudong Hao; Liu, Jinsong
> Subject: Re: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
> 
> On Fri, Dec 06, 2013 at 03:55:10PM +0000, Ren, Qiaowei wrote:
> > It is from public introduction and specification, you can refer to
> http://software.intel.com/en-us/articles/introduction-to-intel-memory-protecti
> on-extensions
> 
> Yep, saw it there too. Which doesn't make it any less strange :)
> 
> Btw, if you're going to quote the public documentation, why even add the text
> file here? You can simply add the link above as a comment to the code or as a
> oneliner somewhere in Documentation/x86/.
> 
It is just partly from that link, I will modify it to be any less strange. :)

Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
