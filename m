Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3FRJJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:09:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38000 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3FRJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:09:29 -0400
Date: Tue, 18 Jun 2013 11:09:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dzickus@redhat.com,
        ak@linux.intel.com, jolsa@redhat.com
Subject: Re: [PATCH] perf,x86: fix broken PEBS-LL support on SNB-EP/IVB-EP
Message-ID: <20130618090920.GF3204@twins.programming.kicks-ass.net>
References: <20130607212210.GA11849@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607212210.GA11849@quad>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:22:10PM +0200, Stephane Eranian wrote:
> 
> This patch fixes broken support of PEBS-LL on SNB-EP/IVB-EP.
> For some reason, the LDLAT extra reg definition for snb_ep
> showed up as duplicate in the snb table.
> 
> This patch moves the definition of LDLAT back into the
> snb_ep table.
> 
> Thanks to Don Zickus for tracking this one down.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks!
