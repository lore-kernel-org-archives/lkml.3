Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbaEFPqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:46:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:33376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbaEFPqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:46:43 -0400
Date: Tue, 6 May 2014 17:46:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140506154637.GW26782@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 11:42:58AM -0400, Vince Weaver wrote:
> 
> So just to be difficult I fired up the perf_fuzzer on a Pentium 4 machine.
> 
> It crashes more or less instantly (sorry for the line wrapping, 
> just got the serial console hooked up and don't have minicom configured 
> right yet).
> 
> this is 3.15-rc4 with the anti-memory corruption patch applied.

*sigh*.. the one x86 PMU driver I really don't know. I might actually
have some P4 class hardware, I'll try and get it wired up this week
somewhere.
