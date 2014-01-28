Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaA1Dq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 22:46:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:24604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaA1Dq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 22:46:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,733,1384329600"; 
   d="scan'208";a="445596692"
Message-ID: <52E726BE.50401@intel.com>
Date: Tue, 28 Jan 2014 11:40:46 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] x86, mpx: add documentation on Intel MPX
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-2-git-send-email-qiaowei.ren@intel.com> <52E6C134.3050608@mit.edu>
In-Reply-To: <52E6C134.3050608@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 04:27 AM, Andy Lutomirski wrote:
> On 01/26/2014 01:08 AM, Qiaowei Ren wrote:
>> +1) Providing handlers for bounds faults (#BR).
>> +
>> +When MPX is enabled, there are 2 new situations that can generate
>> +#BR faults. If a bounds overflow occurs then a #BR is generated.
>> +The fault handler will decode MPX instructions to get violation
>> +address and set this address into extended struct siginfo.
>
> Can you document exactly where the insn address and pointer value end
> up?  (If it's in the (IMO hideous) cr2 field in ucontext, this needs to
> be documented.  If it's somewhere useful in siginfo, that should also be
> documented to save people the time it takes to figure it out.)
>
Ok. I will describe extended siginfo at this documentation.

Thanks,
Qiaowei
