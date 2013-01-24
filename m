Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3AXW4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:56:05 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38438 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab3AXW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:56:01 -0500
Date: Thu, 24 Jan 2013 14:55:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for
 multimedia devices
Message-ID: <20130124225555.GC2373@mtj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 04:00:42PM +0100, Paolo Bonzini wrote:
> Strangely, a couple of MMC commands were never included.  Add them too.

What are the justifications for adding these commands to the filter?
Are there users requesting these?

Thanks.

-- 
tejun
