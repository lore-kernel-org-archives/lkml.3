Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab3CGWOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:14:02 -0500
Received: from mga03.intel.com ([143.182.124.21]:44661 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759041Ab3CGWOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:14:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,804,1355126400"; 
   d="scan'208";a="266335264"
Message-ID: <51391114.9040608@linux.intel.com>
Date: Thu, 07 Mar 2013 14:13:40 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: dave@sr71.net, linux-kernel@vger.kernel.org, bp@alien8.de, x86@kernel.org,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        khlebnikov@openvz.org, bhelgaas@google.com
Subject: Re: [PATCH] do not try to sync identity map for non-mapped pages
References: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com> <201303080705.CFJ06290.FHMFVtOSJFLOQO@I-love.SAKURA.ne.jp>
In-Reply-To: <201303080705.CFJ06290.FHMFVtOSJFLOQO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 02:05 PM, Tetsuo Handa wrote:
> 
> Excuse me, but I didn't realize that the link is wrong.
> 
> https://lkml.org/lkml/2013/2/5/396 is a bug in CONFIG_MICROCODE_INTEL_EARLY=y
> && CONFIG_64BIT=n && CONFIG_DEBUG_VIRTUAL=y where patches are not available.
> 
> https://lkml.org/lkml/2013/3/5/314 is a bug in CONFIG_ACPI=y &&
> CONFIG_DEBUG_VIRTUAL=y where your patch fixes.
> 
> Please use https://lkml.org/lkml/2013/3/5/314 rather than
> https://lkml.org/lkml/2013/2/5/396 in your patch.
> 

*Grump* I of course already committed it and other things on top.

We shouldn't really use lkml.org links anyway since if that site
disappears those numbers are meaningless; rather, using Message-IDs
(e.g. as embedded in lkml.kernel.org links) is better...

	-hpa


