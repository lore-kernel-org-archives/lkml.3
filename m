Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbaELQyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:54:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56705 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbaELQyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:54:11 -0400
Date: Mon, 12 May 2014 18:54:07 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [Intel-gfx] 3.15-rc5: Regression in i915 driver?
Message-ID: <20140512165407.GT25056@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@linux.intel.com>,
	Dave Airlie <airlied@gmail.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Meyer <thomas@m3y3r.de>
References: <1399796911.2442.7.camel@localhost.localdomain>
 <CAPM=9tzwkwSTC2i=KWSxmHkG74fXyyh8JiTzEaDwNgg-J_G7cw@mail.gmail.com>
 <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
 <87tx8v322l.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx8v322l.fsf@intel.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 10:09:54AM +0300, Jani Nikula wrote:
> On Sun, 11 May 2014, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > On Sun, May 11, 2014 at 11:02 AM, Dave Airlie <airlied@gmail.com> wrote:
> >> On 11 May 2014 18:28, Thomas Meyer <thomas@m3y3r.de> wrote:
> >>> Hi,
> >>>
> >>> 3.14.3 works as expected.
> >>> 3.15-rc5 shows a strange behaviour: When resuming from ram the X server
> >>> seems to be disfunctional.
> >>>
> >>> I see this WARNING in the kernel log before suspend to ram in the early
> >>> boot process:
> >
> > Doesn't ring a bell really.
> > - Is there anything in dmesg after resume?
> > - How exactly does X misbehave? Is fbcon still working? Does X
> > behaviour get restored if you restart X?
> > - Can you please try to bisect this issue? Note that the backlight
> > issue might be unrelated to the issues with X misbehaving after
> > resume. You might need to do a bisect for both if the symptoms don't
> > agree.
> 
> I agree the WARNING from i965_enable_backlight() is unrelated. Focus on
> the other symptoms first.

The backlight backtrace seems to be a genuine new bug. Bisecting it would
be highly appreciated. Bisecting on the other issue and appending the
result to the bug Chris quoated should also really be useful - atm we
don't have any reported who can reproduce this clearly enough to do a
bisect.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
