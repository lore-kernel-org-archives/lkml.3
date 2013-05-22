Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3EVSvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab3EVSvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:51:11 -0400
Date: Wed, 22 May 2013 14:50:14 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, dm-crypt@saout.de,
        Christian Schmidt <schmidt@digadd.de>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Message-ID: <20130522185014.GA17423@redhat.com>
References: <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
 <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
 <20130412182941.GF11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304150827480.1859@file.rdu.redhat.com>
 <20130416172418.GB2874@mtj.dyndns.org>
 <20130418164742.GA8254@redhat.com>
 <20130418170317.GA9897@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418170317.GA9897@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18 2013 at  1:03pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello, Mike.
> 
> On Thu, Apr 18, 2013 at 12:47:42PM -0400, Mike Snitzer wrote:
> > I see you nack and raise you with: please reconsider in the near term.
> 
> The thing is that percpu-refcnting is already in mostly ready-form, so
> unless this dm series is planned to be merged for v3.10-rc1, I don't
> see the need for a separate near term solution.  Mikulas can just do
> the normal refcnting and cgroup will most likely adopt per-cpu ref
> anyway once percpu-refcnting is in, so it should all fall in places
> pretty quickly.  For devel / testing / whatever, Mikulas can surely
> turn off cgroup, right?

Hey Tejun,

Was wondering: how is percpu-refcounting coming along?  Do you have a
pointer to the code that can be pulled in for use by Mikulas' dm-crypt
changes?

Would be nice to get this stuff sorted out for the 3.11 merge window.

Mike
