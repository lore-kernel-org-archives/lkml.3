Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaCNGs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:48:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:10870 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbaCNGs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,652,1389772800"; 
   d="scan'208";a="491756305"
Date: Fri, 14 Mar 2014 14:48:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [sched/balance] INFO: possible recursive locking detected
Message-ID: <20140314064853.GB29349@localhost>
References: <20140303142526.GA8517@localhost>
 <5321618F.3090801@linaro.org>
 <20140313085341.GC27627@localhost>
 <5321739B.1000506@linaro.org>
 <20140314061643.GA28194@localhost>
 <5322A110.5030405@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5322A110.5030405@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 02:26:24PM +0800, Alex Shi wrote:
> On 03/14/2014 02:16 PM, Fengguang Wu wrote:
> > Alex,
> > 
> > Here are the test results for branch alexshi/single-balance
> 
> 
> Thanks a lot! Fengguang.
> Is the nex04 machine 4P*8 core * HT? and are a04/a06 atom box?

nex04 is Nehalem-EX. a04/06 are Atom servers.

> Would you like to share the machine info for nhm8, nhm-white and xps2?

They are all 1S Nehalem PC.

Thanks,
Fengguang
