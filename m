Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab3BTKh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:37:27 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:40861 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab3BTKhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:37:25 -0500
Date: Wed, 20 Feb 2013 11:37:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3] lockdep: check that no locks held at freeze time
Message-ID: <20130220103719.GA7691@gmail.com>
References: <20130216170605.GC4910@redhat.com>
 <1361325468-7998-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361325468-7998-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@chromium.org> wrote:

> We shouldn't try_to_freeze if locks are held. Verified that
> I get no lockdep warnings after applying this patch and
> "vfork: don't freezer_count() for in-kernel users of CLONE_VFORK".
> 
> Changes since v1:
> * LKML: <20130215111635.GA26955@gmail.com> Ingo Molnar
>   * Added a msg string that gets passed in.
> * LKML: <20130215154449.GD30829@redhat.com> Oleg Nesterov
>   * Check PF_NOFREEZE in try_to_freeze().
> Changes since v2:
> * LKML: <20130216170605.GC4910@redhat.com> Oleg Nesterov
>   * Avoid unnecessary PF_NOFREEZE check when !CONFIG_LOCKDEP.
> * Mandeep Singh Baines
>   * Generalize an exit specific printk.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Ingo Molnar <mingo@redhat.com>

Looks good to me now.

Acked-by: Ingo Molnar <mingo@kernel.org>

Which tree should this go through?

Thanks,

	Ingo
