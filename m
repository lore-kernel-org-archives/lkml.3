Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaF3WJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:09:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaF3WJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:09:16 -0400
Date: Mon, 30 Jun 2014 15:09:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/4] mm: page_alloc: Reduce cost of the fair zone
 allocation policy
Message-Id: <20140630150914.6db3805c28c60283deb94206@linux-foundation.org>
In-Reply-To: <20140630215121.GQ10819@suse.de>
References: <1404146883-21414-1-git-send-email-mgorman@suse.de>
	<1404146883-21414-5-git-send-email-mgorman@suse.de>
	<20140630141404.e09bdb5fa6a879d17c4556b1@linux-foundation.org>
	<20140630215121.GQ10819@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 22:51:21 +0100 Mel Gorman <mgorman@suse.de> wrote:

> > That's a large change in system time.  Does this all include kswapd
> > activity?
> > 
> 
> I don't have a profile to quantify that exactly. It takes 7 hours to
> complete a test on that machine in this configuration

That's nuts.  Why should measuring this require more than a few minutes?
