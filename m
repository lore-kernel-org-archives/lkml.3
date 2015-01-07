Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbbAGPMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:12:01 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:53379 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbbAGPL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:11:58 -0500
Date: Wed, 7 Jan 2015 10:11:54 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz
Subject: Re: [PATCHSET v2 block/for-next] writeback: prepare for cgroup
 writeback support
Message-ID: <20150107151154.GB4395@htj.dyndns.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
 <20150107141945.GA29680@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107141945.GA29680@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 07, 2015 at 06:19:45AM -0800, Christoph Hellwig wrote:
> This needs a rebase over my "backing_dev_info cleanups" series, which
> starts to sort out the bdi lifetime issues.  I think this series is

Shouldn't be a problem.

> fine to go over just that, but before any bigger bdi changes we'll
> also need to sort out the rest of the lifetime issues.  I have some
> WIP patches for that which I'll be able to post soon.

Sure, remaining uses should really pin everything down to the
request_queue.  That said, this patchset shouldn't affect the lifetime
management of bdi's.  Nothing spills out of bdi proper.

Thanks.

-- 
tejun
