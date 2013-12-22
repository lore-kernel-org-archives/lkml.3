Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3LVUo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 15:44:57 -0500
Received: from 0106ds1-hvi.0.fullrate.dk ([90.184.84.98]:29041 "EHLO
	mail.knielsen-hq.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3LVUoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 15:44:55 -0500
From: Kristian Nielsen <knielsen@knielsen-hq.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Dave Jones <davej@redhat.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: GPF in aio_migratepage
References: <20131126032645.GA32301@redhat.com>
	<20131126060132.GA6400@redhat.com> <20131126071953.GE9244@kmo-pixel>
	<20131126152337.GL15489@kvack.org>
	<87d2lh6h92.fsf@frigg.knielsen-hq.org>
	<529C5CA6.6090708@cn.fujitsu.com> <20131202174913.GA18853@redhat.com>
	<87ob4hu66n.fsf@frigg.knielsen-hq.org>
	<52AE6C4A.9080203@cn.fujitsu.com>
Date: Sun, 22 Dec 2013 21:44:45 +0100
In-Reply-To: <52AE6C4A.9080203@cn.fujitsu.com> (Gu Zheng's message of "Mon, 16
	Dec 2013 10:58:18 +0800")
Message-ID: <871u14ty2q.fsf@frigg.knielsen-hq.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> This issue seems like a problem that has been fixed yet:
> http://article.gmane.org/gmane.linux.kernel.aio.general/3741/match=potential+use+after+free+aio%5fmigratepage
> commit 5e9ae2e5da0beb93f8557fc92a8f4fbc05ea448f
> aio: fix use-after-free in aio_migratepage
> So I think maybe you can run with latest Linus' tree or 3.13-rc4 to
> check whether this issue still appears.

Hm. I checked that thread, and as far as I can see, that patch was already
included in the tree I hit the BUG in (3.13-rc1):

    http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5e9ae2e5da0beb93f8557fc92a8f4fbc05ea448f

There are other changes in that area since 3.13-rc1 though.

Anyway, I am now running with 3.13-rc4 and will report if I see anything.
Given that I do not have any way to reproduce (I only ever saw this once),
this seems the best that can be done for now.

Thanks for following up on this!

 - Kristian.
