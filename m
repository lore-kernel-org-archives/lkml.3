Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3AYREl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:04:41 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:59601 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3AYREj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:04:39 -0500
Date: Fri, 25 Jan 2013 09:04:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for
 multimedia devices
Message-ID: <20130125170434.GC3081@htj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
 <20130124225555.GC2373@mtj.dyndns.org>
 <51024FB1.3000206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51024FB1.3000206@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paolo.

On Fri, Jan 25, 2013 at 10:26:09AM +0100, Paolo Bonzini wrote:
> > What are the justifications for adding these commands to the filter?
> > Are there users requesting these?
> 
> I think it's the other way round.  What's the justification for leaving
> them out, if they are in the standard?  Since we're touching the
> commands for other standards, it's better to be complete for MMC as well.

Maybe my experience with ATA left me bitter with the standards, but
opening gate to everything described in standard sounds like a pretty
bad idea to me.  If there are users and devices which make use of them
in sane way, sure.  If not, what's the point of risking it?

> At least one of them (MECHANISM STATUS) is implemented in both QEMU and
> Bochs, so someone is using it.  If that someone were run virtualized,
> with the host /dev/sr0 passed directly to the guest rather than
> emulated, it would break.

Sure, then, enable MECHANISM_STATUS.

Thanks.

-- 
tejun
