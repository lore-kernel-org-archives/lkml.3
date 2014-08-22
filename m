Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaHVF3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 01:29:30 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53021 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaHVF33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 01:29:29 -0400
Date: Fri, 22 Aug 2014 07:29:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@kernel.org,
        acme@infradead.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 1/2] perf/x86/intel: Add Haswell-EP uncore support
Message-ID: <20140822052926.GM4120@two.firstfloor.org>
References: <1408499458-6555-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408499458-6555-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 4785ee8..2485fd9 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -883,6 +883,8 @@ static int __init uncore_pci_init(void)
>  	case 62: /* Ivy Bridge-EP */
>  		ret = ivbep_uncore_pci_init();
>  		break;
> +	case 63: /* Haswell-EP */
> +		ret = hswep_uncore_pci_init();

Is the lack of break intentional? If yes please add a /* FALL THROUGH */
comment.

>  	case 42: /* Sandy Bridge */
>  		ret = snb_uncore_pci_init();
>  		break;
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
