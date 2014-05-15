Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaEOTRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:17:24 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:37830 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaEOTRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:17:23 -0400
Date: Thu, 15 May 2014 15:17:20 -0400
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
Message-ID: <20140515191720.GA21306@htj.dyndns.org>
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com>
 <20140515191338.19811.72313.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515191338.19811.72313.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 12:43:44AM +0530, Srivatsa S. Bhat wrote:
> During CPU offline, stop-machine is used to take control over all the online
> CPUs (via the per-cpu stopper thread) and then run take_cpu_down() on the CPU
> that is to be taken offline.
...
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
