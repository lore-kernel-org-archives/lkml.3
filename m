Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3EGQOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:14:19 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:56627 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448Ab3EGQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:14:17 -0400
Date: Tue, 7 May 2013 09:14:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 33/33] blk-throttle: implement proper hierarchy support
Message-ID: <20130507161412.GA4948@mtj.dyndns.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
 <1367880372-28312-34-git-send-email-tj@kernel.org>
 <20130507135511.GA7082@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507135511.GA7082@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, May 07, 2013 at 09:55:11AM -0400, Vivek Goyal wrote:
> So if somebody does not specify __DEVEL_sane_behavior, hierarchy is
> still broken. Should we continue to display the message in that case?

The message is to warn people of possible behavior changes.  For
blk-throttle, the behaviors are settled now.  Whetner sane_behavior or
not, the hierarchy behaviors aren't gonna change anymore.  The
hindsight is 20/20 and it would probably have been better if we had
done the same for cfq but I was thinking that we could probably do
away with interface versioning at the time.  Ah well... it isn't
optimal but that's what we ended up with.

Thanks.

-- 
tejun
