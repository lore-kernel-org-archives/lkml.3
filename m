Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab3GRFjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 01:39:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:41931 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab3GRFja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 01:39:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,690,1367996400"; 
   d="scan'208";a="372176909"
Message-ID: <51E77F90.3040007@intel.com>
Date: Thu, 18 Jul 2013 13:39:28 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yan, Zheng" <zheng.z.yan@intel.com>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        eranian@google.com, ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
In-Reply-To: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 01:36 PM, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Compare to old atom, Silvermont has offcore and has more events
> that support PEBS.
> 
> Silvermont has two offcore response configuration MSRs, but the
> event code for OFFCORE_RSP_1 is 0x02b7. To avoid complicating
> intel_fixup_er(), use INTEL_UEVENT_EXTRA_REG to define offcore
> MSRs. So intel_fixup_er() can find the code for OFFCORE_RSP_1
> by x86_pmu.extra_regs[1].event.
>

Document is at http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf, but it has no PEBS event list.
