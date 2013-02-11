Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3BKJ0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:26:08 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48200 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3BKJ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:26:06 -0500
Date: Mon, 11 Feb 2013 10:26:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: at net/core/neighbour.c:1545 neigh_table_init()
Message-ID: <20130211092600.GB23932@gmail.com>
References: <20130209123937.GA23420@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130209123937.GA23420@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fengguang Wu <fengguang.wu@intel.com> wrote:

> Greetings,
> 
> I got the below oops in linux-next and the first bad commit is
> 
> commit 455e987c0c2eb2c9045dc854559474cf41509965
> Merge: 7c17e48 fd6da69
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Dec 1 13:07:48 2012 -0800
> 
>     Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

This bisection result is probably spurious?

Thanks,

	Ingo
