Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaDKRjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:39:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57107 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaDKRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:39:19 -0400
Date: Fri, 11 Apr 2014 13:39:17 -0400 (EDT)
Message-Id: <20140411.133917.994491919904460059.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: linux@arm.linux.org.uk, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: Re: [PATCH 03/15] arm: add renameat2 syscall
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAJfpegsbS8M4L7jKUfgw88wWnt7NYtSe5LHTsVF_oTL94xm=Fw@mail.gmail.com>
References: <1397211951-20549-4-git-send-email-miklos@szeredi.hu>
	<20140411103507.GK16119@n2100.arm.linux.org.uk>
	<CAJfpegsbS8M4L7jKUfgw88wWnt7NYtSe5LHTsVF_oTL94xm=Fw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Apr 2014 10:39:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 11 Apr 2014 13:48:05 +0200

> It would probably have been a good idea to CC all maintainers on the
> cover letter, but I don't know how I could do that with "git
> send-email".

I strongly suggest that this _not_ be done.

There is a 1024 character limit imposed for email header fields in order
to reduce spam at vger.kernel.org

We have lists like linux-arch for a reason, CC:'ing tons of people who
should absolutely be on that list doesn't make any sense at all and
as I just described is not going to work.
