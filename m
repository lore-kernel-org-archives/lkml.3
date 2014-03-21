Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbaCUIrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:47:37 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:32776 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631AbaCUIrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:47:35 -0400
Message-ID: <532BFC91.3030505@linux.vnet.ibm.com>
Date: Fri, 21 Mar 2014 14:17:13 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
References: <20140321152303.5e4071c94957a70831edd1a1@canb.auug.org.au>
In-Reply-To: <20140321152303.5e4071c94957a70831edd1a1@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032108-5564-0000-0000-00000C9C7A9A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:53 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> arch/x86/kernel/cpu/perf_event_intel_uncore.c between commit 2c666adacc9e
> ("x86, intel, uncore: Fix CPU hotplug callback registration") from Linus'
> tree and commit 411cf180fa00 ("perf/x86/uncore: fix initialization of
> cpumask") from the tip tree.
> 
> I fixed it up (maybe incorrectly - see below) and can carry the fix as
> necessary (no action is required).
> 

The fix looks good to me. Thank you!

Regards,
Srivatsa S. Bhat

