Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127AbaDIRk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:40:28 -0400
Received: from one.firstfloor.org ([193.170.194.197]:38399 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbaDIRk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:40:26 -0400
Date: Wed, 9 Apr 2014 19:40:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Message-ID: <20140409174024.GB22728@two.firstfloor.org>
References: <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
 <20140226185513.GL22728@two.firstfloor.org>
 <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
 <530E3E47.8010205@gmail.com>
 <CALCETrUHiDqT+VRbdEnGsEkMFqQt+ZqX+RTenp1ets8XMhrQ2Q@mail.gmail.com>
 <530E4B42.5090401@gmail.com>
 <CALCETrUA_JSDepFnKYsrDD5CQX65k4z_XeSxc4RxmhB2RahBZA@mail.gmail.com>
 <20140409114857.GT11096@twins.programming.kicks-ass.net>
 <20140409164852.GA22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409164852.GA22728@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW the whole discussion is rather pointless.

We have to profile the software as it is, not as we wish it to be.

That means: small functions, often no frame pointer, all kinds of crappy
code and missing information.

And then doing it all with as little overhead as possible.

I think on these metrics callstack LBR is attractive for many
(but not all) cases.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
