Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357Ab3GaPoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:44:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46959 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab3GaPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:44:07 -0400
Date: Wed, 31 Jul 2013 21:13:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Andrew Theurer <habanero@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/10] Improve numa scheduling by consolidating tasks
Message-ID: <20130731154355.GD4880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
 <1375277624.11541.27.camel@oc6622382223.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1375277624.11541.27.camel@oc6622382223.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073115-3620-0000-0000-000003C126A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Theurer <habanero@linux.vnet.ibm.com> [2013-07-31 08:33:44]:
>              -----------    -----------    -----------    -----------  
>  VM-node00|   49153(006%)   673792(083%)    51712(006%)   36352(004%) 
> 
> I think the consolidation is a nice concept, but it needs a much tighter
> integration with numa balancing.  The action to clump tasks on same node's
> runqueues should be triggered by detecting that they also access
> the same memory.
> 

Thanks Andrew for testing and reporting your results and analysis.
Will try to focus on getting consolidation + tighter integration with
numa balancing.

-- 
Thanks and Regards
Srikar Dronamraju

