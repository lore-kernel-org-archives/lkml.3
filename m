Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaIYD1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:27:21 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:51905 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaIYD1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:27:19 -0400
Date: Wed, 24 Sep 2014 23:27:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20140925032716.GC6903@mtj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
 <20140924145906.GC2695@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924145906.GC2695@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:59:07PM +0100, Alexander Gordeev wrote:
> On Wed, Sep 24, 2014 at 10:39:13AM -0400, Tejun Heo wrote:
> > Would it be possible for you compare threaded vs. unthreaded under
> > relatively heavy load?
> 
> I will try, although not quite soon.
> 
> In the meantime I could fix and resend patches 1,2,3 and 6 as
> they are not related to this topic. Makes sense?

Yeap, sure thing.

Thanks.

-- 
tejun
