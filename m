Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3ANOCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:02:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab3ANOCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:02:32 -0500
Date: Mon, 14 Jan 2013 15:02:28 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, chavey@google.com, fengguang.wu@intel.com
Subject: Re: [PATCHSET] block: improve tracepoints, take#2
Message-ID: <20130114140227.GB2441@kernel.dk>
References: <1357938397-5413-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357938397-5413-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11 2013, Tejun Heo wrote:
> drivers
> triggering them manually and adds more buffer / block / writeback TPs.
> These improve visibility in general and are already in use in google.
> 
> This patchset contains the following five patches.
> 
> 0001-block-add-missing-block_bio_complete-tracepoint.patch
> 0002-block-add-req-to-bio_-front-back-_merge-tracepoints.patch
> 0003-buffer-make-touch_buffer-an-exported-function.patch
> 0004-block-add-block_-touch-dirty-_buffer-tracepoint.patch
> 0005-writeback-add-more-tracepoints.patch
> 
> It's based on top of v3.8-rc2 and also available in the following git
> branch.

Applied (with Jan's review on the writeback side). Since we now have
buffer dirtying in the proper traces, it'd be really nice to deprecate
the ancient block_dump and phase it out of the tree...

-- 
Jens Axboe

