Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaJ2DLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:11:18 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52616 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ2DLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:11:17 -0400
Date: Wed, 29 Oct 2014 04:11:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH 2/5] perf, x86, uncore: Add Haswell-EP uncore support
Message-ID: <20141029031115.GW12538@two.firstfloor.org>
References: <CAADnVQL3X_UqA1Oz1msuz8LyP0CTGG5iy16YwjdPUhoNTk31yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQL3X_UqA1Oz1msuz8LyP0CTGG5iy16YwjdPUhoNTk31yQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> yes. removing line 'hswep_uncore_sbox' also worked as workaround.
> You have an idea what's going on?

Not yet. I don't see it on my own systems, so it's something that's
different on yours.

> I suspect other folks will see the same crash when E5 v3
> become more widespread.

I guess we can disable the sbox for now. 

-Andi
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
