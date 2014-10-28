Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbaJ1GA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:00:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:62445 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbaJ1GAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:00:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407084852"
Message-ID: <544F303C.10903@intel.com>
Date: Tue, 28 Oct 2014 13:57:16 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH v9 10/12] x86, mpx: add prctl commands PR_MPX_ENABLE_MANAGEMENT,
 PR_MPX_DISABLE_MANAGEMENT
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-11-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.11.1410241436560.5308@nanos> <9E0BE1322F2F2246BD820DA9FC397ADE0180ED65@shsmsx102.ccr.corp.intel.com> <alpine.DEB.2.11.1410272137140.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410272137140.5308@nanos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 04:38 AM, Thomas Gleixner wrote:
> On Mon, 27 Oct 2014, Ren, Qiaowei wrote:
>> On 2014-10-24, Thomas Gleixner wrote:
>>> On Sun, 12 Oct 2014, Qiaowei Ren wrote:
>>>> +int mpx_enable_management(struct task_struct *tsk) {
>>>> +	struct mm_struct *mm = tsk->mm;
>>>> +	void __user *bd_base = MPX_INVALID_BOUNDS_DIR;
>>>
>>> What's the point of initializing bd_base here. I had to look twice to
>>> figure out that it gets overwritten by task_get_bounds_dir()
>>>
>>
>> I just want to put task_get_bounds_dir() outside mm->mmap_sem holding.
>
> What you want is not interesting at all. What's interesting is what
> you do and what you send for review.
>

I see. Thanks.

- Qiaowei
