Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3LGBHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:07:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34765 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3LGBHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:07:48 -0500
Message-ID: <52A274C0.4010509@zytor.com>
Date: Fri, 06 Dec 2013 17:07:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Xudong Hao <xudong.hao@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
References: <1386375658-2191-1-git-send-email-qiaowei.ren@intel.com>	<1386375658-2191-3-git-send-email-qiaowei.ren@intel.com> <52A20AD6.8080706@redhat.com> <DE8DF0795D48FD4CA783C40EC82923350140B3B6@SHSMSX101.ccr.corp.intel.com> <52A242BE.3010701@zytor.com> <DE8DF0795D48FD4CA783C40EC82923350140BB62@SHSMSX101.ccr.corp.intel.com> <9E0BE1322F2F2246BD820DA9FC397ADE014A6115@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE014A6115@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 04:23 PM, Ren, Qiaowei wrote:
>>>
>>> We need to either disable these features in lazy mode, or we need to
>>> force eager mode if these features are to be supported.  The problem
>>> with the latter is that it means forcing eager mode regardless of if
>>> anything actually *uses* these features.
>>>
>>> A third option would be to require applications to use a prctl() or
>>> similar to enable eager-save features.
>>>
>>
>> The third option seems better -- how does native mpx patches work, force
>> eager?
>>
> It should be the second option, as you can see xsave.c which we remove from this patch. :)
> 

Ah yes... I missed the fact that that chunk had been dropped from this
patch.  It really shouldn't be.

I'll substitute the previous version of the patch.

	-hpa

