Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab3KHUO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:14:58 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44861 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3KHUO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:14:56 -0500
Date: Fri, 8 Nov 2013 15:23:07 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
In-Reply-To: <20131108200244.GB14606@localhost.localdomain>
Message-ID: <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu> <20131108200244.GB14606@localhost.localdomain>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013, Frederic Weisbecker wrote:
> 
> There seem to be a loop that takes too long in intel_pmu_handle_irq(). Your two
> previous reports seemed to suggest that lbr is involved, but not this one.

I may be wrong but I think everything between <NMI> and <EOE> is just
noise from the NMI perf-event watchdog timer kicking in.

Why that code would be reading the LBR registers I don't know.

Vince


