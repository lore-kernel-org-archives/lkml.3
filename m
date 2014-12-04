Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaLDGww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:52:52 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45888 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaLDGwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:52:51 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 4 Dec 2014 15:56:22 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Chintan Pandya <cpandya@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Dave Hansen <dave@sr71.net>, Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/8] mm/page_owner: keep track of page owners
Message-ID: <20141204065622.GB12141@js1304-P5Q-DELUXE>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1416816926-7756-7-git-send-email-iamjoonsoo.kim@lge.com>
 <547F0EF8.5030402@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547F0EF8.5030402@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 06:54:08PM +0530, Chintan Pandya wrote:
> Hi Kim,

Hello, Chintan.

> 
> This is really useful stuff that you are doing. And the runtime
> allocation for storing page owner stack is a good call.
> 
> Along with that, we also use extended version of the original
> page_owner patch. The extension is, to store stack trace at the time
> of freeing the page. That will indeed eat up space like anything
> (just double of original page_owner) but it helps in debugging some
> crucial issues. Like, illegitimate free, finding leaked pages (if we

Sound really interesting. I hope to see it.

> store their time stamps) etc. The same has been useful in finding
> double-free cases in drivers. But we have never got a chance to
> upstream that. Now that these patches are being discussed again, do
> you think it would be good idea to integrate in the same league of
> patches ?

Good to hear. I think that you can upstream it separately. If you send
the patch, I will review it and help to merge it.

Thanks.
