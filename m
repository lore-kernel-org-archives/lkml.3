Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3D2UcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:32:21 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:38407 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab3D2UcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:32:20 -0400
Date: Mon, 29 Apr 2013 13:32:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a sysctl for numa_balancing.
In-Reply-To: <20130429084113.GI2144@suse.de>
Message-ID: <alpine.DEB.2.02.1304291331570.31525@chino.kir.corp.google.com>
References: <1366847784-29386-1-git-send-email-andi@firstfloor.org> <20130429084113.GI2144@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Mel Gorman wrote:

> On Wed, Apr 24, 2013 at 04:56:24PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > As discussed earlier, this adds a working sysctl to enable/disable
> > automatic numa memory balancing at runtime.
> > 
> > This was possible earlier through debugfs, but only with special
> > debugging options set. Also fix the boot message.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> 

Acked-by: David Rientjes <rientjes@google.com>

> Would you like to merge the following patch with it to remove the TBD?
> 
> ---8<---
> mm: numa: Document remaining automatic NUMA balancing sysctls
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>
