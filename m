Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3KRRj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:39:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:5126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab3KRRjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:39:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="389909186"
Message-ID: <528A5058.40505@linux.intel.com>
Date: Mon, 18 Nov 2013 09:37:28 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH v1.1] x86: intel-mid: add test module for sfi_device()
References: <1384370961-30847-1-git-send-email-david.a.cohen@linux.intel.com> <1384560558-10462-1-git-send-email-david.a.cohen@linux.intel.com> <20131118152806.GB19649@infradead.org> <528A4FED.3030709@linux.intel.com>
In-Reply-To: <528A4FED.3030709@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 09:35 AM, David Cohen wrote:
> On 11/18/2013 07:28 AM, Christoph Hellwig wrote:
>> On Fri, Nov 15, 2013 at 04:09:18PM -0800, David Cohen wrote:
>>> This patch adds a test module to validate sfi_device() when used from a
>>> driver module.
>>
>> I don't think this is all that useful.  How about you prepeare a few
>> of the more useful drivers from your tree for submission instead?
> 
> One of these drivers you can track here:
> https://patchwork.kernel.org/patch/3109791/
> This is necessary to enable serial console on Saltbay (Merrifield based
> platform). But the driver is still being reworked to be upstreamed.
> 
> Anyway, upstream those drivers won't work to validate this patch set
> we're discussion here. All platform codes are bool (can't be module).

I meant: all upstreamed platform codes are bool.

> The real purpose of these patches is to make my internal tree to be
> equal to upstream. My intention is to upstream *all* internal patches
> of Intel MID and temporarily move away from arch/x86/platform/intel-
> mid/device_libs/ the platform code from still-on-staging-state drivers.
> 
> So, we need a dummy module on upstream to make this code testable.
> 
> In case this code is not accepted, I'll will have to maintain 2
> official public branches: one with these patches and one without them.
> 
> Br, David
> 

