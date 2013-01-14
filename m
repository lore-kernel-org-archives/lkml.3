Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3ANRne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:43:34 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62745 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3ANRnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:43:33 -0500
Date: Mon, 14 Jan 2013 09:43:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, chavey@google.com, fengguang.wu@intel.com
Subject: Re: [PATCHSET] block: improve tracepoints, take#2
Message-ID: <20130114174318.GD27942@mtj.dyndns.org>
References: <1357938397-5413-1-git-send-email-tj@kernel.org>
 <20130114140227.GB2441@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114140227.GB2441@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Mon, Jan 14, 2013 at 03:02:28PM +0100, Jens Axboe wrote:
> > It's based on top of v3.8-rc2 and also available in the following git
> > branch.
> 
> Applied (with Jan's review on the writeback side). Since we now have
> buffer dirtying in the proper traces, it'd be really nice to deprecate
> the ancient block_dump and phase it out of the tree...

Yeah, that really is kinda nasty.  I'll cook up a patch to trigger a
warning message on it.  Maybe we can remove it in some years.

Thanks.

-- 
tejun
