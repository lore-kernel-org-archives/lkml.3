Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3KUMj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:39:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:47509 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751491Ab3KUMj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:39:57 -0500
Date: Thu, 21 Nov 2013 07:39:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121123954.GA8044@home.goodmis.org>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121120605.GC26009@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 01:06:05PM +0100, Borislav Petkov wrote:
> 
> No, I absolutely don't think it is a bikeshedding exercise too. We
> really need that lib because people have started growing their own
> facilities in tools/ and outside so having a lib which implements
> generic functionality for interfacing with the kernel right is going to
> save everyone a lot of time and energy.

Should we put libtraceevent here too? Have all kapi functionality live here?

As libtraceevent is getting mature, we need to get it out as a real library
soon. There is already three utilities that use it: perf, trace-cmd and 
powertop. And I've heard of others that want that functionatity.

-- Steve

