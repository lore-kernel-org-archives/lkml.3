Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3BRBjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:39:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:57002 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab3BRBi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:38:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,683,1355126400"; 
   d="scan'208";a="288398274"
Date: Mon, 18 Feb 2013 09:38:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: mingo@kernel.org, peterz@infradead.org, jbeulich@suse.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mina86@mina86.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, jun.zhang@intel.com
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Message-ID: <20130218013852.GA11231@localhost>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
 <1361023075.11130.12.camel@cliu38-desktop-build>
 <1361023812.11130.15.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361023812.11130.15.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuansheng,

It works fine on tip/next. Thanks for the fix!

Tested-by: Fengguang Wu <fengguang.wu@intel.com>
