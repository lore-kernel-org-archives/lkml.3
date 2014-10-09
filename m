Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaJIIbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:31:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJIIbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:31:03 -0400
Date: Thu, 9 Oct 2014 10:30:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: lizefan@huawei.com, anton@samba.org, tj@kernel.org,
        svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Message-ID: <20141009083046.GP10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54364564.3090305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
> We observed this on ubuntu kernel, in which systemd explicitly mounts

Using systemd is your first fail.. total crapfest that.
