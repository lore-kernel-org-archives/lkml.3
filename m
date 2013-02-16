Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3BPHCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 02:02:45 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:47197 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3BPHCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 02:02:44 -0500
Date: Sat, 16 Feb 2013 11:02:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, davej@redhat.com, keescook@chromium.org,
        stable@vger.kernel.org, tglx@linutronix.de, ebiederm@xmission.com
Subject: Re: + futex-avoid-kernel-taint-caused-by-get_robust_list.patch added
 to -mm tree
Message-ID: <20130216070240.GA20312@moon>
References: <20130215222653.B8B115A41F0@corp2gmr1-2.hot.corp.google.com>
 <20130215234444.29345fc3@spider.haslach.nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215234444.29345fc3@spider.haslach.nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:44:44PM +0100, Richard Weinberger wrote:
> > The ability to deprecate this code has been called into question[1],
> > but if that remains to be finalized, then making this change in the
> > interim seems to make sense.
> 
> Do we really want to remove this system call in 2013?
> Note, Documentation/feature-removal-schedule.txt is gone...
> 
> CRIU folks, I guess you still need the call?
> Or have you found an alternative way to get the robost list?

Yes, we need this call and we use it.

> As stated in [0], I'd simply revert commit ec0c4274 ("futex: Mark
> get_robust_list as deprecated")

Thanks!
