Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaCaSnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:43:25 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:40984 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaCaSnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:43:24 -0400
Date: Mon, 31 Mar 2014 22:43:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Shawn Landden <shawn@churchofgit.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?0J/QsNCy0LXQuyDQldC80LXQu9GM0Y/QvdC+0LI=?= 
	<xemul@parallels.com>
Subject: Re: [rfc 2/2] docs: procfs -- Document timerfd output
Message-ID: <20140331184316.GM4872@moon>
References: <20140331175407.400476950@openvz.org>
 <20140331175957.606100208@openvz.org>
 <CANaxB-wY_=1QRAfvJxZjKPY6ZkgHuZOQvRm0FVktbj6-tL1CbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-wY_=1QRAfvJxZjKPY6ZkgHuZOQvRm0FVktbj6-tL1CbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:31:02PM +0400, Andrey Wagin wrote:
> > +       Timerfd files
> > +       ~~~~~~~~~~~~~
> > +       pos:    0
> > +       flags:  02
> > +       mnt_id: 9
> > +       clockid: 0 ticks: 0
> 
> I would prefer to print "tick" on a separate line.

Sure, this is not a problem to make it so.

> And we can print the current setting of the timer here. It can be
> useful not only for CRIU but for other users too.
> 
> it_value: (5, 149234)
> it_interval: (10, 0)

Yeah, moreover I think this is needed because if the timer is expired
and it's interval timer the gettime method will rearm it which we
defenitely not needed. Will update, thanks.
