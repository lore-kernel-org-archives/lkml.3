Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaELKfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:35:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaELKfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:35:12 -0400
Date: Mon, 12 May 2014 11:35:05 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Weijie Yang <weijieut@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] plist: add helper functions
Message-ID: <20140512103505.GL23991@suse.de>
References: <1397336454-13855-1-git-send-email-ddstreet@ieee.org>
 <1399057350-16300-1-git-send-email-ddstreet@ieee.org>
 <1399057350-16300-3-git-send-email-ddstreet@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1399057350-16300-3-git-send-email-ddstreet@ieee.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 03:02:28PM -0400, Dan Streetman wrote:
> Add PLIST_HEAD() to plist.h, equivalent to LIST_HEAD() from list.h, to
> define and initialize a struct plist_head.
> 
> Add plist_for_each_continue() and plist_for_each_entry_continue(),
> equivalent to list_for_each_continue() and list_for_each_entry_continue(),
> to iterate over a plist continuing after the current position.
> 
> Add plist_prev() and plist_next(), equivalent to (struct list_head*)->prev
> and ->next, implemented by list_prev_entry() and list_next_entry(), to
> access the prev/next struct plist_node entry.  These are needed because
> unlike struct list_head, direct access of the prev/next struct plist_node
> isn't possible; the list must be navigated via the contained struct list_head.
> e.g. instead of accessing the prev by list_prev_entry(node, node_list)
> it can be accessed by plist_prev(node).
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> 

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
