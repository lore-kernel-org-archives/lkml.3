Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3JBMki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:40:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45080 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3JBMkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:40:36 -0400
Date: Wed, 2 Oct 2013 14:40:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>
Subject: Re: PERF_EVENT_IOC_SET_OUTPUT
Message-ID: <20131002124023.GC28601@twins.programming.kicks-ass.net>
References: <524B1E7C.3070108@intel.com>
 <20131002100350.GO3081@twins.programming.kicks-ass.net>
 <20131002102954.GD7941@localhost.localdomain>
 <20131002112730.GQ3081@twins.programming.kicks-ass.net>
 <20131002122900.GA27811@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002122900.GA27811@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 02:29:01PM +0200, Ingo Molnar wrote:
> 
> Btw., this does not seem to be working very well when the perf context is 
> inherited:

https://lkml.org/lkml/2011/7/21/124

Never figured that one out :-(
