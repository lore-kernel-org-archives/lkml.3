Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaBZVpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:45:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45902 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaBZVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:45:10 -0500
Message-ID: <530E6048.9040600@zytor.com>
Date: Wed, 26 Feb 2014 13:44:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] x86, mpx: add documentation on Intel MPX
References: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com> <1393162071-23995-2-git-send-email-qiaowei.ren@intel.com> <530E3DC9.90609@intel.com>
In-Reply-To: <530E3DC9.90609@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 11:17 AM, Dave Hansen wrote:
> On 02/23/2014 05:27 AM, Qiaowei Ren wrote:
>> +Bounds Directory (BD) and Bounds Tables (BT) are stored in
>> +application memory and are allocated by the application (in case
>> +of kernel use, the structures will be in kernel memory). The
>> +bound directory and each instance of bound table are in contiguous
>> +linear memory.
> 
> Hi Qiaowei,
> 
> Does this mean that if userspace decided to map something in the way of
> the bounds tables that it would break MPX?
> 
> Also, in the description, could we s/linear/virtual/?  Linear seems to
> be the term that Intel likes to use in its documents, but we almost
> universally call them virtual addresses in the kernel.
> 

It might be useful to clarify, though, just so noone gets confused with
effective addresses (offsets).

	-hpa

