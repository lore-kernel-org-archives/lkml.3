Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCLUVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:21:11 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:46604 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaCLUVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:21:08 -0400
Date: Wed, 12 Mar 2014 16:21:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mark Brown <broonie@kernel.org>, Greg KH <greg@kroah.com>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140312202102.GB22332@htj.dyndns.org>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <1394596541.4840.70.camel@pasglop>
 <20140312113742.GM28112@sirena.org.uk>
 <1394654396.4840.94.camel@pasglop>
 <20140312200232.GA22332@htj.dyndns.org>
 <1394655292.4840.97.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394655292.4840.97.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 13, 2014 at 07:14:52AM +1100, Benjamin Herrenschmidt wrote:
> It's generally consider bad taste to pull entire trees into each
> other :-) I know Stephen isn't fan of it...

I wouldn't say it's considered "generally" bad taste.  For one-off
changes, maybe.  This was a rather large restructuring of the whole
thing, so actually duplicating all the rather significant commits
would be a lot worse.

> I'd rather have just that series (or even better, just the patches
> introducing the new function) in a topic branch, itself pulled into
> both driver-core-next and my tree.
> 
> Can you produce that ? (I need a non-rebase guarantee though).

It's a series of rather complex patches.  I really don't think
duplicating them is a good idea.  We can either resurrect the old API
to kill it again or set up a merge branch which I don't think is too
unusual in situations like this.

Thanks.

-- 
tejun
