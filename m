Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920Ab3ECJYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:24:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34303 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3ECJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:24:15 -0400
Date: Fri, 3 May 2013 11:24:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 02/10] freezer: skip waking up tasks with
 PF_FREEZER_SKIP set
Message-ID: <20130503092413.GB13832@amd.pavel.ucw.cz>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-3-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367458508-9133-3-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-05-01 18:35:00, Colin Cross wrote:
> Android goes through suspend/resume very often (every few seconds when
> on a busy wifi network with the screen off), and a significant portion
> of the energy used to go in and out of suspend is spent in the
> freezer.  If a task has called freezer_do_not_count(), don't bother
> waking it up.  If it happens to wake up later it will call
> freezer_count() and immediately enter the refrigerator.
> 
> Combined with patches to convert freezable helpers to use
> freezer_do_not_count() and convert common sites where idle userspace
> tasks are blocked to use the freezable helpers, this reduces the
> time and energy required to suspend and resume.
> 
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
