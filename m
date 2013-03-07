Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3CGPkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:40:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab3CGPkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:40:45 -0500
Date: Thu, 7 Mar 2013 10:40:33 -0500
From: Don Zickus <dzickus@redhat.com>
To: anish singh <anish198519851985@gmail.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, chuansheng.liu@intel.com,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
Message-ID: <20130307154033.GU119376@redhat.com>
References: <1361016849-5181-1-git-send-email-anish198519851985@gmail.com>
 <20130218204858.GB98867@redhat.com>
 <CAK7N6vqjvVprjxUiqtkxvF6kJ5SV0tUvOggxCOdEC9eSqYLcuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7N6vqjvVprjxUiqtkxvF6kJ5SV0tUvOggxCOdEC9eSqYLcuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 05:17:04PM +0530, anish singh wrote:
> On Tue, Feb 19, 2013 at 2:18 AM, Don Zickus <dzickus@redhat.com> wrote:
> > On Sat, Feb 16, 2013 at 05:44:09PM +0530, anish kumar wrote:
> >> From: anish kumar <anish198519851985@gmail.com>
> >>
> >> This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
> >> Uses are:
> >> 1. Check if smpboot_register_percpu_thread function passed.
> >> 2. Makes sure that user enables and disables the watchdog in sequence
> >>    i.e. enable watchdog->disable watchdog->enable watchdog
> >>    Unlike enable watchdog->enable watchdog which is wrong.
> >>
> >> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> >> ---
> >>  kernel/watchdog.c |    5 +++++
> >>  1 files changed, 5 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> >> index 75a2ab3..8a20ebe 100644
> >> --- a/kernel/watchdog.c
> >> +++ b/kernel/watchdog.c
> >> @@ -518,6 +518,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
> >>               return ret;
> >>
> >>       set_sample_period();
> >> +     /*
> >> +      * Watchdog threads shouldn't be enabled if they are
> >> +      * disabled.'watchdog_disabled' variable check in
> >
> > Missing a 'The'  ^^^
> >
> > Other than that,
> >
> > Acked-by: Don Zickus <dzickus@redhat.com>
> Is this patch picked up?

Andrew,

Do you want me to respin the patch with that change? Or how should I move
this patch forward?

Cheers,
Don
