Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab3GZUHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:07:40 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35183 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3GZUHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:07:39 -0400
Date: Fri, 26 Jul 2013 22:07:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] watchdog: update watchdog attributes atomically
Message-ID: <20130726200734.GB21415@gmail.com>
References: <1374842975-22982-1-git-send-email-mhocko@suse.cz>
 <20130726160745.GJ58219@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726160745.GJ58219@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Fri, Jul 26, 2013 at 02:49:34PM +0200, Michal Hocko wrote:
> > proc_dowatchdog doesn't synchronize multiple callers which
> > might lead to confusion when two parallel callers might confuse
> > watchdog_enable_all_cpus resp. watchdog_disable_all_cpus (e.g. watchdog
> > gets enabled even if watchdog_thresh was set to 0 already).
> > 
> > This patch adds a local mutex which synchronizes callers to the sysctl
> > handler.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> Acked-by: Don Zickus <dzickus@redhat.com>

Ack from you for both patches?

Thanks,

	Ingo
