Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3JVUss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 16:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab3JVUsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 16:48:47 -0400
Date: Wed, 23 Oct 2013 07:48:01 +1100
From: Dave Chinner <dchinner@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Glauber Costa <glommer@openvz.org>
Subject: Re: [PATCH] staging: ashmem: Fix ASHMEM_PURGE_ALL_CACHES return value
Message-ID: <20131022204801.GC1969@devil.localdomain>
References: <1382374687-4831-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382374687-4831-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 09:58:07AM -0700, John Stultz wrote:
> Hopefully this isn't too late for 3.12.
> 
> In commit 7dc19d5aff (convert shrinkers to new count/scan API)
> the return value to PURGE_ALL_CACHES was dropped, causing -EPERM
> to always be returned.
> 
> This patch re-adds the ret assignment, setting it to the the
> ashmem_shrink_count(), which is the lru_count.

Looks sane.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
dchinner@redhat.com
