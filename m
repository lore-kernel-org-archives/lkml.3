Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaDPEOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:14:00 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46943 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaDPEN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:13:57 -0400
Date: Wed, 16 Apr 2014 13:13:54 +0900
From: Simon Horman <horms@verge.net.au>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] sh: clk: Use cpufreq_for_each_valid_entry macro
 for iteration
Message-ID: <20140416041354.GB31272@verge.net.au>
References: <534DB238.5030201@semaphore.gr>
 <20140416011120.GC8833@verge.net.au>
 <20140416012454.GA3941@verge.net.au>
 <CAKohponxbA_rPFF=vzZEnjYkLLCkNOWHP7kxAUZ5mKpTPp_Myw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponxbA_rPFF=vzZEnjYkLLCkNOWHP7kxAUZ5mKpTPp_Myw@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 09:30:24AM +0530, Viresh Kumar wrote:
> On 16 April 2014 06:54, Simon Horman <horms@verge.net.au> wrote:
> > I have dropped this patch.
> >
> > Please let me know if there is a stable branch which
> > includes cpufreq_frequency_table which I can use as a base to apply
> > this patch.
> >
> > Alternatively, I would be happy to Ack this patch and let someone
> > else pick up this patch, but I'm entirely unclear on who that would be.
> 
> Rafael will take this patch, please Ack it :)

Thanks, done.
