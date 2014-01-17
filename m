Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaAQOzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:55:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:13719 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAQOzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:55:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,674,1384329600"; 
   d="scan'208";a="460527899"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] x86, mpx: extend siginfo structure to include bound
 violation information
Thread-Topic: [PATCH 5/5] x86, mpx: extend siginfo structure to include
 bound violation information
Thread-Index: AQHPDzsIbbb3PAExHU2qgziX/5uneJqATTeAgAB6sYCAAAQRAIABL1AAgABXcID//6EwAIAHE7aA
Date: Fri, 17 Jan 2014 14:55:09 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014E5798@SHSMSX102.ccr.corp.intel.com>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-5-git-send-email-qiaowei.ren@intel.com>
 <20140112093013.GB3664@pd.tnic> <52D2C791.2030802@zytor.com>
 <20140112170354.GC3655@pd.tnic> <52D358EA.8090800@intel.com>
 <52D3A243.5060409@intel.com> <20140113104306.GD5388@pd.tnic>
In-Reply-To: <20140113104306.GD5388@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HEtRkU025253

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Monday, January 13, 2014 6:43 PM
> To: Ren, Qiaowei
> Cc: H. Peter Anvin; Thomas Gleixner; Ingo Molnar; x86@kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 5/5] x86, mpx: extend siginfo structure to include bound
> violation information
> 
> On Mon, Jan 13, 2014 at 04:22:27PM +0800, Ren Qiaowei wrote:
> > >I tried to use generic structure and macro, but many members of
> > >generic struct insn are not used for MPX,
> 
> I think that's ok - there are a lot of examples in the kernel where only a subset
> of the struct members are used by a particular functionality.
> 
> > Because only struct insn_field and several macros may be replaced with
> > generic version, I guess it maybe be confused easily to include
> > generic insn header. What do you think about it?
> 
> Yes, I think the idea is to use and, if needed, extend the generic functionality
> instead of growing our own here and there for obvious benefits.
> 
Yes, I once tried to use and extend the generic functionality to implement the decoding, but I noticed it didn't work out well for this specific MPX case. Anyway, I will try to use generic version more.

Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
