Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaIXOuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:50:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaIXOuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:50:13 -0400
Date: Wed, 24 Sep 2014 15:59:07 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20140924145906.GC2695@agordeev.usersys.redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924143913.GH16555@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:39:13AM -0400, Tejun Heo wrote:
> Would it be possible for you compare threaded vs. unthreaded under
> relatively heavy load?

I will try, although not quite soon.

In the meantime I could fix and resend patches 1,2,3 and 6 as
they are not related to this topic. Makes sense?

> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
