Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136AbaDTU7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 16:59:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaDTU7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 16:59:31 -0400
Date: Sun, 20 Apr 2014 21:59:23 +0100
From: Mel Gorman <mgorman@suse.de>
To: John Stoffel <john@stoffel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default v2
Message-ID: <20140420205923.GA23991@suse.de>
References: <1396945380-18592-1-git-send-email-mgorman@suse.de>
 <20140418130543.8619064c0e5d26cd914c4c3c@linux-foundation.org>
 <21329.36761.970643.523119@quad.stoffel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <21329.36761.970643.523119@quad.stoffel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 04:48:25PM -0400, John Stoffel wrote:
> >>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:
> 
> Andrew> On Tue,  8 Apr 2014 09:22:58 +0100 Mel Gorman <mgorman@suse.de> wrote:
> >> Changelog since v1
> >> o topology comment updates
> >> 
> >> When it was introduced, zone_reclaim_mode made sense as NUMA distances
> >> punished and workloads were generally partitioned to fit into a NUMA
> >> node. NUMA machines are now common but few of the workloads are NUMA-aware
> >> and it's routine to see major performance due to zone_reclaim_mode being
> >> enabled but relatively few can identify the problem.
> 
> 
> This is unclear here.  "see major performance <what> due" doesn't make
> sense to me.  
> 

Degradation

-- 
Mel Gorman
SUSE Labs
