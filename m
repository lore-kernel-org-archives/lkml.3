Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbaKTQVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:21:13 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:63743 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaKTQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:21:11 -0500
Date: Thu, 20 Nov 2014 11:21:05 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHSET block/for-next] writeback: prepare for cgroup
 writeback support
Message-ID: <20141120162105.GJ14877@htj.dyndns.org>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
 <20141120151311.GE2330@quack.suse.cz>
 <20141120151456.GE14877@htj.dyndns.org>
 <20141120154458.GA5862@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120154458.GA5862@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 07:44:58AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 20, 2014 at 10:14:56AM -0500, Tejun Heo wrote:
> > > PS: I've added CC to linux-fsdevel since there's high chance people miss
> > > these patches in lkml...
> > 
> > Will do so when posting the actual series.
> 
> Please send the prep patches to fsdevel and linux-mm.  Without that I'll
> auto-NAK them :)

Alright, I'll re-send these w/ Jan's acks added and fsdevel and
linux-mm cc'd when posting the actual patchset.

Thanks.

-- 
tejun
