Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaGKIaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:30:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:39876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaGKIaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:30:02 -0400
Date: Fri, 11 Jul 2014 10:29:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
Message-ID: <20140711082956.GC20603@laptop.programming.kicks-ass.net>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:37:17PM +0800, Jiang Liu wrote:
> Any comments are welcomed!

Why would anybody _ever_ have a memoryless node? That's ridiculous.
