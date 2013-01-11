Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3AKUI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:08:56 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50801 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3AKUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:08:43 -0500
Date: Fri, 11 Jan 2013 12:08:39 -0800
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com
Subject: Re: [PATCHSET] block: improve tracepoints
Message-ID: <20130111200839.GR20454@htj.dyndns.org>
References: <1357749908-16562-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357749908-16562-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 08:45:03AM -0800, Tejun Heo wrote:
> Hello, Jens.
> 
> This patchset fixes/improves bio_complete TP so that block layer
> proper triggers for all completing bios instead of stackign drivers
> triggering them manually and adds more buffer / block / writeback TPs.
> These improve visibility in general and are already in use in google.
> 
> This patchset contains the following five patches.
> 
>  0001-block-add-missing-block_bio_complete-tracepoint.patch
>  0002-block-add-req-to-bio_-front-back-_merge-tracepoints.patch
>  0003-buffer-make-touch_buffer-an-exported-function.patch
>  0004-block-add-block_touch_buffer-tracepoint.patch
>  0005-writeback-add-more-tracepoints.patch

Jens, I botched the dirty_buffer TP.  Please ignore this patchset.
Will post updated revision soon.

Thanks.

-- 
tejun
