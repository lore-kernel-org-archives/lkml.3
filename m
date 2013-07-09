Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3GITdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:33:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58513 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3GITdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:33:33 -0400
Date: Tue, 09 Jul 2013 12:33:30 -0700 (PDT)
Message-Id: <20130709.123330.253388383875496669.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        dwmw2@infradead.org, eliezer@tamir.org.il
Subject: Re: [PATCH net-next v2] net/fs: change busy poll time accounting
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130709100921.21602.46444.stgit@ladj378.jer.intel.com>
References: <20130709100921.21602.46444.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Tue, 09 Jul 2013 13:09:21 +0300

> Sorry, I forgot to commit before sending, so I sent the wrong version.
> The previous version gets a warning in busy_loop_timeout().
> 
> Suggested by Linus:
> Changed time accounting for busy-poll:
> - Make it microsecond based.
> - Use unsigned longs.
> - Revert back to use time_after instead of time_in_range.
> Reorder poll/select busy loop conditions:
> - Clear busy_flag after one time we can't busy-poll.
> - Only init busy_end if we actually are going to busy-poll.
> Added one more missing need_resched() test.
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>

Ok, looks good, applied.

Thanks!
