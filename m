Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaBZSzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:55:17 -0500
Received: from one.firstfloor.org ([193.170.194.197]:55284 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaBZSzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:55:15 -0500
Date: Wed, 26 Feb 2014 19:55:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Message-ID: <20140226185513.GL22728@two.firstfloor.org>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
 <530D53EF.9090706@amacapital.net>
 <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm suggesting a perf event option, just like the way that PEBS works.

Right now it's a somewhat experimental feature and just having 
the sysctl is fine. If it turns out that is what everyone uses
such an option could be still added later.

I suspect most people would still use FP if they can, just use
the LBRs if that doesn't work.

-Andi
