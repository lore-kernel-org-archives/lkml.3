Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaE1N4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:56:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57370 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaE1N4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:56:19 -0400
Date: Wed, 28 May 2014 15:56:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140528135617.GA25750@amd.pavel.ucw.cz>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So just to be difficult I fired up the perf_fuzzer on a Pentium 4 machine.
> 
> It crashes more or less instantly (sorry for the line wrapping, 
> just got the serial console hooked up and don't have minicom configured 
> right yet).
> 
> this is 3.15-rc4 with the anti-memory corruption patch applied.
> 
> [   67.872274] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331

Pentium 4 's were not 64bit, were they?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
