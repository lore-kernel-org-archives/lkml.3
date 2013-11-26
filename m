Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab3KZXXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:23:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:7542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab3KZXXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:23:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,778,1378882800"; 
   d="scan'208";a="415601053"
Date: Tue, 26 Nov 2013 15:23:32 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/8] Cure faux idle wreckage
Message-ID: <20131126152332.1b0dbbdb@ultegra>
In-Reply-To: <20131126155743.116756708@infradead.org>
References: <20131126155743.116756708@infradead.org>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013 16:57:43 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Respin of the earlier series that tries to cure the 2 idle injection
> drivers and cleans up some of the preempt_enable_no_resched() mess.
> 
> The intel_powerclamp driver is tested by Jacob Pan and needs one more
> patch to cpuidle to work as before. I'll let him provide this patch;
> since he actually has it and tested it.
> 
> Jacob also said he'll try and work with the QoS people to sort out
> the conflict of interest between the idle injectors and the QoS
> framework.
[Jacob Pan] I have sent out a patch to hook up powerclamp with qos.
Please review. Ideally, this should be in one patchset to avoid
performance regression in powerclamp. If the qos hook is acceptable, it
can be easily used by ACPI PAD, I think.

Jacob
