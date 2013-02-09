Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835Ab3BITdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:33:41 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:42820 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3BITdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:33:39 -0500
Date: Sat, 9 Feb 2013 11:33:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH 10/25] kprobes: fix wait_for_kprobe_optimizer()
Message-ID: <20130209193335.GH2875@htj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-11-git-send-email-tj@kernel.org>
 <50D922C9.3020706@hitachi.com>
 <20130128194949.GJ22465@mtj.dyndns.org>
 <5107B82E.4020403@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5107B82E.4020403@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 08:53:18PM +0900, Masami Hiramatsu wrote:
> >> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > 
> > Can I take it through workqueue branch w/ other patches?
> 
> Yes, of course. I think it is not a critical bug, so I can
> wait for other patches.

Applied to wq/for-3.9-cleanups.

Thanks!

-- 
tejun
