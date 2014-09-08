Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaIHEvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 00:51:00 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65448 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaIHEu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 00:50:59 -0400
Date: Mon, 8 Sep 2014 13:50:54 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [GIT PULL] cgroup fixes for v3.17-rc4
Message-ID: <20140908045054.GA8526@mtj.dyndns.org>
References: <20140908012025.GF5061@mtj.dyndns.org>
 <CA+55aFw+L1EUDEmAATDtGj_ngHos842jHLddAszboRy4b0pn2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+L1EUDEmAATDtGj_ngHos842jHLddAszboRy4b0pn2A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Sun, Sep 07, 2014 at 08:17:11PM -0700, Linus Torvalds wrote:
> In other words, I'll happily pull this, but your excuses for it are
> wrong-headed. There is no "crazyness justifies this". That's crap. But
> the argument of "nobody does this, so let's fix it before anybody
> _starts_ doing it" is perfectly valid - with the deep and implicit
> understanding that if it turns out somebody *does* do it, the change
> gets reverted asap.

Yeap, that's the intention which I failed to articulate.  It's highly
unlikely to be in use currently and would already be noticeably
breaking things.  Given that it's justified to try to ban '\n' usage
and see whether anybody reports regression from that.  Will describe
similar situations more accruately from now on.

Thanks.

-- 
tejun
