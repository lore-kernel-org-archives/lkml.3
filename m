Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaCGMai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:30:38 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:43246 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaCGMag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:30:36 -0500
Date: Fri, 7 Mar 2014 07:30:32 -0500
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 1/5][RFC][CFT] percpu fixes, part 1
Message-ID: <20140307123032.GB30778@htj.dyndns.org>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305034919.GA26528@ZenIV.linux.org.uk>
 <20140306192026.GA14033@htj.dyndns.org>
 <20140306203030.GA18016@ZenIV.linux.org.uk>
 <20140306204726.GE14033@htj.dyndns.org>
 <20140307025206.GB18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307025206.GB18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 02:52:06AM +0000, Al Viro wrote:
> On Thu, Mar 06, 2014 at 03:47:26PM -0500, Tejun Heo wrote:
> 
> > Not much, but it should at least help bisection if something goes
> > wrong, I think.
> 
> OK.  It looks better when folding pcpu_split_block() into the caller
> is done as the first step.  See the attached 3 patches - combination
> is the same, modulo comment addition and switching seen_free to bool.

All look good to me.  Applying them to percpu/for-3.15.

Thanks.

-- 
tejun
