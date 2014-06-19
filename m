Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbaFSBNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:13:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:11790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604AbaFSBNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:13:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,503,1400050800"; 
   d="scan'208";a="530732250"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Topic: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Index: AQHPitp5+re2FjJ0DkeRHdzRM5ptp5t2HnuAgAGAu2A=
Date: Thu, 19 Jun 2014 01:13:48 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE016A3BAA@shsmsx102.ccr.corp.intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-8-git-send-email-qiaowei.ren@intel.com>
 <20140618100745.GB24419@pd.tnic>
In-Reply-To: <20140618100745.GB24419@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5J1E1DB022732

On 2014-06-18, Borislav Petkov wrote:
> On Wed, Jun 18, 2014 at 05:44:13PM +0800, Qiaowei Ren wrote:
> 
> This whole insn decoding machinery above looks like adapted from
> arch/x86/lib/insn.c. You should merge it with the generic code in
> insn.c instead of homegrowing it here only for the purposes of MPX.
> And if it doesn't work for your needs, you should should extend the
> generic code to do so. I think we even talked about this last time.
> 
> Also, make sure you run all your patches through checkpatch.pl before
> submitting.
>
Petkov, as we discussed on initial version of this patchset, general insn framework didn't work out well and I have tried to use generic struct insn, insn_field, etc. for obvious benefits.

Thanks,
Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
