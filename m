Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3LGBQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:16:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:25844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab3LGBQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:16:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,843,1378882800"; 
   d="scan'208";a="448269385"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Liu, Jinsong" <jinsong.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Xudong Hao <xudong.hao@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: RE: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
Thread-Topic: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
Thread-Index: AQHO8r59I/URrjaMpE23f485Fe4/QppHKhsAgAAKzQCAAKpGYP//hooAgACIpVA=
Date: Sat, 7 Dec 2013 01:16:33 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014A61BE@SHSMSX102.ccr.corp.intel.com>
References: <1386375658-2191-1-git-send-email-qiaowei.ren@intel.com>
	<1386375658-2191-3-git-send-email-qiaowei.ren@intel.com>
 <52A20AD6.8080706@redhat.com>
 <DE8DF0795D48FD4CA783C40EC82923350140B3B6@SHSMSX101.ccr.corp.intel.com>
 <52A242BE.3010701@zytor.com>
 <DE8DF0795D48FD4CA783C40EC82923350140BB62@SHSMSX101.ccr.corp.intel.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE014A6115@SHSMSX102.ccr.corp.intel.com>
 <52A274C0.4010509@zytor.com>
In-Reply-To: <52A274C0.4010509@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB71GiFK026178



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Saturday, December 07, 2013 9:07 AM
> To: Ren, Qiaowei; Liu, Jinsong; Paolo Bonzini
> Cc: kvm@vger.kernel.org; x86@kernel.org; Xudong Hao;
> qemu-devel@nongnu.org; linux-kernel@vger.kernel.org; Ingo Molnar; Thomas
> Gleixner
> Subject: Re: [Qemu-devel] [PATCH v2 3/3] X86, mpx: Intel MPX xstate feature
> definition
> 
> On 12/06/2013 04:23 PM, Ren, Qiaowei wrote:
> >>>
> >>> We need to either disable these features in lazy mode, or we need to
> >>> force eager mode if these features are to be supported.  The problem
> >>> with the latter is that it means forcing eager mode regardless of if
> >>> anything actually *uses* these features.
> >>>
> >>> A third option would be to require applications to use a prctl() or
> >>> similar to enable eager-save features.
> >>>
> >>
> >> The third option seems better -- how does native mpx patches work,
> >> force eager?
> >>
> > It should be the second option, as you can see xsave.c which we remove
> > from this patch. :)
> >
> 
> Ah yes... I missed the fact that that chunk had been dropped from this patch.
> It really shouldn't be.
> 
> I'll substitute the previous version of the patch.
> 
Jinsong think that both kvm and host depend on these feature definition header file, so we firstly submit these files depended on.

Thanks,
Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
