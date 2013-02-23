Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab3BWBe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:34:57 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:45628 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab3BWBew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:34:52 -0500
Date: Fri, 22 Feb 2013 17:34:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [idr/perf_init_event] BUG: unable to handle kernel NULL pointer
 dereference at (null)
Message-ID: <20130223013448.GR3570@htj.dyndns.org>
References: <20130223013011.GA9484@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130223013011.GA9484@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Feb 23, 2013 at 09:30:11AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit f5947173c082a04a9804bb42a91a0f5df5ee0527
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Feb 20 02:05:52 2013 +0000
> 
>     idr: implement lookup hint

Andy Shevchenko already posted fix two days ago.  Let me check whether
that went in yet.

Thanks.

-- 
tejun
