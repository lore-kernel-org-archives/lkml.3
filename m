Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3FDLDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:03:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51398 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3FDLD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:03:28 -0400
Date: Tue, 4 Jun 2013 13:03:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: add const qualifier to perf_pmu_register's 'name'
 arg
Message-ID: <20130604110314.GN8923@twins.programming.kicks-ass.net>
References: <1370339148-5566-1-git-send-email-mjonker@synopsys.com>
 <20130604095801.GM8923@twins.programming.kicks-ass.net>
 <51ADBB1D.9060805@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ADBB1D.9060805@synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 03:32:05PM +0530, Vineet Gupta wrote:
> On 06/04/2013 03:28 PM, Peter Zijlstra wrote:
> > On Tue, Jun 04, 2013 at 11:45:48AM +0200, Mischa Jonker wrote:
> >> This allows us to use pdev->name for registering a PMU device.
> >> IMO the name is not supposed to be changed anyway.
> >>
> > Indeed, and thanks! 
> >
> > PS. WTH is a metag?
> 
> It's the cpu core from Imagination Tech - their port got merged in 3.9 (along with
> ARC from Synopsys).

So its Meta-G, not me-tag :-) Google gave me the below, its not exactly
clear what kind of animal it is or what the G stands for. Too much
marketing speak, too little useful information.

http://www.imgtec.com/meta/meta-technology.asp

Simlar 'complaint' for the ARC stuff really, only marketing speak :-)


