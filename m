Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaHYGXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:23:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:2265 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaHYGXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:23:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="581207971"
Message-ID: <53FAD5E3.1060600@intel.com>
Date: Mon, 25 Aug 2014 09:21:23 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 00/22] perf: Add infrastructure and support for Intel
 PT
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 03:35 PM, Alexander Shishkin wrote:
> This patchset adds support for Intel Processor Trace (PT) extension [1] of
> Intel Architecture that allows the capture of information about software
> execution flow, to the perf kernel infrastructure.
> 

Alex is away, so I would like to know if anyone (Peter?) plans to review or
comment on these patches.

