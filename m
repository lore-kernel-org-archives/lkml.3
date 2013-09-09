Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3IIRFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:05:14 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44155 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab3IIRFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:05:11 -0400
Date: Mon, 9 Sep 2013 19:05:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: perf, x86: Add parts of the remaining haswell PMU
 functionality v5
Message-ID: <20130909170509.GV19750@two.firstfloor.org>
References: <1378438661-24765-1-git-send-email-andi@firstfloor.org>
 <20130909081104.GA19980@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909081104.GA19980@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:11:05AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I hope this version is ok for everyone now.
> 
> This version arrived in the middle of the merge window, will look after 
> -rc1 has been released.

Ok.
> 
> If there are any bugfixes (or erratum fixes/workarounds) pending then 
> you'll need to send them separately against the current code base.

I consider the checkpoint patch a problem workaround. I'll send 
that one separately.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
