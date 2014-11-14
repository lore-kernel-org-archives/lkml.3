Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049AbaKNMfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:35:38 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62467 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161020AbaKNMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:35:37 -0500
Date: Fri, 14 Nov 2014 12:35:33 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20141114123533.GO1292@console-pimps.org>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
 <20141107123431.GE3337@twins.programming.kicks-ass.net>
 <20141107123836.GH10476@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107123836.GH10476@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov, at 01:38:36PM, Peter Zijlstra wrote:
> 
> For optional goodness:
> 
> 		if (nr_limbo > max_scan_size)
> 			break;
> 
> Which will limit the number of RMIDs you'll scan from the IPI, and
> thereby limit the time taken there.

To limit the amount of magic numbers we've got in this code, I'm going
to punt on this optional feature.

That is, unless you can provide a value for max_scan_size.

-- 
Matt Fleming, Intel Open Source Technology Center
