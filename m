Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061AbaCSM4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:56:00 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59631 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965020AbaCSMz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:55:59 -0400
Date: Wed, 19 Mar 2014 13:55:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        acme@infradead.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140319125555.GA19317@gmail.com>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
 <1395133004-23205-4-git-send-email-zheng.z.yan@intel.com>
 <20140319084917.GE27632@laptop.programming.kicks-ass.net>
 <20140319113254.GA18351@gmail.com>
 <20140319114247.GI27632@laptop.programming.kicks-ass.net>
 <20140319115323.GA18672@gmail.com>
 <20140319124431.GN27632@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319124431.GN27632@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Mar 19, 2014 at 12:53:23PM +0100, Ingo Molnar wrote:
> > >
> > > Ah; but do you want this config option hidden in the "Processor 
> > > type and features" menu or would they be better in "General 
> > > setup/Kernel Performance Events and Counters" ?
> > 
> > What's your preference? There's a vali argument for both: the 
> > uncore driver is part of the CPU, but it's also a perf driver.
> 
> My initial thought was having it in the perf menu because that's 
> relatively easy to find and not big and cluttered (yet) like the 
> arch menu is.
> 
> I actually had to double check I had the right patches applied 
> because I couldn't find it the first time.

Okay, agreed, lets do it that way. It's also the better choice UI 
wise: arguably people will associate this driver with 'perf', not with 
CPU features.

Thanks,

	Ingo
