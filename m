Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab3BWUAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 15:00:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab3BWUAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 15:00:53 -0500
Date: Sat, 23 Feb 2013 20:59:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>,
        adurbin@chromium.org
Subject: Re: [PATCH 4/5] freezer: clear fake signal on exit from
	__refrigerator
Message-ID: <20130223195922.GA11817@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-4-git-send-email-msb@chromium.org> <20130216170644.GD4910@redhat.com> <20130216171228.GF4910@redhat.com> <CACBanvoArjZ=7rjXjt5fN6MrhLohPY7NAjQwhWepnMLZbqpHdQ@mail.gmail.com> <20130223194125.GB9405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130223194125.GB9405@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot to mention...

On 02/23, Oleg Nesterov wrote:
>
> And let me repeat, as for coredump this can only solve the problems in
> wait_for_dump_handler().

And, otoh, if we change freeze_task() then wait_event_freezable()
should work just fine in wait_for_dump_handler().

> I'll try to make the coredumping fixes tomorrow, then we discuss this
> again.

Yes, I'm afraid my comments were very confusing ;) I think the patches
will explain what I mean.

Oleg.

