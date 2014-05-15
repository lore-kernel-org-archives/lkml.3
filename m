Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaEOOiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:38:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:3351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbaEOOiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:38:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="532453041"
Message-ID: <5374D12C.9030400@intel.com>
Date: Thu, 15 May 2014 07:37:32 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] drm: Missed clflushopt in drm_clflush_virt_range
References: <1400082072-22482-1-git-send-email-ross.zwisler@linux.intel.com> <20140515123846.GQ8790@phenom.ffwll.local>
In-Reply-To: <20140515123846.GQ8790@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 05:38 AM, Daniel Vetter wrote:
> On Wed, May 14, 2014 at 09:41:12AM -0600, Ross Zwisler wrote:
>> With this commit:
>>
>> 2a0788dc9bc4 x86: Use clflushopt in drm_clflush_virt_range
>>
>> If clflushopt is available on the system, we use it instead of clflush
>> in drm_clflush_virt_range.  There were two calls to clflush in this
>> function, but only one was changed to clflushopt.  This patch changes
>> the other clflush call to clflushopt.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Reported-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
>>
>> Cc: David Airlie <airlied@linux.ie>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: H Peter Anvin <h.peter.anvin@intel.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
> 
> Picked to my topic/core-stuff drm branch so it doesn't get lost.
> -Daniel
> 

Does this mean you're picking this up, or do you want me to put it into
-tip?

	-hpa


