Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3CRWfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:35:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61257 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3CRWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:35:30 -0400
Date: Mon, 18 Mar 2013 15:35:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 3/4] writeback: replace custom worker pool implementation
 with unbound workqueue
Message-ID: <20130318223526.GH3042@htj.dyndns.org>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <1362692649-25570-4-git-send-email-tj@kernel.org>
 <20130312150510.GF13152@quack.suse.cz>
 <20130318223244.GA11188@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318223244.GA11188@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Mon, Mar 18, 2013 at 11:32:44PM +0100, Jan Kara wrote:
>   I realized there may be one issue - so far we have a clear identification
> which thread works for which bdi in the thread name (flush-x:y naming).
> That was useful when debugging things. Now with your worker pool this is
> lost, am I right? Would it be possible to restore that?

Unfortunately not directly.  It shouldn't be difficult to tell who's
working on what from workqueue and writeback tracepoints tho.

Thanks.

-- 
tejun
