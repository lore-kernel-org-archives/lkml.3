Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3FDLS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:18:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3FDLSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:18:24 -0400
Date: Tue, 4 Jun 2013 13:18:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: add const qualifier to perf_pmu_register's 'name'
 arg
Message-ID: <20130604111816.GP8923@twins.programming.kicks-ass.net>
References: <1370339148-5566-1-git-send-email-mjonker@synopsys.com>
 <20130604095801.GM8923@twins.programming.kicks-ass.net>
 <51ADBB1D.9060805@synopsys.com>
 <20130604110314.GN8923@twins.programming.kicks-ass.net>
 <51ADCAD1.8090900@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ADCAD1.8090900@synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 04:39:05PM +0530, Vineet Gupta wrote:
> On 06/04/2013 04:33 PM, Peter Zijlstra wrote:
> > Simlar 'complaint' for the ARC stuff really, only marketing speak :-) 
> 
> You mean lack of prefix in this case (as opposed to MetaG).

Nah, lack of proper (!markting speak) introduction to the arch ;-)

Is there something like the Intel SDM for these archs, if so, do we want
to make it easier to find them for people?

> Anyhow, this patch served a lot more purpose than Mischa really wanted - formally
> introduced you to two new architectures ;-)

Yah.. it seems archs sneak up on you these days.
