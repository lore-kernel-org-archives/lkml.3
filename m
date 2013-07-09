Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab3GIC1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 22:27:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47908 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3GIC1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 22:27:07 -0400
Date: Mon, 08 Jul 2013 19:27:06 -0700 (PDT)
Message-Id: <20130708.192706.1245480344087449229.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: eliezer.tamir@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, akpm@linux-foundation.org, dwmw2@infradead.org,
        eliezer@tamir.org.il
Subject: Re: [PATCH net-next] net: rename low latency sockets functions to
 busy poll
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwWAmHhYaPWVm7rsqiD9+RhDPpgVC1yWc0oNmP38bty4Q@mail.gmail.com>
References: <CA+55aFxgrOtsv7vCtic97ehpvqyezCzDcyqHVD+821BiTuiRtw@mail.gmail.com>
	<51DAF373.4040606@linux.intel.com>
	<CA+55aFwWAmHhYaPWVm7rsqiD9+RhDPpgVC1yWc0oNmP38bty4Q@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 8 Jul 2013 12:37:06 -0700

> I think it's getting closer, and I'm ok with the last final details
> being sorted out later. I just can't reasonably test any of my
> suggestions, so I'd like to get it to a point where when I pull, I
> don't feel like I'm pulling core code that I really detest. And the
> VFS layer in particular I'm pretty attached to.

So I've applied Eliezer's rename patch and will send another pull
request once he also takes care of the reduction of the number and
size of the variables used to track the poll timestamps.

Thanks.
