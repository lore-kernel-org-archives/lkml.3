Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbaJ2PGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:06:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:26895 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbaJ2PGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:06:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,810,1406617200"; 
   d="scan'208";a="622820153"
Date: Wed, 29 Oct 2014 07:49:44 -0700
From: Patrick Lu <patrick.lu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH 2/5] perf, x86, uncore: Add Haswell-EP uncore support
Message-ID: <20141029144944.GA10491@debian-x64.ch.intel.com>
References: <CAADnVQL3X_UqA1Oz1msuz8LyP0CTGG5iy16YwjdPUhoNTk31yQ@mail.gmail.com>
 <20141029031115.GW12538@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029031115.GW12538@two.firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:11:15AM +0100, Andi Kleen wrote:
> > 
> > yes. removing line 'hswep_uncore_sbox' also worked as workaround.
> > You have an idea what's going on?
> 
> Not yet. I don't see it on my own systems, so it's something that's
> different on yours.
Hi Andi, I am experiencing the same crash using E5-2658v3 CPU in our lab in Chandler. I can
provide remote access for you to take a look.

Also, I used your ucevents.py to check out IRP counter, and it looks like
it's reporting half of what I'm expecting. Do you know if the script/PMU
program for both IRP0 and IRP1?

Patrick
> 
> > I suspect other folks will see the same crash when E5 v3
> > become more widespread.
> 
> I guess we can disable the sbox for now. 
> 
> -Andi
> > 
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
