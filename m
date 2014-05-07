Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaEGSYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:24:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49877 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaEGSY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:24:26 -0400
Date: Wed, 7 May 2014 22:24:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140507182410.GA8607@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu>
 <20140506214630.GB1458@moon>
 <alpine.DEB.2.10.1405071244570.6340@vincent-weaver-1.umelst.maine.edu>
 <20140507164902.GD1444@moon>
 <20140507165811.GG1444@moon>
 <alpine.DEB.2.10.1405071305010.6340@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405071305010.6340@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 01:07:40PM -0400, Vince Weaver wrote:
> > 
> > Vince, I'm trying to figure out where it might come from, but no
> > ideas yet.
> 
> I just got this, also looks like poison (see RBX).

Indeed, except ending 2b value.

> This could be related to the ongoing memory corruption bug found in 
> another thread and not p4-related at all.
> 
> I thought I was running with PeterZ's latest patch that was supposed to 
> avoid the corruption.  Hmmm.  Let me reboot and try a few more things.

Thanks! Please ping me if find something new.
