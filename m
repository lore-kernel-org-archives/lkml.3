Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaHXTEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:04:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48368 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaHXTEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:04:11 -0400
Date: Sun, 24 Aug 2014 12:04:08 -0700 (PDT)
Message-Id: <20140824.120408.894996451904247807.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: Knut_Petersen@t-online.de, tianyu.lan@intel.com,
        rafael.j.wysocki@intel.com, trenn@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [Bug 3.14.17] inconsistent lock state
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwNrUvZYDOPHK0WS8p+t3PFyRjfoSw1HGUGxPvEiO7HmQ@mail.gmail.com>
References: <53F9CC77.70009@t-online.de>
	<CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
	<CA+55aFwNrUvZYDOPHK0WS8p+t3PFyRjfoSw1HGUGxPvEiO7HmQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 Aug 2014 12:04:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Aug 2014 11:49:31 -0700

> On Sun, Aug 24, 2014 at 10:50 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Sun, Aug 24, 2014 at 4:28 AM, Knut Petersen
>> <Knut_Petersen@t-online.de> wrote:
>>>
>>> Since months the postmaster wantonly blocks all mail traffic from the
>>> biggest german ISP t-online.de to all vger.kernel.org mailing lists,
>>> therefore I could not cc lkml.
>>
>> Hmm.
> 
> Looks like t-online used to have serious spam problems, with lots of
> bad users etc.
> 
> Judging by googling, that _seems_ to have been fixed, and maybe vger
> should unblock it again. Davem?

It's not that they are a source of SPAM, but rather their problem is
their content filter, about %30 of lkml postings get bounced back to
postmaster.

I really don't want t-online accounts subscribing to the mailing
lists, there are many alternative email services people could use
instead.
