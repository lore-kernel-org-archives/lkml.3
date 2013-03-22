Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab3CVPMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:12:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510Ab3CVPMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:12:54 -0400
Date: Fri, 22 Mar 2013 16:10:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 0/7] uretprobes: return probes implementation
Message-ID: <20130322151034.GC17286@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-1-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Anton Arapov wrote:
>
>   this is core implementation of the uretprobes. This enables a breakpoint
> on function's return for the tools such as perf.

And, before we ask Ingo to pull, we should teach trace_uprobe.c to handle
"perf -x func%return".

This looks simple, but probably we need to add the additional "ulong bp_vaddr"
argument for rp_handler().

Oleg.

