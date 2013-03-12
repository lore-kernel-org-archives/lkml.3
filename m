Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab3CLRKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:10:43 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57687 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab3CLRKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:10:42 -0400
Date: Tue, 12 Mar 2013 10:10:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: laijs@cn.fujitsu.com, fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        jmoyer@redhat.com, Jan Kara <jack@suse.cz>
Subject: Re: [PATCHSET] writeback: convert writeback to unbound workqueue
Message-ID: <20130312171037.GO24522@htj.dyndns.org>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <20130312150633.GZ25165@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312150633.GZ25165@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Jens.

On Tue, Mar 12, 2013 at 04:06:33PM +0100, Jens Axboe wrote:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-writeback-conversion
> 
> I like it, diffstat looks nice too :-)
> 
> Have you done any performance testing, or just functional verification?

Only functional test at this point.  I'm buliding NUMA awareness to
workqueue and planning on doing comparison of before-wq, after-wq,
after-wq-with-NUMA-awareness.  I don't expect any tangible difference
between before-wq and after-wq tho.  It would be great if someone can
recommend me a test scenario which can emphasize CPU overhead of
writeback tasks.  Any ideas?

Thanks.

-- 
tejun
