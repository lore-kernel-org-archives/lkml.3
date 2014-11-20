Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaKTPpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:45:04 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKTPpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:45:01 -0500
Date: Thu, 20 Nov 2014 07:44:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHSET block/for-next] writeback: prepare for cgroup
 writeback support
Message-ID: <20141120154458.GA5862@infradead.org>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
 <20141120151311.GE2330@quack.suse.cz>
 <20141120151456.GE14877@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120151456.GE14877@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:14:56AM -0500, Tejun Heo wrote:
> > PS: I've added CC to linux-fsdevel since there's high chance people miss
> > these patches in lkml...
> 
> Will do so when posting the actual series.

Please send the prep patches to fsdevel and linux-mm.  Without that I'll
auto-NAK them :)

