Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaBZU6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:58:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:42344 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbaBZU6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:58:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="490381082"
Message-ID: <530E5584.3080203@intel.com>
Date: Wed, 26 Feb 2014 12:58:44 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] x86, mpx: add documentation on Intel MPX
References: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com> <1393162071-23995-2-git-send-email-qiaowei.ren@intel.com> <530E3DC9.90609@intel.com>
In-Reply-To: <530E3DC9.90609@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
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

Oh, or does this mean: "The Bounds Directory is contiguous in virtual
memory."  and then "Each Bound Table is contiguous in virtual memory."
But, the directory and tables do not have to be contiguous to each other?

The wording there sounds a bit confusing.
