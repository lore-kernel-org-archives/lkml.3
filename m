Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaKJKuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:50:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45142 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaKJKuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:50:32 -0500
Date: Mon, 10 Nov 2014 11:50:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        Norbert Preining <preining@logic.at>, "P. Christeas" <xrg@linux.gr>
Subject: Re: [PATCH] mm, compaction: prevent infinite loop in compact_zone
Message-ID: <20141110105030.GA20052@amd>
References: <1415608710-8326-1-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415608710-8326-1-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  	acct_isolated(zone, cc);
> -	/* Record where migration scanner will be restarted */
> -	cc->migrate_pfn = low_pfn;
> +	/* 

pavel@amd:/data/l/linux$ cat /tmp/delme | git apply
<stdin>:81: trailing whitespace.
	    /* 
warning: 1 line adds whitespace errors.

I have applied the patch, but the bug normally takes a while to
reproduce...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
