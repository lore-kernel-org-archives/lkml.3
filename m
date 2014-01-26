Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaAZP1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 10:27:36 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:53223 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaAZP1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 10:27:35 -0500
Date: Sun, 26 Jan 2014 10:27:28 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, oom: base root bonus on current usage
Message-ID: <20140126152728.GY6963@cmpxchg.org>
References: <20140115234308.GB4407@cmpxchg.org>
 <alpine.DEB.2.02.1401151614480.15665@chino.kir.corp.google.com>
 <20140116070709.GM6963@cmpxchg.org>
 <alpine.DEB.2.02.1401212050340.8512@chino.kir.corp.google.com>
 <20140124040531.GF4407@cmpxchg.org>
 <alpine.DEB.2.02.1401251942510.3140@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401251942510.3140@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 07:48:32PM -0800, David Rientjes wrote:
> A 3% of system memory bonus is sometimes too excessive in comparison to 
> other processes and can yield poor results when all processes on the 
> system are root and none of them use over 3% of memory.
> 
> Replace the 3% of system memory bonus with a 3% of current memory usage 
> bonus.
> 
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Looks good, thanks a lot!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
