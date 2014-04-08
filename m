Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbaDHRt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:49:58 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37459 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615AbaDHRtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:49:55 -0400
Date: Tue, 8 Apr 2014 19:49:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Mauro Chehab <m.chehab@samsung.com>
Subject: Re: [RFC PATCH] time: Fix truncation in jiffies_to_usecs()
Message-ID: <20140408174946.GA11121@localhost.localdomain>
References: <0214020@agluck-desk.sc.intel.com>
 <CA+8MBb+E_zT47qu4a6pqQWArrhs0gv1W=JKoy252_-Uw6HfbkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+E_zT47qu4a6pqQWArrhs0gv1W=JKoy252_-Uw6HfbkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 10:34:51PM -0700, Tony Luck wrote:
> On Mon, Apr 7, 2014 at 3:25 PM, Tony Luck <tony.luck@intel.com> wrote:
> 
> > c) If not this ... then what? Separate routine to convert large numbers
> >    of jiffies to usec/nsecs?  Should we make the existing one barf when
> >    handed a number that overflows?
> 
> Having thought about this a bit more - I'm leaning towards leaving
> jiffies_to_usecs() alone, but using it as a model for a from-scratch
> implementation of:
> u64 jiffies_to_nsecs(const unsigned long j)
> {
> }
> 
> This is what the uptime tracer actually needs - and there is only
> one user of jiffies_to_nsecs() to worry about.

I'm not sure I get what you're trying to do. We already have jiffies_to_nsecs().
Anyway I'll just wait and check out the next patch :)

Thanks.
