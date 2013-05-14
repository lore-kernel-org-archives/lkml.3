Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab3ENIHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:07:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:8301 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab3ENIH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:07:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,667,1363158000"; 
   d="scan'208";a="337256220"
Message-ID: <5191F0AE.9050406@intel.com>
Date: Tue, 14 May 2013 16:07:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com
Subject: Re: [patch 0/8]: use runnable load avg in balance
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 11:17 PM, Alex Shi wrote:
> On SNB EP 4 sockets machine, the hackbench increased about 50%, and result
> become stable. on other machines, hackbench increased about 2~10%.
> oltp increased about 30% in NHM EX box.
> netperf loopback also increased on SNB EP 4 sockets box.
> no clear changes on other benchmarks.

Paul, Michael, Morten, any comments are appreciated from you! :)

-- 
Thanks
    Alex
