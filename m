Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaBVPls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 10:41:48 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57738 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaBVPlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 10:41:47 -0500
Date: Sat, 22 Feb 2014 10:41:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: Guarantee work function memory ordering
Message-ID: <20140222154135.GH12830@htj.dyndns.org>
References: <1393071111-5128-1-git-send-email-peter@hurleysoftware.com>
 <20140222144010.GE12830@htj.dyndns.org>
 <5308BCD1.3070204@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5308BCD1.3070204@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Sat, Feb 22, 2014 at 10:05:53AM -0500, Peter Hurley wrote:
> Given your concerns about the performance impact, maybe we should
> ask Fengguang to run this change through his automated test suites
> to find out what the perf delta is?

It should be fine.  It's more like I just didn't like the idea of it.
Workqueue execution path isn't really light enough for an addition of
single smp_rmb() per work item execution makes any noticeable
difference.  No harm in measuring perf delta but I'm highly skeptical
that there will be any difference which can be measured.

Thanks.

-- 
tejun
