Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3EGCKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:10:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38740 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3EGCKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:10:45 -0400
Date: Mon, 06 May 2013 22:10:41 -0400 (EDT)
Message-Id: <20130506.221041.791311536256132344.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bruce.w.allan@intel.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367883166.16445.13.camel@jtkirshe-mobl>
References: <CA+55aFzQ8MzrmPQNPfLFA3nVQVDR3HL+RwcGrAwanJCKRxL2=A@mail.gmail.com>
	<20130506.190922.168696209163637134.davem@davemloft.net>
	<1367883166.16445.13.camel@jtkirshe-mobl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 May 2013 19:10:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 06 May 2013 16:32:46 -0700

> On Mon, 2013-05-06 at 19:09 -0400, David Miller wrote:
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Mon, 6 May 2013 15:57:15 -0700
>> 
>> > On Mon, May 6, 2013 at 2:05 PM, David Miller <davem@davemloft.net> wrote:
>> >>
>> >> Just a small pile of fixes:
>> > 
>> > Ok, apparently the e1000e problem didn't get fixed yet. Should I just
>> > revert ce43a2168c59 for now, or do we have a fix for that forthcoming
>> > shortly?
>> 
>> It is coming very shortly.
> 
> I am preparing the patch now to send upstream...

Jeff, I have an early plane to catch so I have to get to bed now.

Please just send Linus the fix directly, thanks.
