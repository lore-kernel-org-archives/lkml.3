Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3HTSxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:53:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3HTSw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:52:58 -0400
Date: Tue, 20 Aug 2013 11:52:57 -0700 (PDT)
Message-Id: <20130820.115257.405496925912050870.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: gregkh@linuxfoundation.org, hughd@google.com, johannes@sipsolutions.net,
        bp@alien8.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz
Subject: Re: Linux 3.0.92
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFxrPP8=xPWuRVy0HPyiFkT8Mc03zWGKosg+WrEQfqNDfQ@mail.gmail.com>
References: <20130820155735.GA2805@kroah.com>
	<CA+55aFxrPP8=xPWuRVy0HPyiFkT8Mc03zWGKosg+WrEQfqNDfQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 11:52:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Aug 2013 09:33:30 -0700

> I really think there should be delay before stable picks up stuff from
> mainline, unless it's something particularly critical and
> well-discussed.. Maybe a week or so.

That's how I typically work, I do all the submissions by hand after
they've sit in your tree for at least a week.

But in this case, Johanned added an explicit stable CC: to the commit
message and I failed to remove it, my bad.
