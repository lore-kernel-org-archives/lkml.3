Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaELHJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:09:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:41079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaELHJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:09:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="538733035"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>
Cc: "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [Intel-gfx] 3.15-rc5: Regression in i915 driver?
In-Reply-To: <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1399796911.2442.7.camel@localhost.localdomain> <CAPM=9tzwkwSTC2i=KWSxmHkG74fXyyh8JiTzEaDwNgg-J_G7cw@mail.gmail.com> <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
User-Agent: Notmuch/0.18+7~g8ecc7db (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 12 May 2014 10:09:54 +0300
Message-ID: <87tx8v322l.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2014, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Sun, May 11, 2014 at 11:02 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On 11 May 2014 18:28, Thomas Meyer <thomas@m3y3r.de> wrote:
>>> Hi,
>>>
>>> 3.14.3 works as expected.
>>> 3.15-rc5 shows a strange behaviour: When resuming from ram the X server
>>> seems to be disfunctional.
>>>
>>> I see this WARNING in the kernel log before suspend to ram in the early
>>> boot process:
>
> Doesn't ring a bell really.
> - Is there anything in dmesg after resume?
> - How exactly does X misbehave? Is fbcon still working? Does X
> behaviour get restored if you restart X?
> - Can you please try to bisect this issue? Note that the backlight
> issue might be unrelated to the issues with X misbehaving after
> resume. You might need to do a bisect for both if the symptoms don't
> agree.

I agree the WARNING from i965_enable_backlight() is unrelated. Focus on
the other symptoms first.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
