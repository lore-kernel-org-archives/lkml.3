Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaFCADK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:03:10 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49552 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaFCADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:03:06 -0400
Date: Mon, 2 Jun 2014 17:01:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Rientjes <rientjes@google.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: periodically schedule when emptying page
 list
In-Reply-To: <alpine.DEB.2.02.1406021648260.8495@chino.kir.corp.google.com>
Message-ID: <alpine.LSU.2.11.1406021658050.5784@eggly.anvils>
References: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com> <alpine.LSU.2.11.1406021637170.5627@eggly.anvils> <alpine.DEB.2.02.1406021648260.8495@chino.kir.corp.google.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014, David Rientjes wrote:
> On Mon, 2 Jun 2014, Hugh Dickins wrote:
> 
> > Why not just move that cond_resched() down below the if/else?
> > No need to test need_resched() separately, and this page is not busy.
> > 
> 
> Would you like to propose your version from our kernel instead?

If that's how you prefer to work it, sure.  The patch would indeed
look uncannily like what I put in our kernel a week ago; but I think
the description might owe a lot to you!  I'll get to it later, while
secretly hoping you get to it sooner :)

Hugh
