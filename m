Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaHEVyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:54:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:41682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaHEVyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,807,1400050800"; 
   d="scan'208";a="572198847"
Date: Wed, 6 Aug 2014 05:54:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [setsockopt] WARNING: CPU: 0 PID: 1444 at
 kernel/sched/core.c:7088 __might_sleep+0x51/0x16f()
Message-ID: <20140805215434.GA10047@localhost>
References: <20140805214624.GA9973@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805214624.GA9973@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 05:46:24AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> Here is a microcode/load_module error triggered by debug check commit

Sorry for the copy&paste error! This warning is not related to
microcode/load_module..

Thanks,
Fengguang
