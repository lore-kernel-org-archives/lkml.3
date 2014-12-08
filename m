Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaLHQCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:02:50 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:60376 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbaLHQCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:02:49 -0500
Date: Mon, 8 Dec 2014 11:02:40 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol.c:  Cleaning up function that are not
 used anywhere
Message-ID: <20141208160240.GA21664@phnom.home.cmpxchg.org>
References: <1417884356-3086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417884356-3086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 05:45:56PM +0100, Rickard Strandqvist wrote:
> Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.
> And move BUILD_BUG_ON() to the beginning of memcg_stat_show() instead.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Looks good, thanks for following up.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
