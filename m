Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaBRLCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:02:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53498 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbaBRLCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:02:18 -0500
Date: Tue, 18 Feb 2014 11:01:46 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Drew Richardson <Drew.Richardson@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@redhat.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>
Subject: Re: Perf Oops on 3.14-rc2
Message-ID: <20140218110145.GD4178@mudshark.cambridge.arm.com>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
 <20140218101831.GB4178@mudshark.cambridge.arm.com>
 <20140218105434.GO14089@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218105434.GO14089@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:54:34AM +0000, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 10:18:31AM +0000, Will Deacon wrote:
> > On Mon, Feb 10, 2014 at 10:17:59PM +0000, Drew Richardson wrote:
> > > While adding CPU on/offlining support during perf captures I get an
> > > Oops both on ARM as well as my desktop x86_64. Below is a small
> > > program that duplicates the issue.
> > 
> > [...]
> > 
> > FWIW I can reproduce this easily with -rc3 on my x86 laptop running
> > hackbench in parallel with a tweaked version of your test (using
> > _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF and hotplugging off
> > both CPU2 and CPU3).
> 
> -ENOTEST

Sorry, I trimmed it from my reply since it's not especially concise. It's
inlined in the original post:

  http://lkml.kernel.org/r/20140210221758.GB11542@dreric01-Precision-T1600

Will
