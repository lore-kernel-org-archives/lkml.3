Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750729Ab3HSDNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:13:13 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:40356 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3HSDNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:13:12 -0400
Date: Mon, 19 Aug 2013 06:13:06 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Ingo Molnar <mingo@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [GIT PULL] Generic sched_clock fix for 3.11
Message-ID: <20130819031306.GF3922@tarshish>
References: <51F6CDB1.4070408@linaro.org>
 <20130812161311.GA16470@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812161311.GA16470@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, Aug 12, 2013 at 06:13:11PM +0200, Ingo Molnar wrote:
> 
> * John Stultz <john.stultz@linaro.org> wrote:
> 
> > Hey Thomas,
> >     Just one small fix against tip/timers/urgent for 3.11.
> > 
> > thanks
> > -john
> > 
> > 
> > The following changes since commit b0ec636c93ddd77235bf0f023a8a95d78cb6cafe:
> > 
> >   Merge branch 'timers/clockevents' of
> > git://git.linaro.org/people/dlezcano/clockevents into timers/urgent
> > (2013-07-12 17:10:30 +0200)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://git.linaro.org/people/jstultz/linux.git fortglx/3.11/time
> > 
> > for you to fetch changes up to 53c035204253efe373d9ff166fae6147e8c693b6:
> > 
> >   sched_clock: Fix integer overflow (2013-07-22 16:24:22 -0700)
> > 
> > ----------------------------------------------------------------
> > Baruch Siach (1):
> >       sched_clock: Fix integer overflow
> > 
> >  kernel/time/sched_clock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Pulled, thanks John!

Do you intend to push it for -rc7?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
