Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818AbaBGHxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:53:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38924 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaBGHxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:53:04 -0500
Date: Fri, 7 Feb 2014 08:52:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Davies <junk@eslaf.co.uk>
Cc: Vince Weaver <vince@deater.net>, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf,x86,p6: Add userspace RDPMC quirk for P6
Message-ID: <20140207075256.GO5002@laptop.programming.kicks-ass.net>
References: <20140205102718.GF3229@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy>
 <20140205192012.GL2936@laptop.programming.kicks-ass.net>
 <20140205194851.GE5126@laptop.programming.kicks-ass.net>
 <871tzgxc3y.fsf@gw.eslaf.co.uk>
 <20140206203803.GL5002@laptop.programming.kicks-ass.net>
 <87eh3fhoqs.fsf@gw.eslaf.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh3fhoqs.fsf@gw.eslaf.co.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 10:15:23PM +0000, Mark Davies wrote:
> That fixed it. Booted patched 3.4.78 with CONFIG_APM=y with no problem.

Awesome, thanks!
