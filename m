Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbbAGOTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:19:48 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbAGOTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:19:47 -0500
Date: Wed, 7 Jan 2015 06:19:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz,
        hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
        vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, mhocko@suse.cz
Subject: Re: [PATCHSET v2 block/for-next] writeback: prepare for cgroup
 writeback support
Message-ID: <20150107141945.GA29680@infradead.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This needs a rebase over my "backing_dev_info cleanups" series, which
starts to sort out the bdi lifetime issues.  I think this series is
fine to go over just that, but before any bigger bdi changes we'll
also need to sort out the rest of the lifetime issues.  I have some
WIP patches for that which I'll be able to post soon.
