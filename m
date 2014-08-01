Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaHAUsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:48:55 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:47729 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbaHAUsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:48:53 -0400
Message-ID: <1406926131.16021.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jirka Hladky <jhladky@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Aaron Lu <aaron.lu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Date: Fri, 01 Aug 2014 13:48:51 -0700
In-Reply-To: <1406926000.16021.6.camel@buesod1.americas.hpqcorp.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
	 <53D72FF5.90908@intel.com> <20140729023940.37b6aebc@annuminas.surriel.com>
	 <20140731104241.GA9918@twins.programming.kicks-ass.net>
	 <20140731155723.GY3588@twins.programming.kicks-ass.net>
	 <53DA6BDA.8080000@redhat.com>
	 <1406926000.16021.6.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 13:46 -0700, Davidlohr Bueso wrote:
> So both these are pretty similar, however, when reverting, on avg we
> increase the amount of bops a mere ~4%:
> 
> tip/master + reverted:

Just to be clear, this is reverting a43455a1d57.

