Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaB0CFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:05:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:37982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaB0CFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:05:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,551,1389772800"; 
   d="scan'208";a="482578578"
Message-ID: <530E9BC6.5090207@intel.com>
Date: Thu, 27 Feb 2014 09:58:30 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] x86, mpx: add documentation on Intel MPX
References: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com> <1393162071-23995-2-git-send-email-qiaowei.ren@intel.com> <530E5A7D.9060902@intel.com>
In-Reply-To: <530E5A7D.9060902@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 05:19 AM, Dave Hansen wrote:
> On 02/23/2014 05:27 AM, Qiaowei Ren wrote:
>> +The other case that generates a #BR is when a BNDSTX instruction
>> +attempts to save bounds to a BD entry marked as invalid. This is
>> +an indication that no BT exists for this entry. In this case the
>> +fault handler will allocate a new BT.
>
> Hi Qiaowei,
>
> Can you make an effort to move these comments over to the code?  The
> bounds-table allocation function is a much more appropriate place for
> this text than the Documentation/ file.
>
Ok. They will be moved.

Thanks,
Qiaowei
