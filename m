Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3LMKtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:49:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:30908 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab3LMKtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:49:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,477,1384329600"; 
   d="scan'208";a="449498773"
Message-ID: <52AAE61D.4060406@linux.intel.com>
Date: Fri, 13 Dec 2013 12:49:01 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] cleanups and optimizations
References: <20131212140835.729222186@infradead.org>
In-Reply-To: <20131212140835.729222186@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 16:08, Peter Zijlstra wrote:
> This series contains the preempt_enable_no_resched() cleanups that include
> spin_lock_bh() optimizations and local_clock() optimizations.

I'm trying to test this on tip/master.
Patch 3 fails to apply on kenrel/softirq.c

Thanks,
Eliezer
