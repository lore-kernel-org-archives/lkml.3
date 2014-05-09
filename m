Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaEIVRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:17:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:2923 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932341AbaEIVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:17:42 -0400
Date: Fri, 9 May 2014 17:17:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Weijie Yang <weijieut@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Shaohua Li <shli@fusionio.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] plist: make CONFIG_DEBUG_PI_LIST selectable
Message-ID: <20140509171733.4d5a475e@gandalf.local.home>
In-Reply-To: <1399668144-19738-1-git-send-email-ddstreet@ieee.org>
References: <20140505191341.GA18397@home.goodmis.org>
	<1399668144-19738-1-git-send-email-ddstreet@ieee.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 May 2014 16:42:24 -0400
Dan Streetman <ddstreet@ieee.org> wrote:

> Change CONFIG_DEBUG_PI_LIST to be user-selectable, and add a
> title and description.  Remove the dependency on DEBUG_RT_MUTEXES
> since they were changed to use rbtrees, and there are other users
> of plists now.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
